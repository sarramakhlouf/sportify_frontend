import 'package:flutter/material.dart';

class TeamColorPicker extends StatelessWidget {
  final String selectedColor;
  final Function(String) onSelect;

  const TeamColorPicker({
    super.key,
    required this.selectedColor,
    required this.onSelect,
  });

  final List<String> colors = const [
    '#22C55E',
    '#3B82F6',
    '#EF4444',
    '#F59E0B',
    '#8B5CF6',
    '#06B6D4',
  ];

  Color _hexToColor(String hex) =>
      Color(int.parse(hex.replaceFirst('#', '0xff')));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: colors.map((hex) {
        final selected = hex == selectedColor;
        return GestureDetector(
          onTap: () => onSelect(hex),
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: selected
                  ? Border.all(color: _hexToColor(hex), width: 3)
                  : null,
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: _hexToColor(hex),
              child:
                  selected ? const Icon(Icons.check, color: Colors.white) : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
