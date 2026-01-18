import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/presentation/pages/team_details_screen.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/my_created_teams/team_card_item.dart';

class MyTeamsList extends StatelessWidget {
  const MyTeamsList({super.key});

  /*void _onTeamTap(BuildContext context, TeamModel team) async {
    final authVM = context.read<AuthViewModel>();
    final teamVM = context.read<TeamViewModel>();

    final token = await authVM.getToken();
    if (token == null) return;

    await teamVM.loadTeamDetails(
      team: team,
      token: token,
    );

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TeamDetailsScreen(),
      ),
    );
  }*/

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

            await teamVM.loadTeamDetails(
              team: team,
              token: token,
            );

            if (!context.mounted) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TeamDetailsScreen(team: team),
              ),
            );
          },
          onDelete: () {
            // teamVM.deleteTeam(team.id!);
          },
        );
      },
    );
  }
}
