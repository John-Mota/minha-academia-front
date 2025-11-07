import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaWidget extends StatefulWidget {
  final Map<String, dynamic> geoJsonData;
  final Map<String, int> alunoCount;
  final MapController mapController;
  final LatLngBounds fortalezaBounds;

  const MapaWidget({
    super.key,
    required this.geoJsonData,
    required this.alunoCount,
    required this.mapController,
    required this.fortalezaBounds,
  });

  @override
  State<MapaWidget> createState() => _MapaWidgetState();
}

class _MapaWidgetState extends State<MapaWidget> {
  bool _isMapReady = false;
  List<Polygon> _polygons = [];
  List<Marker> _labels = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initializeMap();
    });
  }

  Future<void> _initializeMap() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;

    final polygons = _buildPolygonsFromGeoJson(
      widget.geoJsonData,
      widget.alunoCount,
    );
    final labels = _buildLabelsFromGeoJson(
      widget.geoJsonData,
      widget.alunoCount,
    );

    setState(() {
      _polygons = polygons;
      _labels = labels;
    });
  }

  List<Polygon> _buildPolygonsFromGeoJson(
    Map<String, dynamic> geoJsonData,
    Map<String, int> alunoCount,
  ) {
    final polygons = <Polygon>[];
    final features = geoJsonData['features'] as List?;
    if (features == null) return polygons;

    for (final feature in features) {
      final properties = feature['properties'] as Map<String, dynamic>?;
      final geometry = feature['geometry'] as Map<String, dynamic>?;

      if (geometry == null || properties == null) continue;

      final geometryType = geometry['type'] as String?;
      final bairro = properties['Nome'] as String? ?? 'Desconhecido';
      final fillColor = _getFillColor(bairro, alunoCount);

      if (geometryType == 'Polygon') {
        final coords = geometry['coordinates'] as List?;
        if (coords == null || coords.isEmpty) continue;

        final ring = coords[0] as List;
        final points = ring
            .map<LatLng>(
              (coord) => LatLng(
                (coord[1] as num).toDouble(),
                (coord[0] as num).toDouble(),
              ),
            )
            .toList();

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
        final coords = geometry['coordinates'] as List?;
        if (coords == null) continue;

        for (final polygon in coords) {
          final ring = polygon[0] as List;
          final points = ring
              .map<LatLng>(
                (coord) => LatLng(
                  (coord[1] as num).toDouble(),
                  (coord[0] as num).toDouble(),
                ),
              )
              .toList();

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

    return polygons;
  }

  List<Marker> _buildLabelsFromGeoJson(
    Map<String, dynamic> geoJsonData,
    Map<String, int> alunoCount,
  ) {
    final markers = <Marker>[];
    final features = geoJsonData['features'] as List?;
    if (features == null) return markers;

    for (final feature in features) {
      final properties = feature['properties'] as Map<String, dynamic>?;
      final geometry = feature['geometry'] as Map<String, dynamic>?;
      if (geometry == null || properties == null) continue;

      final bairro = properties['Nome'] as String? ?? 'Desconhecido';
      final coords = geometry['coordinates'];
      if (coords == null) continue;

      List<List<dynamic>> allCoords = [];

      if (geometry['type'] == 'Polygon') {
        allCoords = (coords[0] as List).cast<List<dynamic>>();
      } else if (geometry['type'] == 'MultiPolygon') {
        for (var polygon in coords) {
          allCoords.addAll((polygon[0] as List).cast<List<dynamic>>());
        }
      } else {
        continue;
      }

      final center = _calculateCentroid(allCoords);
      final temAlunos = (alunoCount[bairro] ?? 0) > 0;

      markers.add(
        Marker(
          point: center,
          width: 100,
          height: 30,
          child: Center(
            child: Text(
              bairro,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: temAlunos ? Colors.black : Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                shadows: temAlunos
                    ? []
                    : [const Shadow(offset: Offset(0.5, 0.5), blurRadius: 2)],
              ),
            ),
          ),
        ),
      );
    }

    return markers;
  }

  LatLng _calculateCentroid(List<List<dynamic>> coords) {
    double latSum = 0;
    double lonSum = 0;
    for (var coord in coords) {
      lonSum += (coord[0] as num).toDouble();
      latSum += (coord[1] as num).toDouble();
    }
    final n = coords.length;
    return LatLng(latSum / n, lonSum / n);
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

  void _handleMapReady() {
    if (!_isMapReady && mounted) {
      setState(() => _isMapReady = true);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          try {
            widget.mapController.fitCamera(
              CameraFit.bounds(
                bounds: widget.fortalezaBounds,
                padding: const EdgeInsets.all(20.0),
              ),
            );
          } catch (e) {
            debugPrint('Erro ao ajustar câmera: $e');
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: FlutterMap(
        mapController: widget.mapController,
        options: MapOptions(
          initialCenter: const LatLng(-3.7319, -38.5267),
          initialZoom: 14.0,
          minZoom: 12.0,
          maxZoom: 16.0,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
          backgroundColor: Colors.grey[300]!,
          onMapReady: _handleMapReady,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.academia.fortaleza',
            tileProvider: NetworkTileProvider(),
          ),
          if (_polygons.isNotEmpty) PolygonLayer(polygons: _polygons),
          if (_labels.isNotEmpty) MarkerLayer(markers: _labels),
        ],
      ),
    );
  }
}
