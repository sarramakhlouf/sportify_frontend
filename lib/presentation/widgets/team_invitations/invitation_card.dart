import 'package:flutter/material.dart';
import 'package:sportify_frontend/core/constants/api_constants.dart';
import 'package:sportify_frontend/domain/entities/invitationNotif.dart';

class InvitationCard extends StatelessWidget {
  final InvitationNotif invitation;
  final VoidCallback onAccept;
  final VoidCallback onRefuse;

  const InvitationCard({
    super.key,
    required this.invitation,
    required this.onAccept,
    required this.onRefuse,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    image: invitation.teamLogo != null
                        ? DecorationImage(
                            image: NetworkImage("${ApiConstants.imageUrl}${invitation.teamLogo!}"),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: invitation.teamLogo == null
                      ? const Icon(
                          Icons.sports_soccer,
                          color: Colors.white,
                          size: 24,
                        )
                      : null,
                ),

                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invitation.teamName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      invitation.teamCity ?? "Ville inconnue",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Text(
                  _formatTime(invitation.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEFFAF3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                invitation.message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                /// Refuser
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRefuse,
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text("Refuser"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onAccept,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text("Accepter"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) return "À l’instant";
    if (diff.inMinutes < 60) return "Il y a ${diff.inMinutes} min";
    if (diff.inHours < 24) return "Il y a ${diff.inHours} h";
    return "Il y a ${diff.inDays} j";
  }
}
