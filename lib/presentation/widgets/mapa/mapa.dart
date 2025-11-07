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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeMap();
      }
    });
  }

  Future<void> _initializeMap() async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    setState(() {
      _polygons = _buildPolygonsFromGeoJson(
        widget.geoJsonData,
        widget.alunoCount,
      );
    });
  }

  List<Polygon> _buildPolygonsFromGeoJson(
    Map<String, dynamic> geoJsonData,
    Map<String, int> alunoCount,
  ) {
    final polygons = <Polygon>[];

    try {
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
          final coordinates = geometry['coordinates'] as List?;
          if (coordinates == null || coordinates.isEmpty) continue;

          final ring = coordinates[0] as List;
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
          final coordinates = geometry['coordinates'] as List?;
          if (coordinates == null) continue;

          for (final polygon in coordinates) {
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
    } catch (e) {
      debugPrint('Erro ao construir polígonos: $e');
    }

    return polygons;
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
      setState(() {
        _isMapReady = true;
      });

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
            debugPrint('Erro ao ajustar camera: $e');
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
        ],
      ),
    );
  }
}
