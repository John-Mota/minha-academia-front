import 'package:flutter/material.dart';
import 'package:minha_academia_front/presentation/features/professor/cadastro_professor_screen.dart';
import 'package:minha_academia_front/presentation/widgets/table/custom_data_table.dart';
import 'package:minha_academia_front/presentation/widgets/dialog/confirmation_dialog.dart';

class ProfessoresScreen extends StatelessWidget {
  const ProfessoresScreen({super.key});

  final List<Map<String, dynamic>> _professorData = const [
    {
      'id': 101,
      'nome': 'Dr. Roberto Lima',
      'cref': '012345-G/SP',
      'email': 'roberto.lima@email.com',
      'cpf': '111.111.111-11',
      'status': 'Ativo',
      'telefone': '(11) 98765-4321',
    },
    {
      'id': 102,
      'nome': 'Mariana Costa',
      'cref': '054321-G/MG',
      'email': 'mariana.costa@email.com',
      'cpf': '222.222.222-22',
      'status': 'Ativo',
      'telefone': '(11) 98765-1234',
    },
    {
      'id': 103,
      'nome': 'Fernando Silva',
      'cref': '098765-G/RJ',
      'email': 'fernando.silva@email.com',
      'cpf': '333.333.333-33',
      'status': 'Não Ativo',
      'telefone': '(11) 98765-5678',
    },
    {
      'id': 104,
      'nome': 'Juliana Santos',
      'cref': '135790-G/PR',
      'email': 'juliana.santos@email.com',
      'cpf': '444.444.444-44',
      'status': 'Ativo',
      'telefone': '(11) 98765-9012',
    },
    {
      'id': 105,
      'nome': 'André Oliveira',
      'cref': '246802-G/SP',
      'email': 'andre.oliveira@email.com',
      'cpf': '555.555.555-55',
      'status': 'Não Ativo',
      'telefone': '(11) 98765-3456',
    },
    {
      'id': 106,
      'nome': 'Carla Pimenta',
      'cref': '333444-G/SP',
      'email': 'carla.pimenta@email.com',
      'cpf': '666.666.666-66',
      'status': 'Ativo',
      'telefone': '(11) 98765-1111',
    },
    {
      'id': 107,
      'nome': 'Pedro Rocha',
      'cref': '555666-G/MG',
      'email': 'pedro.rocha@email.com',
      'cpf': '777.777.777-77',
      'status': 'Ativo',
      'telefone': '(11) 98765-2222',
    },
    {
      'id': 108,
      'nome': 'Beatriz Motta',
      'cref': '777888-G/RJ',
      'email': 'beatriz.motta@email.com',
      'cpf': '888.888.888-88',
      'status': 'Ativo',
      'telefone': '(11) 98765-3333',
    },
    {
      'id': 109,
      'nome': 'Rafael Souza',
      'cref': '999000-G/PR',
      'email': 'rafael.souza@email.com',
      'cpf': '999.999.999-99',
      'status': 'Não Ativo',
      'telefone': '(11) 98765-4444',
    },
    {
      'id': 110,
      'nome': 'Tatiana Alves',
      'cref': '121212-G/SP',
      'email': 'tatiana.alves@email.com',
      'cpf': '101.010.101-01',
      'status': 'Ativo',
      'telefone': '(11) 98765-5555',
    },
    {
      'id': 111,
      'nome': 'Márcio Gomes',
      'cref': '343434-G/SP',
      'email': 'marcio.gomes@email.com',
      'cpf': '123.456.789-00',
      'status': 'Ativo',
      'telefone': '(11) 98765-6666',
    },
    {
      'id': 112,
      'nome': 'Nome não informado',
      'cref': '565656-G/MG',
      'email': 'naoinformado@email.com',
      'cpf': '000.000.000-00',
      'status': 'Não Ativo',
      'telefone': '(11) 98765-7777',
    },
  ];
  static const Color _searchFieldFillColor = Color(0xFF1E2638);
  static const Color _primaryHighlightColor = Color(0xFFEA4D3C);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    const double mobileBreakpoint = 600.0;
    final isMobile = screenWidth < mobileBreakpoint;

    const List<TableColumn> professorColumns = [
      TableColumn(title: 'Nome', dataKey: 'nome', flex: 3),
      TableColumn(title: 'CREF', dataKey: 'cref', flex: 2),
      TableColumn(title: 'Telefone', dataKey: 'telefone', flex: 3),
      TableColumn(title: 'Status', dataKey: 'status', flex: 2),
      TableColumn(title: 'Ações', dataKey: 'id', isAction: true, flex: 1),
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
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

              isMobile
                  ? IconButton(
                      onPressed: () => _showCadastroDialog(context),
                      icon: const Icon(Icons.add, size: 28),
                      color: _primaryHighlightColor,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  : ElevatedButton.icon(
                      onPressed: () => _showCadastroDialog(context),
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
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
          Expanded(
            child: CustomDataTable(
              title: 'Lista de Professores',
              columns: professorColumns,
              data: _professorData,
              hasActions: true,
              onEdit: (professor) {
                _showCadastroDialog(context, professor: professor);
              },
              onDelete: (professor) {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmationDialog(
                    title: 'Confirmar Exclusão',
                    content:
                        'Tem certeza de que deseja excluir o professor ${professor['nome']}? Esta ação não pode ser desfeita.',
                    onConfirm: () {
                      print(
                        'Chamado para Excluir Professor ID: ${professor['id']}',
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCadastroDialog(
    BuildContext context, {
    Map<String, dynamic>? professor,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth < 600
                  ? screenWidth * 0.9
                  : screenWidth * 0.4,
              maxHeight: screenHeight * 0.9,
            ),
            child: CadastroProfessorScreen(
              professor: professor,
              onCancel: () => Navigator.of(context).pop(),
            ),
          ),
        );
      },
    );
  }
}
