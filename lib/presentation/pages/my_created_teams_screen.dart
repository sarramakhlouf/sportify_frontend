import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/core/storage/token_storage.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/my_created_teams/my_teams_app_bar.dart';
import 'package:sportify_frontend/presentation/widgets/my_created_teams/my_teams_list.dart';

class MyCreatedTeamsScreen extends StatefulWidget {
  const MyCreatedTeamsScreen({super.key});

  @override
  State<MyCreatedTeamsScreen> createState() => _MyCreatedTeamsScreenState();
}

class _MyCreatedTeamsScreenState extends State<MyCreatedTeamsScreen> {
  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    final teamVM = context.read<TeamViewModel>();
    final authVM = context.read<AuthViewModel>();

    final ownerId = authVM.currentUser?.id;
    if (ownerId != null) {
      final token = await TokenStorage.getAccessToken();
      if (token != null) {
        teamVM.fetchOwnedTeams(ownerId, token);
      } else {
        print("Token est null, impossible de récupérer les équipes.");
      }
    } else {
      print("OwnerId est null, impossible de récupérer les équipes.");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Icon(
                  Icons.emoji_events_outlined,
                  color: Colors.green,
                  size: 18,
                ),
                SizedBox(width: 6),
                Text(
                  "Mon équipe créée",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<TeamViewModel>(
                builder: (context, teamVM, child) {
                  return MyTeamsList();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}