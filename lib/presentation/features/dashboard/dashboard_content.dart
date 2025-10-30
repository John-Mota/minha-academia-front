import 'package:flutter/material.dart';
import 'package:minha_academia_front/presentation/widgets/charts/weekly_checkin_chart.dart';
import 'package:minha_academia_front/presentation/features/dashboard/cadastro_membro_screen.dart';

import '../../core/shared/metrica_card/metrica_card.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dashboard Analítico',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Análise de crescimento e performance',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(178),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showCadastroDialog(context),
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Cadastrar Membro',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEA4D3C),
                        minimumSize: const Size(140, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double screenWidth = constraints.maxWidth;
                    final int crossAxisCount = screenWidth < 400
                        ? 1
                        : (screenWidth < 800 ? 2 : 4);
                    final double cardAspectRatio = screenWidth < 800
                        ? 1.5
                        : 2.0;

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
                        ),
                        MetricCard(
                          title: 'Novos Alunos (Mês)',
                          value: '89',
                          icon: Icons.trending_up,
                        ),
                        MetricCard(
                          title: 'Máquinas em Manutenção',
                          value: '3',
                          icon: Icons.build,
                        ),
                        MetricCard(
                          title: 'Receita Mensal',
                          value: '4',
                          icon: Icons.monetization_on,
                          footer: '+8.3% vs. mês anterior',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: 24.0,
              ),
              child: WeeklyCheckinChart(),
            ),
          ),
        ],
      ),
    );
  }

  void _showCadastroDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: SizedBox(
            width: screenWidth * 0.4,
            height: screenHeight * 0.9,
            child: CadastroMembroScreen(
              onCancel: () => Navigator.of(context).pop(),
            ),
          ),
        );
      },
    );
  }
}
