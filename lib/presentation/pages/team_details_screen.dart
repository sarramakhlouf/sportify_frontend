import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/data/models/player_model.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/team_details/players_section.dart';
import 'package:sportify_frontend/presentation/widgets/team_details/team_header.dart';
import 'package:sportify_frontend/presentation/widgets/team_details/team_matches_card.dart';
import 'package:sportify_frontend/presentation/widgets/team_details/team_stats.dart';

class TeamDetailsScreen extends StatefulWidget {
  final TeamModel team;

  const TeamDetailsScreen({super.key, required this.team});

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  bool isLoading = true;
  List<PlayerModel> players = [];
  late TeamModel currentTeam;

  @override
  void initState() {
    super.initState();
    currentTeam = widget.team;
    _loadTeamData();
  }

  /// Charge les données complètes de l'équipe (info + joueurs)
  Future<void> _loadTeamData() async {
    setState(() => isLoading = true);

    final teamVM = context.read<TeamViewModel>();
    final authVM = context.read<AuthViewModel>();
    final token = await authVM.getToken();

    if (token == null || currentTeam.id == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final updatedTeam = await teamVM.fetchTeamById(
        teamId: currentTeam.id!,
        token: token,
      );

      await _loadPlayers(token);

      if (mounted) {
        setState(() {
          currentTeam = updatedTeam ?? currentTeam;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erreur chargement données équipe: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _loadPlayers(String token) async {
    final teamVM = context.read<TeamViewModel>();

    if (currentTeam.id == null) {
      return;
    }

    try {
      final members = await teamVM.getTeamPlayersUseCase(currentTeam.id!);
      final owner = await teamVM.getUserByIdUseCase(
        currentTeam.ownerId,
        token,
      );
      
      if (mounted) {
        setState(() {
          players = [
            PlayerModel(
              id: owner.id,
              name: '${owner.firstname} ${owner.lastname}',
              avatarUrl: owner.profileImageUrl,
              role: 'OWNER',
            ),
            ...members
                .where((m) => m.id != owner.id)
                .map(
                  (m) => PlayerModel(
                    id: m.id,
                    name: m.name,
                    avatarUrl: m.avatarUrl,
                    role: 'MEMBRE',
                  ),
                ),
          ];
        });
      }
    } catch (e) {
      debugPrint('Erreur chargement joueurs: $e');
    }
  }

  Future<void> refreshTeamData() async {
    await _loadTeamData();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final teamVM = context.watch<TeamViewModel>();
    final currentUserId = authVM.currentUser?.id;

    final team = currentTeam;

    final PlayerModel currentPlayer = players.firstWhere(
      (p) => p.id == currentUserId,
      orElse: () => PlayerModel(id: '', name: '', role: 'MEMBRE'),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TeamHeader(
            team: team,
            player: currentPlayer,
            showEditButton: teamVM.ownedTeams.any((t) => t.id == team.id),
            onTeamUpdated: refreshTeamData,
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        TeamStats(),
                        const SizedBox(height: 16),
                        TeamMatchesCard(),
                        const SizedBox(height: 16),
                        PlayersSection(players: players, team: team),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}