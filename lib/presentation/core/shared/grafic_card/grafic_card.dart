import 'package:flutter/material.dart';

class GraficCard extends StatelessWidget {
  final Widget chart;

  final Color effectiveCardColor = const Color(0xFF1D293D);
  final Color borderColor = const Color(0xFF848485);

  const GraficCard({super.key, required this.chart});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: effectiveCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: chart)],
      ),
    );
  }
}
