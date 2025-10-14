import 'package:flutter/material.dart';
import 'package:minha_academia_front/presentation/widgets/cards/inventory_summary.dart'; // Import do novo resumo

// --- Modelo de Dados para o Card da Máquina ---
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
}

// --- Widget para o Card de Máquina (Implementação simplificada) ---
class MachineCard extends StatelessWidget {
  final MachineCardData data;
  const MachineCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: const Color(0xFF1A2234), // Fundo escuro do card
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Linha do Título e Ícone de Status
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
                Icon(
                  data.icon, // Ícone de status (ex: checkmark, warning, error)
                  color: data.statusColor,
                  size: 20,
                ),
              ],
            ),

            // Detalhes da Máquina
            const SizedBox(height: 12),
            _buildDetailRow(theme, 'ID do Ativo', data.id),
            _buildDetailRow(theme, 'Última Manutenção', data.lastMaintenance),

            // Linha do Status (Chip)
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusChip(data.status, data.statusColor),
                Icon(
                  Icons.settings,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    return Chip(
      label: Text(status, style: TextStyle(color: Colors.black, fontSize: 12)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

// --- Tela Principal de Máquinas ---
class MaquinasScreen extends StatelessWidget {
  const MaquinasScreen({super.key});

  final List<MachineCardData> _machineData = const [
    MachineCardData(
      title: 'Esteira Profissional',
      id: 'EQ001',
      lastMaintenance: '15/09/2025',
      status: 'Operacional',
      statusColor: Colors.greenAccent,
      icon: Icons.check_circle,
    ),
    MachineCardData(
      title: 'Supino Reto',
      id: 'EQ002',
      lastMaintenance: '10/09/2025',
      status: 'Operacional',
      statusColor: Colors.greenAccent,
      icon: Icons.check_circle,
    ),
    MachineCardData(
      title: 'Leg Press 45°',
      id: 'EQ003',
      lastMaintenance: '05/10/2025',
      status: 'Em Manutenção',
      statusColor: Colors.amberAccent,
      icon: Icons.build,
    ),
    MachineCardData(
      title: 'Bicicleta Ergométrica',
      id: 'EQ004',
      lastMaintenance: '20/09/2025',
      status: 'Operacional',
      statusColor: Colors.greenAccent,
      icon: Icons.check_circle,
    ),
    MachineCardData(
      title: 'Cross Trainer',
      id: 'EQ005',
      lastMaintenance: '01/09/2025',
      status: 'Quebrado',
      statusColor: Colors.redAccent,
      icon: Icons.warning,
    ),
    MachineCardData(
      title: 'Puxador Alto',
      id: 'EQ006',
      lastMaintenance: '25/09/2025',
      status: 'Operacional',
      statusColor: Colors.greenAccent,
      icon: Icons.check_circle,
    ),
    MachineCardData(
      title: 'Hack Squat',
      id: 'EQ007',
      lastMaintenance: '03/10/2025',
      status: 'Em Manutenção',
      statusColor: Colors.amberAccent,
      icon: Icons.build,
    ),
    MachineCardData(
      title: 'Remada Sentada',
      id: 'EQ008',
      lastMaintenance: '18/09/2025',
      status: 'Operacional',
      statusColor: Colors.greenAccent,
      icon: Icons.check_circle,
    ),
  ];

  static const Color _searchFieldFillColor = Color(0xFF1E2638);
  static const Color _primaryHighlightColor = Color(0xFFEA4D3C);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TÍTULOS DA PÁGINA
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

          // 1. LINHA DE BUSCA E BOTÃO NOVO
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar máquina...',
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18.0,
                      horizontal: 16.0,
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
              const SizedBox(width: 16.0),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 20, color: Colors.white),
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
          const SizedBox(height: 32.0), // Espaçamento entre Busca e Resumo
          // 2. RESUMO DO INVENTÁRIO (Mini-Dashboard)
          const InventorySummary(),
          const SizedBox(height: 32.0),

          // 3. GRID DE CARDS (Layout Responsivo)
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              // 4 cards em desktop, 2 cards em tablets/celulares
              final crossAxisCount = screenWidth < 600
                  ? 2
                  : screenWidth < 900
                  ? 3
                  : 4;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _machineData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 1.5, // Proporção para este tipo de card
                ),
                itemBuilder: (context, index) {
                  return MachineCard(data: _machineData[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
