import 'package:flutter/material.dart';

class ExerciseItem extends StatelessWidget {
  final String name;
  final String series;
  final String reps;
  final String load;
  final String rest;
  final void Function()? onDelete;

  const ExerciseItem({
    super.key,
    required this.name,
    required this.series,
    required this.reps,
    required this.load,
    required this.rest,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color cardColor = Color(0xFF1A2234);

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    color: Colors.white.withOpacity(0.7),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    color: Colors.redAccent,
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: Color(0xFF28324A), height: 16, thickness: 1),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildDetailColumn(theme, 'Séries', series)),
              Expanded(child: _buildDetailColumn(theme, 'Repetições', reps)),
              Expanded(child: _buildDetailColumn(theme, 'Carga', load)),
              Expanded(child: _buildDetailColumn(theme, 'Descanso', rest)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(ThemeData theme, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
