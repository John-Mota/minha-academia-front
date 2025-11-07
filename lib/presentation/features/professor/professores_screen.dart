import 'package:flutter/material.dart';
import 'package:minha_academia_front/domain/model/response/professor_response_dto.dart';
import 'package:minha_academia_front/data/services/professor_service.dart';
import 'package:minha_academia_front/presentation/widgets/table/custom_data_table.dart';
import 'package:minha_academia_front/presentation/widgets/dialog/confirmation_dialog.dart';
import 'package:minha_academia_front/presentation/features/professor/cadastro_professor_screen.dart';

class ProfessoresScreen extends StatefulWidget {
  const ProfessoresScreen({super.key});

  @override
  State<ProfessoresScreen> createState() => _ProfessoresScreenState();
}

class _ProfessoresScreenState extends State<ProfessoresScreen> {
  List<ProfessorResponseDto> _professores = [];
  bool _isLoading = true;

  static const Color _primaryHighlightColor = Color(0xFFEA4D3C);
  static const Color _searchFieldFillColor = Color(0xFF1E2638);

  @override
  void initState() {
    super.initState();
    _loadProfessores();
  }

  Future<void> _loadProfessores() async {
    final data = await ProfessorService.fetchAllProfessors(
      includeInactive: true,
    );
    setState(() {
      _professores = data;
      _isLoading = false;
    });
  }

  void _onDeleteProfessor(Map<String, dynamic> professor) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Confirmar Exclusão',
        content:
            'Tem certeza de que deseja inativar o professor ${professor['nome']}?',
        onConfirm: () async {
          final navigator = Navigator.of(context); // capture Navigator now
          await ProfessorService.deleteProfessor(professor['id']);
          await _loadProfessores();
          navigator.pop();
        },
      ),
    );
  }

  void _onEditProfessor(Map<String, dynamic> professor) {
    _showCadastroDialog(context, professor: professor);
  }

  void _onCreateProfessor() {
    _showCadastroDialog(context);
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

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
                      color: theme.colorScheme.onSurface.withAlpha(127),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: theme.colorScheme.onSurface.withAlpha(204),
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
                      onPressed: _onCreateProfessor,
                      icon: const Icon(Icons.add, size: 28),
                      color: _primaryHighlightColor,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  : ElevatedButton.icon(
                      onPressed: _onCreateProfessor,
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
              data: _professores.map((p) => p.toJson()).toList(),
              hasActions: true,
              onEdit: _onEditProfessor,
              onDelete: _onDeleteProfessor,
            ),
          ),
        ],
      ),
    );
  }
}
