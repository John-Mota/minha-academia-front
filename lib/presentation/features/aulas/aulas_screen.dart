import 'package:flutter/material.dart';
import 'package:minha_academia_front/data/services/aula_service.dart';
import 'package:minha_academia_front/domain/model/response/aula_response_dto.dart';
import 'package:minha_academia_front/presentation/features/aulas/cadastro_aula_screen.dart';
import 'package:minha_academia_front/presentation/widgets/table/custom_data_table.dart';

class AulasScreen extends StatefulWidget {
  const AulasScreen({super.key});

  @override
  State<AulasScreen> createState() => _AulasScreenState();
}

class _AulasScreenState extends State<AulasScreen> {
  List<AulaResponseDto> _aulas = [];
  bool _isLoading = true;

  static const Color _primaryHighlightColor = Color(0xFFEA4D3C);
  static const Color _searchFieldFillColor = Color(0xFF1E2638);

  @override
  void initState() {
    super.initState();
    _loadAulas();
  }

  Future<void> _loadAulas() async {
    final data = await AulaService.fetchAllAulas(includeInactive: true);
    setState(() {
      _aulas = data;
      _isLoading = false;
    });
  }

  void _onEditAula(Map<String, dynamic> aula) {
    _showCadastroDialog(context, aula: aula);
  }

  void _onCreateAula() {
    _showCadastroDialog(context);
  }

  void _showCadastroDialog(BuildContext context, {Map<String, dynamic>? aula}) {
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
            child: CadastroAulaScreen(
              aula: aula,
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

    const List<TableColumn> aulaColumns = [
      TableColumn(title: 'Aula', dataKey: 'nome', flex: 2),
      TableColumn(title: 'Professor', dataKey: 'professor', flex: 2),
      TableColumn(title: 'Duração', dataKey: 'duracaoMinutos', flex: 2),
      TableColumn(title: 'Vagas', dataKey: 'vagas', flex: 2),
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
            'Gerenciamento de Aulas',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Gerencie todas as aulas da academia',
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
                    hintText: 'Buscar aula...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: _searchFieldFillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              isMobile
                  ? IconButton(
                      onPressed: _onCreateAula,
                      icon: const Icon(Icons.add, size: 28),
                      color: _primaryHighlightColor,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  : ElevatedButton.icon(
                      onPressed: _onCreateAula,
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Nova Aula',
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
              title: 'Lista de Aulas',
              columns: aulaColumns,
              data: _aulas.map((a) => a.toJson()).toList(),
              hasActions: true,
              onEdit: _onEditAula,
              onDelete: (aula) {},
            ),
          ),
        ],
      ),
    );
  }
}
