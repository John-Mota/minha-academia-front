import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:minha_academia_front/domain/model/response/aluno_response_dto.dart';

class TreinoService {
  Map<String, dynamic>? _mockData;

  Future<void> _loadMockData() async {
    if (_mockData == null) {
      final String jsonString = await rootBundle.loadString('mock.json');
      _mockData = json.decode(jsonString);
    }
  }

  Future<List<AlunoResponseDto>> getAlunos() async {
    await _loadMockData();
    final List<dynamic> alunosJson = _mockData!['alunos'];
    return alunosJson.map((json) => AlunoResponseDto.fromJson(json)).toList();
  }

  Future<List<String>> getCategorias() async {
    await _loadMockData();
    final List<dynamic> categoriasJson = _mockData!['treinos_categorias'];
    return categoriasJson.cast<String>();
  }

  Future<Map<String, List<String>>> getExerciciosPorCategoria() async {
    await _loadMockData();
    final Map<String, dynamic> exerciciosJson =
        _mockData!['exerciciosPorCategoria'];

    return exerciciosJson.map((key, value) {
      return MapEntry(key, (value as List<dynamic>).cast<String>());
    });
  }

  Future<void> salvarTreino(Map<String, dynamic> treinoData) async {
    await _loadMockData();

    _mockData!['treinos'].add(treinoData);

    print("--- Treino Salvo (Simulado) ---");
    print(json.encode(treinoData));
    print("---------------------------------");
  }
}
