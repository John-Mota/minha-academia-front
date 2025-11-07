import 'package:flutter/material.dart';
import 'package:minha_academia_front/data/services/aluno_service.dart';
import 'package:minha_academia_front/domain/model/response/aluno_response_dto.dart';
import 'package:minha_academia_front/presentation/features/aluno/cadastro_aluno_screen.dart';
import 'package:minha_academia_front/presentation/widgets/table/custom_data_table.dart';
import 'package:minha_academia_front/presentation/widgets/dialog/confirmation_dialog.dart';

class AlunosScreen extends StatefulWidget {
  const AlunosScreen({super.key});

  @override
  State<AlunosScreen> createState() => _AlunosScreenState();
}

class _AlunosScreenState extends State<AlunosScreen> {
  List<AlunoResponseDto> _alunos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAlunos();
  }

  Future<void> _loadAlunos() async {
    setState(() => _loading = true);

    final alunos = await AlunoService.fetchAllAlunos(includeInactive: true);

    setState(() {
      _alunos = alunos;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color searchFieldFillColor = Color(0xFF1E2638);
    const Color primaryHighlightColor = Color(0xFFEA4D3C);
    final screenWidth = MediaQuery.of(context).size.width;
    const double mobileBreakpoint = 600.0;
    final isMobile = screenWidth < mobileBreakpoint;

    const List<TableColumn> alunoColumns = [
      TableColumn(title: 'Nome', dataKey: 'nome', flex: 3),
      TableColumn(title: 'Matrícula', dataKey: 'matricula', flex: 2),
      TableColumn(title: 'Plano', dataKey: 'plano', flex: 2),
      TableColumn(title: 'Status', dataKey: 'status', flex: 2),
      TableColumn(title: 'Telefone', dataKey: 'telefone', flex: 3),
      TableColumn(title: 'Ações', dataKey: 'id', isAction: true, flex: 2),
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciamento de Alunos',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gerencie todos os alunos da academia',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(178),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar aluno...',
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 128),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: theme.colorScheme.onSurface.withValues(
                      alpha: 255,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: primaryHighlightColor,
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: searchFieldFillColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              isMobile
                  ? IconButton(
                      onPressed: _onCreateAluno,
                      icon: const Icon(Icons.add, size: 28),
                      color: primaryHighlightColor,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  : ElevatedButton.icon(
                      onPressed: _onCreateAluno,
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
                        backgroundColor: primaryHighlightColor,
                        minimumSize: const Size(140, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : CustomDataTable(
                    title: 'Lista de Alunos',
                    columns: alunoColumns,
                    data: _alunos.map((a) => a.toJson()).toList(),
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
                              'Tem certeza de que deseja excluir o aluno ${aluno['nome']}?',
                          onConfirm: () async {
                            final navigator = Navigator.of(context);

                            await AlunoService.deleteAluno(aluno['id']);
                            navigator.pop();

                            _loadAlunos();
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

  void _onCreateAluno() {
    _showCadastroDialog(context);
  }

  void _showCadastroDialog(
    BuildContext context, {
    Map<String, dynamic>? aluno,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.4,
              maxHeight: screenHeight * 0.9,
            ),
            child: CadastroAlunoScreen(
              aluno: aluno,
              onCancel: () => Navigator.of(context).pop(),
              onSave: _loadAlunos,
            ),
          ),
        );
      },
    );
  }
}
