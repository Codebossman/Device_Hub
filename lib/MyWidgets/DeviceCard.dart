import 'package:flutter/material.dart';

class Device extends StatelessWidget {
  final String name;
  final bool isOn;
  final VoidCallback onTap;

  const Device({
    super.key,
    required this.name,
    required this.isOn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),

      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,

        child: Container(
          height: 120,
          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Device name at top
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              // Status text
              Text(
                isOn ? "Ready to connect" : "OFF",
                style: TextStyle(
                  color: isOn ? Colors.green : Colors.grey,
                ),
              ),

              const Spacer(),

              // Icon at bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    isOn ? Icons.check : Icons.check_box_outline_blank,
                    color: isOn ? Colors.green : Colors.black54,
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}