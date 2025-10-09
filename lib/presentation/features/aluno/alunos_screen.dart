import 'package:flutter/material.dart';
import 'package:minha_academia_front/presentation/widgets/table/custom_data_table.dart';

class AlunosScreen extends StatelessWidget {
  const AlunosScreen({super.key});

  final List<Map<String, dynamic>> _alunoData = const [
    {
      'id': 1,
      'nome': 'Ana Silva',
      'matricula': 'FP001',
      'plano': 'Premium',
      'status': 'Ativo',
      'telefone': '(11) 99999-1234',
    },
    {
      'id': 2,
      'nome': 'Carlos Santos',
      'matricula': 'FP002',
      'plano': 'Básico',
      'status': 'Ativo',
      'telefone': '(11) 99999-5678',
    },
    {
      'id': 3,
      'nome': 'Maria Oliveira',
      'matricula': 'FP003',
      'plano': 'Premium',
      'status': 'Inativo',
      'telefone': '(11) 99999-9012',
    },
    {
      'id': 4,
      'nome': 'João Costa',
      'matricula': 'FP004',
      'plano': 'Intermediário',
      'status': 'Ativo',
      'telefone': '(11) 99999-3456',
    },
    {
      'id': 5,
      'nome': 'Luciana Pereira',
      'matricula': 'FP005',
      'plano': 'Básico',
      'status': 'Ativo',
      'telefone': '(11) 99999-7890',
    },
    {
      'id': 1,
      'nome': 'Ana Silva',
      'matricula': 'FP001',
      'plano': 'Premium',
      'status': 'Ativo',
      'telefone': '(11) 99999-1234',
    },
    {
      'id': 2,
      'nome': 'Carlos Santos',
      'matricula': 'FP002',
      'plano': 'Básico',
      'status': 'Ativo',
      'telefone': '(11) 99999-5678',
    },
    {
      'id': 3,
      'nome': 'Maria Oliveira',
      'matricula': 'FP003',
      'plano': 'Premium',
      'status': 'Inativo',
      'telefone': '(11) 99999-9012',
    },
    {
      'id': 4,
      'nome': 'João Costa',
      'matricula': 'FP004',
      'plano': 'Intermediário',
      'status': 'Ativo',
      'telefone': '(11) 99999-3456',
    },
    {
      'id': 5,
      'nome': 'Luciana Pereira',
      'matricula': 'FP005',
      'plano': 'Básico',
      'status': 'Ativo',
      'telefone': '(11) 99999-7890',
    },
    {
      'id': 1,
      'nome': 'Ana Silva',
      'matricula': 'FP001',
      'plano': 'Premium',
      'status': 'Ativo',
      'telefone': '(11) 99999-1234',
    },
    {
      'id': 2,
      'nome': 'Carlos Santos',
      'matricula': 'FP002',
      'plano': 'Básico',
      'status': 'Ativo',
      'telefone': '(11) 99999-5678',
    },
    {
      'id': 3,
      'nome': 'Maria Oliveira',
      'matricula': 'FP003',
      'plano': 'Premium',
      'status': 'Inativo',
      'telefone': '(11) 99999-9012',
    },
    {
      'id': 4,
      'nome': 'João Costa',
      'matricula': 'FP004',
      'plano': 'Intermediário',
      'status': 'Ativo',
      'telefone': '(11) 99999-3456',
    },
    {
      'id': 5,
      'nome': 'Luciana Pereira',
      'matricula': 'FP005',
      'plano': 'Básico',
      'status': 'Ativo',
      'telefone': '(11) 99999-7890',
    },
  ];

  static const Color _searchFieldFillColor = Color(0xFF1E2638);
  static const Color _primaryHighlightColor = Color(0xFFEA4D3C);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const List<TableColumn> alunoColumns = [
      TableColumn(title: 'Nome', dataKey: 'nome'),
      TableColumn(title: 'Matrícula', dataKey: 'matricula'),
      TableColumn(title: 'Plano', dataKey: 'plano'),
      TableColumn(title: 'Status', dataKey: 'status'),
      TableColumn(title: 'Telefone', dataKey: 'telefone'),
      TableColumn(title: 'Ações', dataKey: 'id', isAction: true),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        const double horizontalPadding = 48.0;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: availableWidth - horizontalPadding,
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar aluno...',
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
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
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
                  height: 600,
                  child: CustomDataTable(
                    title: 'Lista de Alunos',
                    columns: alunoColumns,
                    data: _alunoData,
                    hasActions: true,
                    onEdit: (aluno) {
                      print('Chamado para Editar Aluno ID: ${aluno['id']}');
                    },
                    onDelete: (aluno) {
                      print('Chamado para Excluir Aluno ID: ${aluno['id']}');
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
