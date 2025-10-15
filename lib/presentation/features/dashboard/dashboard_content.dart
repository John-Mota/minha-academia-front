import 'package:flutter/material.dart';
import 'package:minha_academia_front/presentation/widgets/cards/dashboard_list_card.dart.dart';
import 'package:minha_academia_front/presentation/widgets/charts/weekly_checkin_chart.dart';
import 'package:minha_academia_front/presentation/core/shared/metrica_card/metrica_card.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  final List<Map<String, dynamic>> _horariosData = const [
    {'hora': '18:00 - 20:00', 'valor': '342 check-ins'},
    {'hora': '07:00 - 09:00', 'valor': '298 check-ins'},
    {'hora': '14:00 - 16:00', 'valor': '187 check-ins'},
    {'hora': '20:00 - 22:00', 'valor': '156 check-ins'},
  ];

  final List<Map<String, dynamic>> _equipamentosData = const [
    {'equipamento': 'Esteira Profissional', 'ocupacao': '94% ocupação'},
    {'equipamento': 'Supino Reto', 'ocupacao': '87% ocupação'},
    {'equipamento': 'Leg Press 45°', 'ocupacao': '76% ocupação'},
    {'equipamento': 'Cross Trainer', 'ocupacao': '23% ocupação'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenHeight),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
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
                    const SizedBox(height: 4.0),
                    Text(
                      'Análise de crescimento e performance',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(178),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    DropdownButton<String>(
                      value: 'Últimos 12 meses',
                      dropdownColor: const Color(0xFF1A2234),
                      items:
                          [
                                'Últimos 12 meses',
                                'Últimos 6 meses',
                                'Últimos 3 meses',
                              ]
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {},
                      style: theme.textTheme.titleSmall,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      underline: Container(),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.file_download,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Exportar PDF',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A2234),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30.0),

            LayoutBuilder(
              builder: (context, constraints) {
                final double screenWidth = constraints.maxWidth;
                final crossAxisCount = screenWidth < 600
                    ? 1
                    : screenWidth < 900
                    ? 2
                    : 3;
                final cardAspectRatio = screenWidth < 800 ? 2.0 : 2.5;

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: cardAspectRatio,
                  children: const [
                    MetricCard(
                      title: 'Taxa de Crescimento',
                      value: '+12.5%',
                      icon: Icons.trending_up,
                      valueColor: Colors.greenAccent,
                      iconColor: Colors.greenAccent,
                      footer: 'vs. ano anterior',
                    ),
                    MetricCard(
                      title: 'Retenção de Alunos',
                      value: '89.2%',
                      icon: Icons.group,
                      valueColor: Colors.blueAccent,
                      iconColor: Colors.blueAccent,
                      footer: 'últimos 12 meses',
                    ),
                    MetricCard(
                      title: 'Receita Mensal',
                      value: 'R\$ 127.450',
                      icon: Icons.monetization_on,
                      valueColor: Colors.greenAccent,
                      iconColor: Colors.greenAccent,
                      footer: '+8.3% vs. mês anterior',
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30.0),

            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2234),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crescimento de Alunos no Último Ano',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Novos membros por mês e total acumulado',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(height: 300, child: WeeklyCheckinChart()),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth < 600 ? 1 : 2;

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.2,

                  children: [
                    DashboardListCard(
                      title: 'Top Horários de Pico',
                      data: _horariosData,
                      primaryLabelKey: 'hora',
                      secondaryLabelKey: 'valor',
                    ),
                    DashboardListCard(
                      title: 'Equipamentos Mais Usados',
                      data: _equipamentosData,
                      primaryLabelKey: 'equipamento',
                      secondaryLabelKey: 'ocupacao',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
