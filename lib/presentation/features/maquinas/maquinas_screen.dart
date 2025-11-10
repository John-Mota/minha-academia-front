import 'package:flutter/material.dart';
import 'package:minha_academia_front/data/services/maquina_service.dart';
import 'package:minha_academia_front/presentation/features/maquinas/cadastro_maquina_screen.dart';

class InventorySummary extends StatelessWidget {
  const InventorySummary({super.key});

  Widget _buildMetric(
    BuildContext context,
    ThemeData theme,
    String count,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          count,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(
          width: 120,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
            softWrap: true,
            maxLines: 2,
          ),
        ),
        if (MediaQuery.of(context).size.width < 600) const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    final metrics = [
      _buildMetric(context, theme, '5', 'Equipamentos Operacionais'),
      _buildMetric(context, theme, '2', 'Em Manutenção'),
      _buildMetric(context, theme, '1', 'Quebrados'),
    ];

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: metrics,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: metrics,
      );
    }
  }
}

class MachineCardData {
  final String title;
  final String id;
  final String lastMaintenance;
  final String status;
  final Color statusColor;
  final IconData icon;

  const MachineCardData({
    required this.title,
    required this.id,
    required this.lastMaintenance,
    required this.status,
    required this.statusColor,
    required this.icon,
  });
  factory MachineCardData.fromJson(Map<String, dynamic> json) {
    final String status = json['status'] ?? 'Desconhecido';
    final Color color;
    final IconData icon;

    switch (status) {
      case 'Operacional':
        color = Colors.greenAccent;
        icon = Icons.check_circle;
        break;
      case 'Em Manutenção':
        color = Colors.amberAccent;
        icon = Icons.build;
        break;
      case 'Quebrado':
        color = Colors.redAccent;
        icon = Icons.warning;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
    }

    return MachineCardData(
      title: json['title'] ?? 'Sem Título',
      id: json['id'] ?? 'Sem ID',
      lastMaintenance: json['lastMaintenance'] ?? 'N/A',
      status: status,
      statusColor: color,
      icon: icon,
    );
  }
}

class MachineCard extends StatelessWidget {
  final MachineCardData data;
  final VoidCallback onEditPressed;

  const MachineCard({
    super.key,
    required this.data,
    required this.onEditPressed,
  });

  Widget _buildDetailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 153),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    return Chip(
      label: Text(
        status,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: const Color(0xFF1A2234),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(data.icon, color: data.statusColor, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow(theme, 'ID do Ativo', data.id),
            _buildDetailRow(theme, 'Última Manutenção', data.lastMaintenance),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusChip(data.status, data.statusColor),
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: theme.colorScheme.onSurface.withValues(alpha: 127.5),
                    size: 18,
                  ),
                  onPressed: onEditPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MaquinasScreen extends StatefulWidget {
  const MaquinasScreen({super.key});

  @override
  State<MaquinasScreen> createState() => _MaquinasScreenState();
}

class _MaquinasScreenState extends State<MaquinasScreen> {
  late Future<List<MachineCardData>> _maquinasFuture;
  final MaquinaService _service = MaquinaService();

  static const Color _searchFieldFillColor = Color(0xFF1E2638);
  static const Color _primaryHighlightColor = Color(0xFFEA4D3C);

  @override
  void initState() {
    super.initState();
    _maquinasFuture = _service.getMaquinas();
  }

  void _navigateToForm({MachineCardData? maquina}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroMaquinasScreen(maquina: maquina),
      ),
    ).then((_) {
      setState(() {
        _maquinasFuture = _service.getMaquinas();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inventário de Equipamentos',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Gerencie todas as máquinas da academia',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(178),
            ),
          ),
          const SizedBox(height: 32.0),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar máquina...',
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 10.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: _primaryHighlightColor,
                          width: 1.0,
                        ),
                      ),
                      filled: true,
                      fillColor: _searchFieldFillColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              screenWidth < 800
                  ? IconButton(
                      onPressed: () => _navigateToForm(),
                      icon: const Icon(Icons.add, size: 28),
                      color: _primaryHighlightColor,
                      constraints: const BoxConstraints.tightFor(
                        width: 48,
                        height: 48,
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () => _navigateToForm(),
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Nova Máquina',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryHighlightColor,
                        minimumSize: const Size(140, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 32.0),
          const InventorySummary(),
          const SizedBox(height: 32.0),
          FutureBuilder<List<MachineCardData>>(
            future: _maquinasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhuma máquina encontrada.'));
              }

              final machineData = snapshot.data!;

              return LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final crossAxisCount = availableWidth < 500
                      ? 1
                      : availableWidth < 900
                      ? 3
                      : 4;
                  final aspectRatio = availableWidth < 500 ? 1.8 : 1.5;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: machineData.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: aspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final maquina = machineData[index];
                      return MachineCard(
                        data: maquina,
                        onEditPressed: () => _navigateToForm(maquina: maquina),
                      );
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
