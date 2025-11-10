import 'package:flutter/material.dart';
import 'package:minha_academia_front/presentation/features/treinos/treino_form_screen.dart';

class TreinosScreen extends StatefulWidget {
  const TreinosScreen({super.key});

  @override
  State<TreinosScreen> createState() => _TreinosScreenState();
}

class _TreinosScreenState extends State<TreinosScreen> {
  bool showCriarTreino = false;

  final _nomeExercicioController = TextEditingController();
  final _seriesController = TextEditingController();
  final _repsController = TextEditingController();
  final _cargaController = TextEditingController();

  List<Map<String, String>> _exerciseData = [];

  @override
  void initState() {
    super.initState();
    _exerciseData = [
      {
        'name': 'Supino Reto',
        'series': '4',
        'reps': '12-15',
        'load': '80kg',
        'rest': '90s',
      },
      {
        'name': 'Puxador Alto',
        'series': '3',
        'reps': '10-12',
        'load': '70kg',
        'rest': '60s',
      },
      {
        'name': 'Leg Press',
        'series': '4',
        'reps': '15-20',
        'load': '200kg',
        'rest': '120s',
      },
    ];
  }

  @override
  void dispose() {
    _nomeExercicioController.dispose();
    _seriesController.dispose();
    _repsController.dispose();
    _cargaController.dispose();
    super.dispose();
  }

  void _adicionarExercicio() {
    final nome = _nomeExercicioController.text;
    final series = _seriesController.text;
    final reps = _repsController.text;
    final carga = _cargaController.text;

    if (nome.isEmpty) return;

    final novoExercicio = {
      'name': nome,
      'series': series.isNotEmpty ? series : '0',
      'reps': reps.isNotEmpty ? reps : '0',
      'load': carga.isNotEmpty ? carga : '0kg',
      'rest': '60s',
    };

    setState(() {
      _exerciseData.add(novoExercicio);
    });

    _nomeExercicioController.clear();
    _seriesController.clear();
    _repsController.clear();
    _cargaController.clear();
  }

  void _removerExercicio(int index) {
    setState(() {
      _exerciseData.removeAt(index);
    });
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: const Color(0xFF0F172A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildDesktopExerciseForm() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _nomeExercicioController,
            decoration: _buildInputDecoration("Nome do exercício"),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 80,
          child: TextField(
            controller: _seriesController,
            decoration: _buildInputDecoration("Séries"),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 80,
          child: TextField(
            controller: _repsController,
            decoration: _buildInputDecoration("Reps"),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 100,
          child: TextField(
            controller: _cargaController,
            decoration: _buildInputDecoration("Carga"),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrangeAccent,
            minimumSize: const Size(120, 50),
          ),
          onPressed: _adicionarExercicio,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Adicionar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildMobileExerciseForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nomeExercicioController,
          decoration: _buildInputDecoration("Nome do exercício"),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _seriesController,
                decoration: _buildInputDecoration("Séries"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _repsController,
                decoration: _buildInputDecoration("Reps"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _cargaController,
                decoration: _buildInputDecoration("Carga"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrangeAccent,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: _adicionarExercicio,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Adicionar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 800;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Criar/Editar Treino",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    isMobile
                        ? IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.deepOrangeAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                showCriarTreino = true;
                              });
                            },
                          )
                        : ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                showCriarTreino = true;
                              });
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text(
                              'Criar Treino',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Monte treinos personalizados para seus alunos",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isMobile
                      ? _buildMobileExerciseForm()
                      : _buildDesktopExerciseForm(),
                ),
                const SizedBox(height: 32),
                Text(
                  "Lista de Exercícios",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _exerciseData.length,
                    itemBuilder: (context, index) {
                      final data = _exerciseData[index];
                      return _buildExerciseCard(
                        context,
                        data,
                        () => _removerExercicio(index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (showCriarTreino)
            AnimatedOpacity(
              opacity: showCriarTreino ? 1 : 0,
              duration: const Duration(milliseconds: 250),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                alignment: Alignment.center,
                child: SizedBox(
                  width: isMobile ? screenWidth * 0.95 : screenWidth * 0.5,
                  height: isMobile ? screenHeight * 0.9 : screenHeight * 0.8,
                  child: TreinoFormCard(
                    onClose: () => setState(() {
                      showCriarTreino = false;
                    }),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context,
    Map<String, String> data,
    VoidCallback onRemove,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data['name']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: Lógica de editar
                    },
                    icon: const Icon(Icons.edit, color: Colors.white70),
                  ),
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailColumn("Séries", data['series'] ?? '0'),
              _buildDetailColumn("Repetições", data['reps'] ?? '0'),
              _buildDetailColumn("Carga", data['load'] ?? '0'),
              _buildDetailColumn("Descanso", data['rest'] ?? '0'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
