import 'package:flutter/material.dart';
import 'package:minha_academia_front/presentation/widgets/table/custom_data_table.dart';

class ProfessoresScreen extends StatelessWidget {
  const ProfessoresScreen({super.key});

  final List<Map<String, dynamic>> _professorData = const [
    {
      'id': 101,
      'nome': 'Dr. Roberto Lima',
      'cref': '012345-G/SP',
      'status': 'Ativo',
      'telefone': '(11) 98765-4321',
    },
    {
      'id': 102,
      'nome': 'Mariana Costa',
      'cref': '054321-G/MG',
      'status': 'Ativo',
      'telefone': '(11) 98765-1234',
    },
    {
      'id': 103,
      'nome': 'Fernando Silva',
      'cref': '098765-G/RJ',
      'status': 'Não Ativo',
      'telefone': '(11) 98765-5678',
    },
    {
      'id': 104,
      'nome': 'Juliana Santos',
      'cref': '135790-G/PR',
      'status': 'Ativo',
      'telefone': '(11) 98765-9012',
    },
    {
      'id': 105,
      'nome': 'André Oliveira',
      'cref': '246802-G/SP',
      'status': 'Não Ativo',
      'telefone': '(11) 98765-3456',
    },
    {
      'id': 106,
      'nome': 'Carla Pimenta',
      'cref': '333444-G/SP',
      'status': 'Ativo',
      'telefone': '(11) 98765-1111',
    },
    {
      'id': 107,
      'nome': 'Pedro Rocha',
      'cref': '555666-G/MG',
      'status': 'Ativo',
      'telefone': '(11) 98765-2222',
    },
    {
      'id': 108,
      'nome': 'Beatriz Motta',
      'cref': '777888-G/RJ',
      'status': 'Ativo',
      'telefone': '(11) 98765-3333',
    },
    {
      'id': 109,
      'nome': 'Rafael Souza',
      'cref': '999000-G/PR',
      'status': 'Não Ativo',
      'telefone': '(11) 98765-4444',
    },
    {
      'id': 110,
      'nome': 'Tatiana Alves',
      'cref': '121212-G/SP',
      'status': 'Ativo',
      'telefone': '(11) 98765-5555',
    },
    {
      'id': 111,
      'nome': 'Márcio Gomes',
      'cref': '343434-G/SP',
      'status': 'Ativo',
      'telefone': '(11) 98765-6666',
    },
    {
      'id': 112,
      'cref': '565656-G/MG',
      'status': 'Não Ativo',
      'telefone': '(11) 98765-7777',
    },
  ];
  static const Color _searchFieldFillColor = Color(0xFF1E2638);
  static const Color _primaryHighlightColor = Color(0xFFEA4D3C);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    const double consumedHeightEstimate = 190.0;
    final double remainingTableHeight = screenHeight - consumedHeightEstimate;

    const List<TableColumn> professorColumns = [
      TableColumn(title: 'Nome', dataKey: 'nome', flex: 3),
      TableColumn(title: 'CREF', dataKey: 'cref', flex: 2),
      TableColumn(title: 'Telefone', dataKey: 'telefone', flex: 3),
      TableColumn(title: 'Status', dataKey: 'status', flex: 2),
      TableColumn(title: 'Ações', dataKey: 'id', isAction: true, flex: 1),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciamento de Professores',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Gerencie todos os professores da academia',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(178),
            ),
          ),

          const SizedBox(height: 32.0),

          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar professor...',
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: theme.colorScheme.onSurface.withOpacity(
                      0.8,
                    ),
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
                onPressed: () {
                  print('Abrir formulário para Novo Professor');
                },
                icon: const Icon(Icons.add, size: 20, color: Colors.white),
                label: const Text(
                  'Novo Professor',
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

          const SizedBox(height: 20.0),

          SizedBox(
            height: remainingTableHeight - 11.0,
            child: CustomDataTable(
              title: 'Lista de Professores',
              columns: professorColumns,
              data: _professorData,
              hasActions: true,
              onEdit: (professor) {
                print('Chamado para Editar Professor ID: ${professor['id']}');
              },
              onDelete: (professor) {
                print('Chamado para Excluir Professor ID: ${professor['id']}');
              },
            ),
          ),
        ],
      ),
    );
  }
}
