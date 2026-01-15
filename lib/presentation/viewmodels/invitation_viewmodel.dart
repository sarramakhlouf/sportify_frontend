import 'package:flutter/material.dart';
import 'package:sportify_frontend/core/network/stomp_websocket_service.dart';
import 'package:sportify_frontend/core/storage/token_storage.dart';
import 'package:sportify_frontend/domain/entities/invitation.dart';
import 'package:sportify_frontend/domain/usecases/AcceptInvitation.dart';
import 'package:sportify_frontend/domain/usecases/get_pending_invitations.dart';
import 'package:sportify_frontend/domain/usecases/invite_player_usecase.dart';
import 'package:sportify_frontend/domain/usecases/refuseInvitation.dart';

class InvitationViewModel extends ChangeNotifier {
  final InvitePlayerUsecase invitePlayerUseCase;
  final GetPendingInvitationsUseCase getPendingInvitationsUseCase;
  final AcceptInvitationUseCase acceptInvitationUseCase;  
  final RefuseInvitationUseCase refuseInvitationUseCase;
  final StompWebSocketService _stompService = StompWebSocketService();

  InvitationViewModel(
    this.invitePlayerUseCase,
    this.getPendingInvitationsUseCase,
    this.acceptInvitationUseCase,
    this.refuseInvitationUseCase,
  );

  bool isLoading = false;
  String? error;
  int pendingCount = 0;
  List<Invitation> pendingInvitations = [];

  Future<void> connectWebSocket(String userId) async {
    final token = await TokenStorage.getAccessToken();
    if (token == null) {
      print("❌ Aucun token trouvé pour WebSocket");
      return;
    }

    _stompService.connect(
      userId: userId,
      token: token,
      onNotification: (notif) {
        if (notif.type == 'INVITATION_RECEIVED') {
          final invitation = Invitation(
            id: notif.id,
            teamId: notif.teamId ?? '',
            senderId: notif.senderId ?? '',
            receiverId: userId,
            teamName: notif.teamName ?? '',
            status: 'PENDING',
            createdAt: notif.createdAt,
          );
          addInvitation(invitation);
        }
      },
    );

    print("✅ STOMP WebSocket connecté pour les invitations");
  }

  @override
  void dispose() {
    _stompService.disconnect();
    super.dispose();
  }

  /// Inviter un joueur
  Future<bool> invite({
    required String teamId,
    required String senderId,
    required String playerCode,
  }) async {
    if (playerCode.length != 8) {
      error = 'Le code doit contenir 8 caractères';
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await invitePlayerUseCase(
        teamId: teamId,
        senderId: senderId,
        playerCode: playerCode,
      );

      return true;
    } catch (e) {
      final msg = e.toString();

      if (msg.contains('PLAYER_NOT_FOUND')) {
        error = 'Joueur introuvable';
      } else if (msg.contains('ALREADY_MEMBER')) {
        error = 'Ce joueur est déjà dans l’équipe';
      } else {
        error = 'Erreur lors de l’invitation';
      }

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPending(String userId) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        isLoading = true;
        notifyListeners();
        print("🔹 isLoading set to true");

        final token = await TokenStorage.getAccessToken(); 
        pendingInvitations = await getPendingInvitationsUseCase(userId, token: token);

        print("🔹 pendingInvitations fetched: ${pendingInvitations.length}");
        for (var inv in pendingInvitations) {
          print("  🔸 Invitation: id=${inv.id}, teamId=${inv.teamId}, status=${inv.status}");
        }

        pendingCount = pendingInvitations.length;
      } catch (e) {
        error = 'Erreur lors du chargement des invitations';
         print("❌ loadPending error: $e");
      } finally {
        isLoading = false;
        notifyListeners();
        print("🔹 isLoading set to false, notifyListeners called"); 
      }
    });
  }

  /// Ajouter une invitation reçue en temps réel via WebSocket
  void addInvitation(Invitation invitation) {
    pendingInvitations.insert(0, invitation);
    pendingCount = pendingInvitations.length;
    notifyListeners();
    print("🔹 pendingInvitations updated, count=$pendingCount");
  }

  /// Supprimer une invitation après acceptation ou refus
  void removeInvitation(String invitationId) {
    pendingInvitations.removeWhere((i) => i.id == invitationId);
    pendingCount = pendingInvitations.length;
    notifyListeners();
  }

  /// Accepter une invitation
  Future<void> accept(String invitationId, String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      await acceptInvitationUseCase.execute(invitationId, userId);

      print("🔹 accept successful, removing invitation");
      removeInvitation(invitationId);
    } catch (e) {
      error = 'Erreur lors de l’acceptation de l’invitation';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Refuser une invitation
  Future<void> refuse(String invitationId, String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      // Appel backend pour refuser l'invitation
      await refuseInvitationUseCase.execute(invitationId, userId);

      print("🔹 refuse successful, removing invitation");
      removeInvitation(invitationId);
    } catch (e) {
      error = 'Erreur lors du refus de l’invitation';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
