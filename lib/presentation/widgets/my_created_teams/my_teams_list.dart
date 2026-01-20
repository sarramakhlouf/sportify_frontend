import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/core/storage/token_storage.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/presentation/pages/team_details_screen.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/my_created_teams/team_card_item.dart';

class MyTeamsList extends StatelessWidget {
  const MyTeamsList({super.key});

  @override
  Widget build(BuildContext context) {
    final teamVM = context.watch<TeamViewModel>();
    final authVM = context.read<AuthViewModel>();

    if (teamVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (teamVM.ownedTeams.isEmpty) {
      return const Center(
        child: Text(
          "Aucune équipe créée",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: teamVM.ownedTeams.length,
      itemBuilder: (context, index) {
        final TeamModel team = teamVM.ownedTeams[index];
        final playersCount = teamVM.teamPlayersCount[team.id] ?? 0;

        return TeamCardItem(
          teamName: team.name,
          city: team.city ?? '',
          teamLogo: team.logoUrl ?? '',
          playersCount: playersCount,
          matchesCount: 0,
          onTap: () async {
            final token = await authVM.getToken();
            if (token == null) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TeamDetailsScreen(team: team),
              ),
            );
          },
          onDelete: () async {
            debugPrint("========================================");
            debugPrint("Suppression de l'équipe depuis TeamCardItem");
            debugPrint("Team ID: ${team.id}");
            debugPrint("Team Name: ${team.name}");
            debugPrint("========================================");

            final token = await TokenStorage.getAccessToken();
            
            if (token == null) {
              if (!context.mounted) return;
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erreur: Token non disponible'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            await teamVM.deleteTeam(
              teamId: team.id!,
              token: token,
            );

            if (!context.mounted) return;

            if (teamVM.error == null) {
              debugPrint("ÉQUIPE SUPPRIMÉE AVEC SUCCÈS");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${team.name} supprimée avec succès'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            } else {
              debugPrint("ERREUR SUPPRESSION: ${teamVM.error}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erreur: ${teamVM.error}'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        );
      },
    );
  }
}