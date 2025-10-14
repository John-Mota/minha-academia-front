import 'package:flutter/material.dart';

class InventorySummary extends StatelessWidget {
  const InventorySummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(
          0xFF1A2234,
        ), // Cor de fundo semelhante ao gráfico/tabela
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo do Inventário',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _MetricItem(
                value: '5',
                label: 'Equipamentos Operacionais',
                valueColor: Colors.greenAccent,
              ),
              _MetricItem(
                value: '2',
                label: 'Em Manutenção',
                valueColor: Colors.amberAccent,
              ),
              _MetricItem(
                value: '1',
                label: 'Quebrados',
                valueColor: Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget interno para cada métrica (5, 2, 1)
class _MetricItem extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _MetricItem({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext set) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(set).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: Theme.of(set).textTheme.titleSmall?.copyWith(
            color: Theme.of(set).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
