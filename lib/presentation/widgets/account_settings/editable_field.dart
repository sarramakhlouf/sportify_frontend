import 'package:flutter/material.dart';

class EditableField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isEditing;
  final VoidCallback onToggle;
  final List<Widget> fields;
  final String? value;

  const EditableField({
    super.key,
    required this.label,
    required this.icon,
    required this.isEditing,
    required this.onToggle,
    required this.fields,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _icon(icon),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              ElevatedButton.icon(
                icon: Icon(isEditing ? Icons.save : Icons.edit, size: 16),
                label: Text(isEditing ? "Enregistrer" : "Modifier"),
                onPressed: onToggle,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isEditing ? const Color(0xFF22C55E) : const Color(0xFFE5E7EB),
                  foregroundColor:
                      isEditing ? Colors.white : const Color(0xFF374151),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: isEditing
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: value == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(value!, style: const TextStyle(fontSize: 14)),
                    ),
                  ),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(children: fields),
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon(IconData icon) {
    final color = _iconColor(icon);
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Color _iconColor(IconData icon) {
    if (icon == Icons.person_outline) return const Color(0xFF22C55E);
    if (icon == Icons.phone_outlined) return const Color(0xFF2563EB);
    if (icon == Icons.email_outlined) return const Color(0xFF9333EA);
    if (icon == Icons.lock_outline) return const Color(0xFFEF4444);
    return Colors.grey;
  }
}
