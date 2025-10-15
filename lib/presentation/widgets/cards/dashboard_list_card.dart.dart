import 'package:flutter/material.dart';

class DashboardListCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;
  final String primaryLabelKey;
  final String secondaryLabelKey;

  const DashboardListCard({
    super.key,
    required this.title,
    required this.data,
    required this.primaryLabelKey,
    required this.secondaryLabelKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2234),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16.0),

          ...data.map((item) {
            final String primary = item[primaryLabelKey] ?? '';
            final String secondary = item[secondaryLabelKey] ?? '';
            final Color color = _getSecondaryColor(secondary);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    primary,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    secondary,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getSecondaryColor(String value) {
    final numValue =
        double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

    if (value.contains('ocupação') || value.contains('check-ins')) {
      if (numValue >= 80) return Colors.greenAccent;
      if (numValue >= 60) return Colors.amberAccent;
      return Colors.redAccent;
    }
    return Colors.redAccent;
  }
}
