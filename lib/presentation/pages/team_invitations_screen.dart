import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/core/storage/token_storage.dart';
import 'package:sportify_frontend/data/models/invitation_model.dart';
import 'package:sportify_frontend/presentation/viewmodels/invitation_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/core/network/stomp_websocket_service.dart';

class TeamInvitationsScreen extends StatefulWidget {
  const TeamInvitationsScreen({super.key});

  @override
  State<TeamInvitationsScreen> createState() => _TeamInvitationsScreenState();
}

class _TeamInvitationsScreenState extends State<TeamInvitationsScreen> {
  late InvitationViewModel inviteVM;
  late AuthViewModel authVM;
  final StompWebSocketService _stompService = StompWebSocketService();

  @override
  void initState() {
    super.initState();

    inviteVM = context.read<InvitationViewModel>();
    authVM = context.read<AuthViewModel>();

    final user = authVM.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await inviteVM.loadPending(user.id);
        final token = await TokenStorage.getAccessToken();
         if (token != null) {
          inviteVM.connectWebSocket(user.id);
        }

        StompWebSocketService().connect(
          userId: user.id,
          token: token!,
          onNotification: (notif) {
            if (!mounted) return; 
            if (notif.type == 'INVITATION_RECEIVED') {
              final invitation = InvitationModel(
                id: notif.id,
                teamId: '',
                senderId: '',
                receiverId: user.id,
                teamName: notif.teamName ?? '',
                status: 'PENDING',
                createdAt: notif.createdAt,
              );
              WidgetsBinding.instance.addPostFrameCallback((_) {
                inviteVM.addInvitation(invitation);
              });
            }
          },
        );

      });
    }
  }

  @override
  void dispose() {
    _stompService.disconnect();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Invitations d'équipe"),
        backgroundColor: Colors.green,
      ),
      body: Consumer<InvitationViewModel>(
        builder: (context, inviteVM, _) {
          if (inviteVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (inviteVM.pendingInvitations.isEmpty) {
            return const Center(child: Text("Aucune invitation en attente"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: inviteVM.pendingInvitations.length,
            itemBuilder: (context, index) {
              final invitation = inviteVM.pendingInvitations[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invitation.teamName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Invitation de l'équipe ${invitation.teamName}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                if (authVM.currentUser != null) {
                                  await inviteVM.refuse(
                                    invitation.id,
                                    authVM.currentUser!.id,
                                  );
                                }
                              },
                              child: const Text("Refuser"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (authVM.currentUser != null) {
                                  await inviteVM.accept(
                                    invitation.id,
                                    authVM.currentUser!.id,
                                  );
                                }
                              },
                              child: const Text("Accepter"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
