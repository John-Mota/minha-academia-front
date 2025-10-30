import 'package:flutter/material.dart';
import 'package:minha_academia_front/presentation/widgets/charts/weekly_checkin_chart.dart';
import 'package:minha_academia_front/presentation/features/dashboard/cadastro_membro_screen.dart';

import '../../core/shared/metrica_card/metrica_card.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

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
            width: screenWidth > 600 ? screenWidth * 0.4 : screenWidth * 0.9,
            height: screenHeight * 0.9,
            child: CadastroMembroScreen(
              onCancel: () => Navigator.of(context).pop(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    const double desktopBreakpoint = 900.0;
    final isDesktop = screenWidth >= desktopBreakpoint;
    const Color titleColor = Colors.white70;

    final List<Widget> topContent = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
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
          ),
          const SizedBox(width: 16.0),
          screenWidth < 600
              ? IconButton(
                  onPressed: () => _showCadastroDialog(context),
                  icon: const Icon(
                    Icons.add,
                    size: 28,
                    color: Color(0xFFEA4D3C),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              : ElevatedButton.icon(
                  onPressed: () => _showCadastroDialog(context),
                  icon: const Icon(Icons.add, size: 20, color: Colors.white),
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
          final double layoutWidth = constraints.maxWidth;
          final int crossAxisCount = layoutWidth < 600
              ? 1
              : (layoutWidth < 900 ? 2 : 4);
          final double cardAspectRatio = layoutWidth < 600 ? 2.5 : 2.0;

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
                iconColor: Color(0xFF388E3C),
              ),
              MetricCard(
                title: 'Novos Alunos (Mês)',
                value: '89',
                icon: Icons.trending_up,
                iconColor: Color(0xFF1E88E5),
              ),
              MetricCard(
                title: 'Máquinas em Manutenção',
                value: '3',
                icon: Icons.build,
                iconColor: Color(0xFFFDD835),
              ),
              MetricCard(
                title: 'Receita Mensal',
                value: '4',
                icon: Icons.monetization_on,
                footer: '+8.3% vs. mês anterior',
                iconColor: Color(0xFFEA4D3C),
              ),
            ],
          );
        },
      ),
      const SizedBox(height: 20.0),
      Text(
        'Dados dos últimos 7 dias',
        style: TextStyle(color: titleColor, fontSize: 16),
      ),
      const SizedBox(height: 10.0),
    ];

    Widget contentWidget;

    if (isDesktop) {
      contentWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...topContent,
          Expanded(child: WeeklyCheckinChart()),
        ],
      );
    } else {
      contentWidget = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...topContent,
            SizedBox(height: 400, child: WeeklyCheckinChart()),
          ],
        ),
      );
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: false,
      child: Padding(padding: const EdgeInsets.all(24.0), child: contentWidget),
    );
  }
}
