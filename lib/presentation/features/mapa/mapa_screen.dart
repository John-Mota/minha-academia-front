import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../widgets/mapa/mapa.dart';

Future<Map<String, dynamic>> _loadGeoJson() async {
  final response = await rootBundle.loadString(
    'assets/image/Bairros_de_Fortaleza.geojson',
  );
  return json.decode(response) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> _loadMockData() async {
  final response = await rootBundle.loadString('mock.json');
  return json.decode(response) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> _loadAllMapData() async {
  final results = await Future.wait([_loadGeoJson(), _loadMockData()]);
  final geoJson = results[0];
  final mockData = results[1];

  final Map<String, int> alunoCount = {};
  if (mockData['alunos'] is List) {
    for (var aluno in mockData['alunos']) {
      final bairro = aluno['endereco']?['bairro'] as String?;
      if (bairro != null) {
        alunoCount[bairro] = (alunoCount[bairro] ?? 0) + 1;
      }
    }
  }

  return {'geoJson': geoJson, 'alunoCount': alunoCount};
}

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  late Future<Map<String, dynamic>> _mapDataFuture;
  final MapController _mapController = MapController();

  final LatLngBounds _fortalezaBounds = LatLngBounds(
    const LatLng(-3.9500, -38.7000),
    const LatLng(-3.6500, -38.3500),
  );

  @override
  void initState() {
    super.initState();
    _mapDataFuture = _loadAllMapData();
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 179),
              border: Border.all(color: Colors.white24, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mapa de Densidade',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Visualize a distribuição de alunos por bairro',
              style: TextStyle(fontSize: 16, color: Colors.white54),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF252d3d),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 25.5),
                    width: 1,
                  ),
                ),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _mapDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFff6b6b),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erro ao carregar dados: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          'Nenhum dado encontrado.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    final data = snapshot.data!;
                    final geoJson = data['geoJson'] as Map<String, dynamic>;
                    final alunoCount = data['alunoCount'] as Map<String, int>;

                    return Stack(
                      children: [
                        MapaWidget(
                          geoJsonData: geoJson,
                          alunoCount: alunoCount,
                          mapController: _mapController,
                          fortalezaBounds: _fortalezaBounds,
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor: const Color(
                              0xFFff6b6b,
                            ).withValues(alpha: 229.5),
                            onPressed: () {
                              _mapController.fitCamera(
                                CameraFit.bounds(
                                  bounds: _fortalezaBounds,
                                  padding: const EdgeInsets.all(40.0),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.zoom_out_map,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF1a1f2e,
                              ).withValues(alpha: 242.25),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 25.5),
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Alunos por Bairro',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildLegendItem(
                                  '0 alunos',
                                  const Color(0xFF3a4050),
                                ),
                                _buildLegendItem('1 aluno', Colors.green[200]!),
                                _buildLegendItem(
                                  '2 alunos',
                                  Colors.yellow[400]!,
                                ),
                                _buildLegendItem(
                                  '3 alunos',
                                  Colors.orange[600]!,
                                ),
                                _buildLegendItem('4+ alunos', Colors.red[700]!),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
