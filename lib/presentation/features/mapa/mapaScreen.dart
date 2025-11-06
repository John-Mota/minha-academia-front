import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Future<Map<String, dynamic>> _loadGeoJson() async {
  try {
    final String response = await rootBundle.loadString(
      'assets/image/Bairros_de_Fortaleza.geojson',
    );
    return json.decode(response) as Map<String, dynamic>;
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, dynamic>> _loadMockData() async {
  try {
    final String response = await rootBundle.loadString('mock.json');
    return json.decode(response) as Map<String, dynamic>;
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, dynamic>> _loadAllMapData() async {
  try {
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
  } catch (e) {
    rethrow;
  }
}

Color _getFillColor(String bairro, Map<String, int> alunoCount) {
  final count = alunoCount[bairro] ?? 0;
  switch (count) {
    case 0:
      return const Color(0xFF3a4050).withOpacity(0.8);
    case 1:
      return Colors.green[200]!.withOpacity(0.7);
    case 2:
      return Colors.yellow[400]!.withOpacity(0.8);
    case 3:
      return Colors.orange[600]!.withOpacity(0.8);
    default:
      return Colors.red[700]!.withOpacity(0.8);
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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

  List<Polygon> _buildPolygonsFromGeoJson(
    Map<String, dynamic> geoJsonData,
    Map<String, int> alunoCount,
  ) {
    final polygons = <Polygon>[];

    try {
      final features = geoJsonData['features'] as List?;
      if (features == null) {
        return polygons;
      }

      for (final feature in features) {
        final properties = feature['properties'] as Map<String, dynamic>?;
        final geometry = feature['geometry'] as Map<String, dynamic>?;

        if (geometry == null || properties == null) continue;

        final geometryType = geometry['type'] as String?;
        final bairro = properties['Nome'] as String? ?? 'Desconhecido';

        if (geometryType == 'Polygon') {
          final coordinates = geometry['coordinates'] as List?;
          if (coordinates == null || coordinates.isEmpty) continue;

          final ring = coordinates[0] as List;
          final points = ring.map<LatLng>((coord) {
            return LatLng(
              (coord[1] as num).toDouble(),
              (coord[0] as num).toDouble(),
            );
          }).toList();

          final fillColor = _getFillColor(bairro, alunoCount);

          polygons.add(
            Polygon(
              points: points,
              color: fillColor,
              borderColor: Colors.black,
              borderStrokeWidth: 0.5,
              isFilled: true,
            ),
          );
        } else if (geometryType == 'MultiPolygon') {
          final coordinates = geometry['coordinates'] as List?;
          if (coordinates == null) continue;

          for (final polygon in coordinates) {
            final ring = polygon[0] as List;
            final points = ring.map<LatLng>((coord) {
              return LatLng(
                (coord[1] as num).toDouble(),
                (coord[0] as num).toDouble(),
              );
            }).toList();

            final fillColor = _getFillColor(bairro, alunoCount);

            polygons.add(
              Polygon(
                points: points,
                color: fillColor,
                borderColor: Colors.black,
                borderStrokeWidth: 0.5,
                isFilled: true,
              ),
            );
          }
        }
      }
    } catch (e) {}

    return polygons;
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
              color: color.withOpacity(0.7),
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
      backgroundColor: const Color(0xFF1a1f2e),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mapa de Densidade',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Visualize a distribuição de alunos por bairro',
                  style: TextStyle(fontSize: 16, color: Colors.white54),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF252d3d),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _mapDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Color(0xFFff6b6b)),
                            SizedBox(height: 16),
                            Text(
                              'Carregando mapa...',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Color(0xFFff6b6b),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Erro ao carregar dados',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${snapshot.error}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white54),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Text(
                          'Nenhum dado encontrado.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    final data = snapshot.data!;
                    final geoJsonData = data['geoJson'] as Map<String, dynamic>;
                    final alunoCount = data['alunoCount'] as Map<String, int>;

                    final polygons = _buildPolygonsFromGeoJson(
                      geoJsonData,
                      alunoCount,
                    );

                    if (polygons.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhum polígono foi carregado do GeoJSON',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: const LatLng(-3.7319, -38.5267),
                              initialZoom: 14.0,
                              minZoom: 12.0,
                              maxZoom: 16.0,
                              interactionOptions: const InteractionOptions(
                                flags:
                                    InteractiveFlag.all &
                                    ~InteractiveFlag.rotate,
                              ),
                              backgroundColor: Colors.grey[300]!,

                              onMapReady: () {
                                _mapController.fitCamera(
                                  CameraFit.bounds(
                                    bounds: _fortalezaBounds,
                                    padding: const EdgeInsets.all(20.0),
                                  ),
                                );
                              },
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.academia.fortaleza',
                                tileProvider: NetworkTileProvider(),
                              ),
                              PolygonLayer(polygons: polygons),
                            ],
                          ),

                          Positioned(
                            top: 20,
                            right: 20,
                            child: FloatingActionButton(
                              mini: true,
                              backgroundColor: const Color(
                                0xFFff6b6b,
                              ).withOpacity(0.9),
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
                                ).withOpacity(0.95),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
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
                                  _buildLegendItem(
                                    '1 aluno',
                                    Colors.green[200]!,
                                  ),
                                  _buildLegendItem(
                                    '2 alunos',
                                    Colors.yellow[400]!,
                                  ),
                                  _buildLegendItem(
                                    '3 alunos',
                                    Colors.orange[600]!,
                                  ),
                                  _buildLegendItem(
                                    '4+ alunos',
                                    Colors.red[700]!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
