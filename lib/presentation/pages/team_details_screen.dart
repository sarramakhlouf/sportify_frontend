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

  const TeamDetailsScreen({
    super.key,
    required this.team,
  });

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  bool isLoading = true;
  List<PlayerModel> players = [];

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    final teamVM = context.read<TeamViewModel>();
    final authVM = context.read<AuthViewModel>();
    final token = await authVM.getToken();

    if (token == null || widget.team.id == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      /// Membres
      final members =
          await teamVM.getTeamPlayersUseCase(widget.team.id!);

      /// Owner
      final owner =
          await teamVM.getUserByIdUseCase(widget.team.ownerId, token);

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
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Erreur chargement joueurs: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final currentUserId = authVM.currentUser?.id;

    /// Joueur courant
    final PlayerModel currentPlayer = players.firstWhere(
      (p) => p.id == currentUserId,
      orElse: () => PlayerModel(
        id: '',
        name: '',
        role: 'MEMBRE',
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// HEADER
          TeamHeader(
            team: widget.team,
            player: currentPlayer,
          ),

          /// CONTENT
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
                        PlayersSection(players: players, team: widget.team),
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
