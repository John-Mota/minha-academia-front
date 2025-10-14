import 'package:flutter/material.dart';

class TreinoFormCard extends StatefulWidget {
  final VoidCallback onClose;
  const TreinoFormCard({super.key, required this.onClose});

  @override
  State<TreinoFormCard> createState() => _TreinoFormCardState();
}

class _TreinoFormCardState extends State<TreinoFormCard> {
  String? _alunoSelecionado;
  String? _categoriaSelecionada;
  String? _dificuldadeSelecionada;

  final List<String> _alunos = ['João Silva', 'Maria Souza', 'Carlos Lima'];
  final List<String> _categorias = [
    'Peito e Tríceps',
    'Costas e Bíceps',
    'Pernas',
    'Ombros',
  ];
  final List<String> _dificuldades = ['Básico', 'Intermediário', 'Avançado'];

  static const Color _searchFieldFillColor = Color(0xFF0F172A);
  static const Color _primaryHighlightColor = Color(0xFFEA4D3C);
  static const Color _accentHighlightColor = Color(0xFF9C27B0);
  String get _duracaoCalculada => '45min';

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
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        TextField(
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
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
                  ),
                  const SizedBox(height: 16),
                  _buildDetailField(
                    theme,
                    'Aluno',
                    'Selecionar aluno',
                    isDropdown: true,
                    dropdownItems: _alunos,
                    value: _alunoSelecionado,
                    onChanged: (v) => setState(() => _alunoSelecionado = v),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailField(
                    theme,
                    'Categoria',
                    'Tipo de treino',
                    isDropdown: true,
                    dropdownItems: _categorias,
                    value: _categoriaSelecionada,
                    onChanged: (v) => setState(() => _categoriaSelecionada = v),
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
                  _buildDetailField(
                    theme,
                    'Observações',
                    'Instruções especiais ou observações...',
                    isMultiline: true,
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
              onPressed: widget.onClose,
              child: const Text(
                'Salvar Treino',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryHighlightColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
