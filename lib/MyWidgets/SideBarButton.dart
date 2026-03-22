import 'package:flutter/material.dart';

class SideBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool showingLabel;

  const SideBarButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.showingLabel,
    this.selected = false,
  });

  @override
  @override
Widget build(BuildContext context) {

  return InkWell(
    borderRadius: BorderRadius.circular(6),
    onTap: onTap,

    child: Container(
      height: 48,
      alignment: Alignment.center,

      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),

      child: showingLabel
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                const SizedBox(width: 12),

                Icon(
                  icon,
                  color: selected ? Colors.white : Colors.black54,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
              ],
            )
          : Icon(
              icon,
              color: selected ? Colors.white : Colors.black54,
            ),
    ),
  );
}}