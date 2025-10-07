import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color valueColor;
  final Color iconColor;
  final String? footer;

  const MetricCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor = Colors.white,
    this.iconColor = Colors.blue,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color effectiveCardColor = Color(0xFF1D293D);
    const Color titleColor = Colors.white70;
    const Color footerColor = Colors.white54;

    return Container(
      decoration: BoxDecoration(
        color: effectiveCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF848485), width: 2.0),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: titleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: iconColor, size: 24),
            ],
          ),

          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (footer != null) ...[
            const SizedBox(height: 8),
            Text(
              footer!,
              style: const TextStyle(color: footerColor, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
