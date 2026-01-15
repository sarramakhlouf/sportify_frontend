import 'package:flutter/material.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/my_created_teams/team_card_item.dart';

class MyTeamsList extends StatelessWidget {
  final TeamViewModel teamVM;

  const MyTeamsList({
    super.key,
    required this.teamVM,
  });

  @override
  Widget build(BuildContext context) {
    if (teamVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (teamVM.teams.isEmpty) {
      return const Center(
        child: Text(
          "Aucune équipe créée",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: teamVM.teams.length,
      itemBuilder: (context, index) {
        final team = teamVM.teams[index];
        final playersCount = teamVM.teamPlayersCount[team.id] ?? 0;

        return TeamCardItem(
          teamName: team.name,
          city: team.city ?? '',
          teamLogo: team.logoUrl ?? '',
          playersCount: playersCount,
          matchesCount: 0,
          onDelete: () {
            // teamVM.deleteTeam(team.id!);
          },
        );
      },
    );
  }
}
