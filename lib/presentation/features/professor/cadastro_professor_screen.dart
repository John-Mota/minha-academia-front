import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minha_academia_front/utils/constants/colors.dart';
import 'package:minha_academia_front/utils/formatters/inputs_formatters.dart';

class CadastroProfessorScreen extends StatefulWidget {
  final VoidCallback? onCancel;

  const CadastroProfessorScreen({super.key, this.onCancel});

  @override
  State<CadastroProfessorScreen> createState() =>
      _CadastroProfessorScreenState();
}

class _CadastroProfessorScreenState extends State<CadastroProfessorScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isEmailDuplicate = false;
  bool _isCpfDuplicate = false;

  final _nomeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _crefController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();

  static const Color _fieldFillColor = Color(0xFF1E2638);
  static const Color _primaryHighlightColor = Color(0xFFEA4D3C);

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _isEmailDuplicate = _emailController.text == 'existente@email.com';
      });
    });
    _cpfController.addListener(() {
      setState(() {
        _isCpfDuplicate = _cpfController.text == '111.111.111-11';
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nomeController.dispose();
    _dataNascimentoController.dispose();
    _crefController.dispose();
    _cpfController.dispose();
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
                    'Cadastro de Novo Professor',
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
                label: 'Nome Completo',
                hint: 'Digite o nome completo',
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                controller: _emailController,
                label: 'E-mail',
                hint: 'exemplo@email.com',
                keyboardType: TextInputType.emailAddress,
                isDuplicate: _isEmailDuplicate,
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                controller: _cpfController,
                label: 'CPF',
                hint: '000.000.000-00',
                keyboardType: TextInputType.number,
                formatters: [InputFormatters.cpfFormatter()],
                isDuplicate: _isCpfDuplicate,
              ),
              const SizedBox(height: 20.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _dataNascimentoController,
                      label: 'Data de Nascimento',
                      hint: 'DD/MM/AAAA',
                      keyboardType: TextInputType.datetime,
                      formatters: [InputFormatters.dateFormatter()],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      controller: _crefController,
                      label: 'CREF',
                      hint: '000000-G/SP',
                      keyboardType: TextInputType.text,
                      formatters: [InputFormatters.crefFormatter()],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60.0),
              Row(
                children: [
                  if (widget.onCancel != null) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onCancel,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryHighlightColor,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Cadastrar e Enviar Ativação'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                'Ao cadastrar, um link seguro para criação de senha será enviado ao e-mail informado. O usuário terá o status PENDENTE até a ativação.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    TextEditingController? controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
    bool isDuplicate = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: formatters,
          decoration: _inputDecoration(hint: hint, isDuplicate: isDuplicate),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    bool isDuplicate = false,
  }) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: _fieldFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _primaryHighlightColor, width: 1.0),
      ),
      suffixIcon: isDuplicate
          ? const Tooltip(
              message: 'Este valor já está em uso.',
              child: Icon(Icons.warning_amber_rounded, color: warningColor),
            )
          : null,
    );
  }
}
