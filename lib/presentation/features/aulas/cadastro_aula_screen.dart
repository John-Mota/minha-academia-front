import 'package:flutter/material.dart';
import 'package:minha_academia_front/domain/model/response/professor_response_dto.dart';
import 'package:minha_academia_front/data/services/professor_service.dart';

class CadastroAulaScreen extends StatefulWidget {
  final VoidCallback? onCancel;
  final Map<String, dynamic>? aula;

  const CadastroAulaScreen({super.key, this.onCancel, this.aula});

  @override
  State<CadastroAulaScreen> createState() => _CadastroAulaScreenState();
}

class _CadastroAulaScreenState extends State<CadastroAulaScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _isEditing;

  List<ProfessorResponseDto> _professores = [];
  ProfessorResponseDto? _selectedProfessor;

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _capacidadeController = TextEditingController();
  final _duracaoController = TextEditingController();

  static const Color _fieldFillColor = Color(0xFF1E2638);
  static const Color _primaryHighlightColor = Color(0xFFEA4D3C);

  @override
  void initState() {
    super.initState();
    _isEditing = widget.aula != null;
    _loadProfessores();

    if (_isEditing) {
      // TODO: Preencher campos com dados da aula
    }
  }

  Future<void> _loadProfessores() async {
    final data = await ProfessorService.fetchAllProfessors();
    setState(() {
      _professores = data;
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _capacidadeController.dispose();
    _duracaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? 'Editar Aula' : 'Cadastro de Nova Aula',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.onCancel != null)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: widget.onCancel,
                    ),
                ],
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                controller: _nomeController,
                label: 'Nome da Aula',
              ),
              const SizedBox(height: 20.0),
              _buildProfessorDropdown(),
              const SizedBox(height: 20.0),
              _buildTextField(
                controller: _descricaoController,
                label: 'Descrição',
                maxLines: 3,
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _capacidadeController,
                      label: 'Capacidade',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      controller: _duracaoController,
                      label: 'Duração (min)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              // TODO: Adicionar seletor de dias da semana (ex: checkboxes)
              const SizedBox(height: 40.0),
              Row(
                children: [
                  if (widget.onCancel != null) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onCancel,
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implementar lógica de salvar
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryHighlightColor,
                      ),
                      child: Text(
                        _isEditing ? 'Salvar Alterações' : 'Cadastrar',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: _fieldFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildProfessorDropdown() {
    return DropdownButtonFormField<ProfessorResponseDto>(
      value: _selectedProfessor,
      items: _professores.map((ProfessorResponseDto professor) {
        return DropdownMenuItem<ProfessorResponseDto>(
          value: professor,
          child: Text(professor.nome),
        );
      }).toList(),
      onChanged: (ProfessorResponseDto? newValue) {
        setState(() {
          _selectedProfessor = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: 'Professor',
        filled: true,
        fillColor: _fieldFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
