import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/core/storage/token_storage.dart';
import 'package:sportify_frontend/presentation/pages/create_team_screen.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';

class MyTeamsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MyTeamsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Mes Équipes",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundColor: Colors.green,
            radius: 18,
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              onPressed: () async {
                // Attendre le retour de CreateTeamScreen
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateTeamScreen(),
                  ),
                );

                // Si une équipe a été créée, recharger la liste
                if (result == true && context.mounted) {
                  final teamVM = context.read<TeamViewModel>();
                  final authVM = context.read<AuthViewModel>();
                  
                  final ownerId = authVM.currentUser?.id;
                  if (ownerId != null) {
                    final token = await TokenStorage.getAccessToken();
                    if (token != null) {
                      await teamVM.fetchOwnedTeams(ownerId, token);
                    }
                  }
                }
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}