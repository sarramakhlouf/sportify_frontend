import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/core/constants/api_constants.dart';
import 'package:sportify_frontend/core/theme/app_colors.dart';
import 'package:sportify_frontend/core/theme/app_text_styles.dart';
import 'package:sportify_frontend/data/models/player_model.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/presentation/pages/update_team_screen.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';

class TeamHeader extends StatelessWidget {
  final TeamModel team;
  final PlayerModel player;
  final bool showEditButton;
  final VoidCallback? onTeamUpdated;

  const TeamHeader({
    super.key,
    required this.team,
    required this.player,
    this.showEditButton = false,
    this.onTeamUpdated,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("🟢 TeamHeader - team.logoUrl: ${team.logoUrl}");

    final authVM = context.read<AuthViewModel>();
    final teamVM = context.watch<TeamViewModel>();

    debugPrint("🟡 Paramètre team.id: ${team.id}");
    debugPrint("🟡 Paramètre team.name: ${team.name}");
    debugPrint("🟡 Paramètre team.city: ${team.city}");
    debugPrint("🟡 Paramètre team.logoUrl: ${team.logoUrl}");

    final displayTeam = teamVM.selectedTeam?.id == team.id
        ? teamVM.selectedTeam!
        : team;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryGreen, Color(0xFF2ECC71)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleIcon(
                icon: Icons.arrow_back,
                onTap: () => Navigator.pop(context),
              ),

              Row(
                children: [
                  if (showEditButton)
                    GestureDetector(
                      onTap: () async {
                        final token = await authVM.getToken();

                        if (token == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Erreur: Token non disponible'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (_) =>
                              UpdateTeamDialog(team: displayTeam, token: token),
                        );

                        if (result == true && onTeamUpdated != null) {
                          onTeamUpdated!();
                        } 
                      },
                      child: _pillButton(
                        text: "Modifier",
                        background: Colors.white,
                        textColor: Colors.black,
                      ),
                    ),
                  const SizedBox(width: 8),
                  _copyCodePill(context, displayTeam.teamCode ?? 'null'),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.white,
                  backgroundImage: (() {
                    if (displayTeam.logoUrl != null && displayTeam.logoUrl!.isNotEmpty) {
                      print("🔴🔴🔴 JUSTE AVANT NetworkImage: ${displayTeam.logoUrl}");
                      return NetworkImage("${ApiConstants.imageUrl}${displayTeam.logoUrl!}");
                    }
                    return null;
                  })(),
                  child:
                      displayTeam.logoUrl == null ||
                          displayTeam.logoUrl!.isEmpty
                      ? const Icon(Icons.shield, size: 34, color: Colors.grey)
                      : null,
                ),
              ),

              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayTeam.name,
                      style: AppTextStyles.title.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            displayTeam.city ?? '',
                            style: AppTextStyles.subtitle.copyWith(
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _pillButton(
                          text: "${player.role}",
                          background: Colors.white.withOpacity(0.25),
                          textColor: Colors.white,
                          small: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIcon({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _pillButton({
    required String text,
    required Color background,
    required Color textColor,
    bool small = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 14,
        vertical: small ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: small ? 11 : 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _copyCodePill(BuildContext context, String code) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            code,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: code));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Code copié"),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Icon(
              Icons.copy_rounded,
              size: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
