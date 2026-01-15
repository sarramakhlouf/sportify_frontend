import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/my_created_teams/my_teams_app_bar.dart';
import 'package:sportify_frontend/presentation/widgets/my_created_teams/my_teams_list.dart';

class MyCreatedTeamsScreen extends StatelessWidget {
  const MyCreatedTeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teamVM = context.watch<TeamViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyTeamsAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.emoji_events_outlined,
                    color: Colors.green, size: 18),
                SizedBox(width: 6),
                Text(
                  "Mon équipe créée",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Expanded(
              child: MyTeamsList(teamVM: teamVM),
            ),
          ],
        ),
      ),
    );
  }
}
