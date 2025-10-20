import 'package:flutter/material.dart';
import 'package:minha_academia_front/presentation/features/aluno/cadastro_aluno_screen.dart';
import 'package:minha_academia_front/presentation/widgets/table/custom_data_table.dart';
import 'package:minha_academia_front/presentation/widgets/dialog/confirmation_dialog.dart';

class AlunosScreen extends StatelessWidget {
  const AlunosScreen({super.key});

  final List<Map<String, dynamic>> _alunoData = const [
    {
      'id': 1,
      'nome': 'Ana Silva',
      'matricula': 'FP001',
      'plano': 'Premium',
      'status': 'Ativo',
      'email': 'ana.silva@email.com',
      'cpf': '111.111.111-11',
      'dataNascimento': '10/05/1990',
      'telefone': '(11) 99999-1234',
    },
    {
      'id': 2,
      'nome': 'Carlos Santos',
      'matricula': 'FP002',
      'plano': 'Básico',
      'status': 'Ativo',
      'email': 'carlos.santos@email.com',
      'cpf': '222.222.222-22',
      'dataNascimento': '15/08/1985',
      'telefone': '(11) 99999-5678',
    },
    {
      'id': 3,
      'nome': 'Maria Oliveira',
      'matricula': 'FP003',
      'plano': 'Premium',
      'status': 'Inativo',
      'email': 'maria.oliveira@email.com',
      'cpf': '333.333.333-33',
      'dataNascimento': '20/11/2000',
      'telefone': '(11) 99999-9012',
    },
    {
      'id': 4,
      'nome': 'João Costa',
      'matricula': 'FP004',
      'plano': 'Intermediário',
      'status': 'Ativo',
      'email': 'joao.costa@email.com',
      'cpf': '444.444.444-44',
      'dataNascimento': '01/02/1998',
      'telefone': '(11) 99999-3456',
    },
    {
      'id': 5,
      'nome': 'Luciana Pereira',
      'matricula': 'FP005',
      'plano': 'Básico',
      'status': 'Ativo',
      'email': 'luciana.pereira@email.com',
      'cpf': '555.555.555-55',
      'dataNascimento': '30/07/1995',
      'telefone': '(11) 99999-7890',
    },
  ];

  static const Color _searchFieldFillColor = Color(0xFF1E2638);
  static const Color _primaryHighlightColor = Color(0xFFEA4D3C);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    // Mesma lógica do ProfessoresScreen
    const double consumedHeightEstimate = 190.0;
    final double remainingTableHeight = screenHeight - consumedHeightEstimate;

    const List<TableColumn> alunoColumns = [
      TableColumn(title: 'Nome', dataKey: 'nome', flex: 3),
      TableColumn(title: 'Matrícula', dataKey: 'matricula', flex: 2),
      TableColumn(title: 'Plano', dataKey: 'plano', flex: 2),
      TableColumn(title: 'Status', dataKey: 'status', flex: 2),
      TableColumn(title: 'Telefone', dataKey: 'telefone', flex: 3),
      TableColumn(title: 'Ações', dataKey: 'id', isAction: true, flex: 1),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciamento de Alunos',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Gerencie todos os alunos da academia',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(178),
            ),
          ),
          const SizedBox(height: 32.0),

          // Campo de busca + botão igual ao dos professores
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar aluno...',
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
                  _showCadastroDialog(context);
                },
                icon: const Icon(Icons.add, size: 20, color: Colors.white),
                label: const Text(
                  'Novo Aluno',
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
            height: remainingTableHeight - 11.0, // mesma proporção da tela
            child: CustomDataTable(
              title: 'Lista de Alunos',
              columns: alunoColumns,
              data: _alunoData,
              hasActions: true,
              onEdit: (aluno) {
                _showCadastroDialog(context, aluno: aluno);
              },
              onDelete: (aluno) {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmationDialog(
                    title: 'Confirmar Exclusão',
                    content:
                        'Tem certeza de que deseja excluir o aluno ${aluno['nome']}? Esta ação não pode ser desfeita.',
                    onConfirm: () {
                      print('Chamado para Excluir Aluno ID: ${aluno['id']}');
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
    Map<String, dynamic>? aluno,
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
              maxWidth: screenWidth * 0.4,
              maxHeight: screenHeight * 0.9,
            ),
            child: CadastroAlunoScreen(
              aluno: aluno,
              onCancel: () => Navigator.of(context).pop(),
            ),
          ),
        );
      },
    );
  }
}
