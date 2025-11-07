import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:minha_academia_front/domain/model/response/professor_response_dto.dart';
import 'package:minha_academia_front/domain/model/request/professor_request_dto.dart';

class ProfessorService {
  static const String _mockPath = 'mock.json';
  static const String _professorsKey = 'professores';

  static List<ProfessorResponseDto>? _professorsCache;

  static Future<void> _ensureCacheIsLoaded() async {
    if (_professorsCache != null) return;

    try {
      final String response = await rootBundle.loadString(_mockPath);
      final Map<String, dynamic> data = json.decode(response);

      final List<dynamic> professorsJsonList =
          data[_professorsKey] as List<dynamic>? ?? [];

      _professorsCache = professorsJsonList
          .map((json) => ProfessorResponseDto.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Erro fatal ao carregar o cache de professores: $e');
      _professorsCache = [];
      throw Exception('Falha na inicialização dos dados de professores.');
    }
  }

  static Future<List<ProfessorResponseDto>> fetchAllProfessors({
    bool includeInactive = false,
  }) async {
    await _ensureCacheIsLoaded();
    await Future.delayed(const Duration(milliseconds: 300));

    if (includeInactive) {
      return _professorsCache!;
    }
    return _professorsCache!.where((p) => p.ativo).toList();
  }

  static Future<ProfessorResponseDto?> fetchProfessorById(int id) async {
    await _ensureCacheIsLoaded();
    await Future.delayed(const Duration(milliseconds: 100));

    return _professorsCache!.firstWhereOrNull((p) => p.id == id);
  }

  static Future<ProfessorResponseDto> createProfessor(
    ProfessorRequestDto requestDto,
  ) async {
    await _ensureCacheIsLoaded();
    await Future.delayed(const Duration(milliseconds: 400));
    int newId = (_professorsCache!.isEmpty
        ? 1
        : (_professorsCache!.map((p) => p.id).reduce((a, b) => a > b ? a : b) +
              1));
    final professorToSave = ProfessorResponseDto(
      id: newId,
      nome: requestDto.nome,
      cref: requestDto.cref,
      email: requestDto.email,
      cpf: requestDto.cpf,
      status: requestDto.status,
      telefone: requestDto.telefone,
      ativo: true,
    );

    _professorsCache!.add(professorToSave);
    return professorToSave;
  }

  static Future<ProfessorResponseDto> updateProfessor(
    int id,
    ProfessorRequestDto requestDto,
  ) async {
    await _ensureCacheIsLoaded();
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _professorsCache!.indexWhere((p) => p.id == id);

    if (index == -1) {
      throw Exception('Professor com ID $id não encontrado para atualização.');
    }
    final bool currentAtivoStatus = _professorsCache![index].ativo;
    final professorToUpdate = ProfessorResponseDto(
      id: id,
      nome: requestDto.nome,
      cref: requestDto.cref,
      email: requestDto.email,
      cpf: requestDto.cpf,
      status: requestDto.status,
      telefone: requestDto.telefone,
      ativo: currentAtivoStatus,
    );

    _professorsCache![index] = professorToUpdate;
    return professorToUpdate;
  }

  static Future<void> deleteProfessor(int id) async {
    await _ensureCacheIsLoaded();
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _professorsCache!.indexWhere((p) => p.id == id);

    if (index == -1) {
      throw Exception('Professor com ID $id não encontrado para exclusão.');
    }

    final professorToMarkInactive = _professorsCache![index];

    _professorsCache![index] = ProfessorResponseDto(
      id: professorToMarkInactive.id,
      nome: professorToMarkInactive.nome,
      cref: professorToMarkInactive.cref,
      email: professorToMarkInactive.email,
      cpf: professorToMarkInactive.cpf,
      status: 'Não Ativo',
      telefone: professorToMarkInactive.telefone,
      ativo: false,
    );
  }
}

extension IterableExtensions<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
