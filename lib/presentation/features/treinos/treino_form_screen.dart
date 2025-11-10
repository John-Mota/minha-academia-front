import 'package:flutter/material.dart';
import 'package:minha_academia_front/data/services/treino_service.dart';
import 'package:minha_academia_front/domain/model/response/aluno_response_dto.dart';

class TreinoFormCard extends StatefulWidget {
  final VoidCallback onClose;
  const TreinoFormCard({super.key, required this.onClose});

  @override
  State<TreinoFormCard> createState() => _TreinoFormCardState();
}

class _TreinoFormCardState extends State<TreinoFormCard> {
  final _formKey = GlobalKey<FormState>();
  final _nomeTreinoController = TextEditingController();
  final _observacoesController = TextEditingController();

  late final TreinoService _service;
  late Future<void> _loadingFuture;

  AlunoResponseDto? _alunoSelecionado;
  String? _categoriaSelecionada;
  String? _dificuldadeSelecionada;
  List<String> _exerciciosSelecionados = [];

  List<AlunoResponseDto> _listaAlunos = [];
  List<String> _listaCategorias = [];
  Map<String, List<String>> _mapaExercicios = {};

  final List<String> _dificuldades = ['Básico', 'Intermediário', 'Avançado'];

  static const Color _searchFieldFillColor = Color(0xFF0F172A);
  static const Color _primaryHighlightColor = Color(0xFFEA4D3C);
  static const Color _accentHighlightColor = Color(0xFF9C27B0);
  static const Color _cardBackgroundColor = Color(0xFF1E293B);

  String get _duracaoCalculada => '45min';

  @override
  void initState() {
    super.initState();
    _service = TreinoService();
    _loadingFuture = _loadFormData();
  }

  @override
  void dispose() {
    _nomeTreinoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _loadFormData() async {
    try {
      final alunos = await _service.getAlunos();
      final categorias = await _service.getCategorias();
      final exercicios = await _service.getExerciciosPorCategoria();

      setState(() {
        _listaAlunos = alunos;
        _listaCategorias = categorias;
        _mapaExercicios = exercicios;
      });
    } catch (e) {
      print("Erro ao carregar dados do formulário: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao carregar dados: $e")));
    }
  }

  Future<void> _salvarFormulario() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final novoTreino = {
      "nome": _nomeTreinoController.text,
      "alunoId": _alunoSelecionado?.id,
      "alunoNome": _alunoSelecionado?.nome,
      "categoria": _categoriaSelecionada,
      "dificuldade": _dificuldadeSelecionada,
      "observacoes": _observacoesController.text,
      "exercicios": _exerciciosSelecionados,
      "duracao": _duracaoCalculada,
    };

    try {
      await _service.salvarTreino(novoTreino);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Treino salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onClose();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar treino: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildDetailField(
    ThemeData theme,
    String label,
    String hint, {
    bool isDropdown = false,
    bool isMultiline = false,
    List<String>? dropdownItems,
    String? value,
    void Function(String?)? onChanged,
    TextEditingController? controller,
  }) {
    if (isDropdown && dropdownItems != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            dropdownColor: _searchFieldFillColor,
            value: value,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: _searchFieldFillColor,
            ),
            items: dropdownItems.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: onChanged,
            style: const TextStyle(color: Colors.white),
            validator: (val) =>
                val == null || val.isEmpty ? 'Campo obrigatório' : null,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: isMultiline ? 4 : 1,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: _searchFieldFillColor,
          ),
          validator: (val) => (val == null || val.isEmpty) && !isMultiline
              ? 'Campo obrigatório'
              : null,
        ),
      ],
    );
  }

  void _mostrarDialogoExercicios() {
    if (_categoriaSelecionada == null || _categoriaSelecionada!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma Categoria primeiro.'),
        ),
      );
      return;
    }

    final List<String> exerciciosDaCategoria =
        _mapaExercicios[_categoriaSelecionada!] ?? [];
    List<String> tempSelecionados = List<String>.from(_exerciciosSelecionados);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: _cardBackgroundColor,
              title: const Text('Selecionar Exercícios'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: exerciciosDaCategoria.length,
                  itemBuilder: (context, index) {
                    final exercicio = exerciciosDaCategoria[index];
                    final isSelected = tempSelecionados.contains(exercicio);

                    return CheckboxListTile(
                      title: Text(exercicio),
                      value: isSelected,
                      onChanged: (bool? value) {
                        if (value == true) {
                          if (tempSelecionados.length < 10) {
                            setDialogState(
                              () => tempSelecionados.add(exercicio),
                            );
                          }
                        } else {
                          setDialogState(
                            () => tempSelecionados.remove(exercicio),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _exerciciosSelecionados = tempSelecionados);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildExerciseSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Exercícios', style: theme.textTheme.titleSmall),
            Text(
              '${_exerciciosSelecionados.length} / 10',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _mostrarDialogoExercicios,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: BoxDecoration(
              color: _searchFieldFillColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _exerciciosSelecionados.isEmpty
                      ? 'Selecione os exercícios...'
                      : 'Editar exercícios selecionados',
                  style: TextStyle(
                    color: _exerciciosSelecionados.isEmpty
                        ? Colors.white54
                        : Colors.white,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.white70),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _exerciciosSelecionados.map((exercicio) {
            return Chip(
              label: Text(exercicio),
              backgroundColor: _primaryHighlightColor,
              labelStyle: const TextStyle(color: Colors.white),
              onDeleted: () {
                setState(() => _exerciciosSelecionados.remove(exercicio));
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: _cardBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      child: FutureBuilder<void>(
        future: _loadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erro ao carregar: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Detalhes do Treino',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: widget.onClose,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailField(
                            theme,
                            'Nome do Treino',
                            'Ex: Treino A - Peito e Tríceps',
                            controller: _nomeTreinoController,
                          ),
                          const SizedBox(height: 16),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Aluno', style: theme.textTheme.titleSmall),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<AlunoResponseDto>(
                                dropdownColor: _searchFieldFillColor,
                                value: _alunoSelecionado,
                                decoration: InputDecoration(
                                  hintText: 'Selecionar aluno',
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: _searchFieldFillColor,
                                ),
                                items: _listaAlunos.map((
                                  AlunoResponseDto aluno,
                                ) {
                                  return DropdownMenuItem<AlunoResponseDto>(
                                    value: aluno,
                                    child: Text(
                                      aluno.nome,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (AlunoResponseDto? v) {
                                  setState(() => _alunoSelecionado = v);
                                },
                                style: const TextStyle(color: Colors.white),
                                validator: (val) =>
                                    val == null ? 'Campo obrigatório' : null,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          _buildDetailField(
                            theme,
                            'Categoria',
                            'Tipo de treino',
                            isDropdown: true,
                            dropdownItems: _listaCategorias,
                            value: _categoriaSelecionada,
                            onChanged: (v) {
                              setState(() {
                                _categoriaSelecionada = v;
                                _exerciciosSelecionados.clear();
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildDetailField(
                            theme,
                            'Dificuldade',
                            'Selecione a dificuldade',
                            isDropdown: true,
                            dropdownItems: _dificuldades,
                            value: _dificuldadeSelecionada,
                            onChanged: (v) =>
                                setState(() => _dificuldadeSelecionada = v),
                          ),
                          const SizedBox(height: 16),
                          _buildExerciseSelector(theme),
                          const SizedBox(height: 16),
                          _buildDetailField(
                            theme,
                            'Observações',
                            'Instruções especiais ou observações...',
                            isMultiline: true,
                            controller: _observacoesController,
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 8,
                            children: [
                              _buildChip(
                                'Duração: ~$_duracaoCalculada',
                                Colors.blueAccent,
                              ),
                              _buildChip(
                                'Dificuldade: ${_dificuldadeSelecionada ?? 'N/A'}',
                                _accentHighlightColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _salvarFormulario,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryHighlightColor,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Salvar Treino',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
