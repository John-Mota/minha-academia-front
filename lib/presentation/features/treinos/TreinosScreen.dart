import 'package:flutter/material.dart';
import 'package:minha_academia_front/presentation/features/treinos/TreinoFormScreen.dart';

class TreinosScreen extends StatefulWidget {
  const TreinosScreen({super.key});

  @override
  State<TreinosScreen> createState() => _TreinosScreenState();
}

class _TreinosScreenState extends State<TreinosScreen> {
  bool showCriarTreino = false;

  final List<Map<String, String>> _exerciseData = const [
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                    ElevatedButton.icon(
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Nome do exercício",
                            labelStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Séries",
                            labelStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Reps",
                            labelStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Carga",
                            labelStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          minimumSize: const Size(120, 50),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Adicionar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
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
                  child: ListView(
                    children: _exerciseData
                        .map((data) => _buildExerciseCard(context, data))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          if (showCriarTreino)
            AnimatedOpacity(
              opacity: showCriarTreino ? 1 : 0,
              duration: const Duration(milliseconds: 250),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.8,
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

  Widget _buildExerciseCard(BuildContext context, Map<String, String> data) {
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
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Colors.white70),
                  ),
                  IconButton(
                    onPressed: () {},
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
              _buildDetailColumn("Séries", data['series']!),
              _buildDetailColumn("Repetições", data['reps']!),
              _buildDetailColumn("Carga", data['load']!),
              _buildDetailColumn("Descanso", data['rest']!),
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
