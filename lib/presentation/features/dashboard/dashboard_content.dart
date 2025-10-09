import 'package:flutter/material.dart';
import 'package:minha_academia_front/presentation/widgets/charts/weekly_checkin_chart.dart';

import '../../core/shared/metrica_card/metrica_card.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        children: [
          Text(
            'Dashboard Analítico',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Análise de crescimento e performance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(178),
            ),
          ),
          const SizedBox(height: 20.0),
          LayoutBuilder(
            builder: (context, constraints) {
              final double screenWidth = constraints.maxWidth;
              final int crossAxisCount = screenWidth < 400
                  ? 1
                  : screenWidth < 800
                  ? 2
                  : 4;
              final double cardAspectRatio = screenWidth < 800 ? 1.5 : 2.5;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: cardAspectRatio,
                children: const [
                  MetricCard(
                    title: 'Alunos Ativos',
                    value: '1,247',
                    icon: Icons.group,
                    valueColor: Colors.greenAccent,
                    iconColor: Colors.greenAccent,
                  ),
                  MetricCard(
                    title: 'Novos Alunos (Mês)',
                    value: '89',
                    icon: Icons.trending_up,
                    valueColor: Colors.blueAccent,
                    iconColor: Colors.blueAccent,
                  ),
                  MetricCard(
                    title: 'Máquinas em Manutenção',
                    value: '3',
                    icon: Icons.build,
                    valueColor: Colors.amberAccent,
                    iconColor: Colors.amberAccent,
                  ),
                  MetricCard(
                    title: 'Receita Mensal',
                    value: '4',
                    icon: Icons.monetization_on,
                    valueColor: Colors.greenAccent,
                    iconColor: Colors.greenAccent,
                    footer: '+8.3% vs. mês anterior',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20.0),
          SizedBox(height: 500, child: WeeklyCheckinChart()),
        ],
      ),
    );
  }
}
