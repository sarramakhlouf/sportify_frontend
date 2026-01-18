import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/presentation/pages/team_details_screen.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/teams_member/member_info_card.dart';
import 'package:sportify_frontend/presentation/widgets/teams_member/team_card.dart';

class TeamsMemberScreen extends StatefulWidget {
  const TeamsMemberScreen({super.key});

  @override
  State<TeamsMemberScreen> createState() => _TeamsMemberScreenState();
}

class _TeamsMemberScreenState extends State<TeamsMemberScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMemberTeams();
    });
  }

  Future<void> _fetchMemberTeams() async {
    final teamVM = context.read<TeamViewModel>();
    final authVM = context.read<AuthViewModel>();

    final userId = authVM.currentUser?.id;
    //final token = await authVM.getToken(); 

    if (userId != null) {
      await teamVM.fetchMemberTeams(userId);

      for (var team in teamVM.memberTeams) {
        if (team.id != null) {
          final players = await teamVM.getTeamPlayersUseCase(team.id!);
          teamVM.teamPlayersCount[team.id!] = players.length + 1;
          ;
        }
      }

      print("MEMBER TEAMS: ${teamVM.memberTeams.map((e) => e.name).toList()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final teamVM = context.watch<TeamViewModel>();
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Équipes membre',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${teamVM.memberTeams.length} équipe(s)',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),

            if (teamVM.isLoading)
              const Center(child: CircularProgressIndicator()),

            if (!teamVM.isLoading && teamVM.memberTeams.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: teamVM.memberTeams.length + 1, 
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    if (index == teamVM.memberTeams.length) {
                      return const MemberInfoCard();
                    }

                    final team = teamVM.memberTeams[index];
                    return TeamCard(
                      teamName: team.name,
                      teamRole: "MEMBRE",
                      city: team.city ?? '',
                      playersCount: teamVM.teamPlayersCount[team.id] ?? 0,
                      createdAt: team.createdAt,
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
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
