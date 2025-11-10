import 'package:flutter/material.dart';
import 'package:minha_academia_front/presentation/features/maquinas/maquinas_screen.dart';

class CadastroMaquinasScreen extends StatefulWidget {
  final MachineCardData? maquina;

  const CadastroMaquinasScreen({super.key, this.maquina});

  @override
  State<CadastroMaquinasScreen> createState() => _CadastroMaquinasScreenState();
}

class _CadastroMaquinasScreenState extends State<CadastroMaquinasScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _idController = TextEditingController();
  final _dataManutencaoController = TextEditingController();
  String? _statusSelecionado;

  final List<String> _statusOptions = [
    'Operacional',
    'Em Manutenção',
    'Quebrado',
  ];

  static const Color _primaryHighlightColor = Color(0xFFEA4D3C);
  static const Color _searchFieldFillColor = Color(0xFF1E2638);

  bool get _isEditing => widget.maquina != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final maquina = widget.maquina!;
      _nomeController.text = maquina.title;
      _idController.text = maquina.id;
      _dataManutencaoController.text = maquina.lastMaintenance;
      _statusSelecionado = maquina.status;
    } else {
      _statusSelecionado = _statusOptions.first;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idController.dispose();
    _dataManutencaoController.dispose();
    super.dispose();
  }

  void _salvarFormulario() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implementar a lógica de salvar no service
      // if (_isEditing) {
      //   _service.updateMaquina(...);
      // } else {
      //   _service.addMaquina(...);
      // }

      print('Salvando: ${_nomeController.text}');
      Navigator.pop(context);
    }
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
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
        borderSide: const BorderSide(color: _primaryHighlightColor, width: 1.0),
      ),
      filled: true,
      fillColor: _searchFieldFillColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Máquina' : 'Cadastrar Máquina'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: _buildInputDecoration('Nome da Máquina'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _idController,
                decoration: _buildInputDecoration('ID do Ativo (ex: EQ009)'),
                readOnly: _isEditing,
                style: _isEditing ? const TextStyle(color: Colors.grey) : null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _statusSelecionado,
                items: _statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _statusSelecionado = newValue;
                  });
                },
                decoration: _buildInputDecoration('Status'),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione o status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dataManutencaoController,
                decoration: _buildInputDecoration(
                  'Última Manutenção (DD/MM/AAAA)',
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _salvarFormulario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryHighlightColor,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _isEditing ? 'Salvar Alterações' : 'Cadastrar Máquina',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
