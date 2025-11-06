import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:minha_academia_front/data/services/professor_service.dart';
import 'package:minha_academia_front/domain/model/response/aula_response_dto.dart';

import 'package:minha_academia_front/domain/model/response/professor_response_dto.dart';

class AulaService {
  static const String _mockPath = 'mock.json';
  static const String _aulasKey = 'aulas';

  static List<AulaResponseDto>? _aulasCache;

  static Future<void> _ensureCacheIsLoaded() async {
    if (_aulasCache != null) return;

    try {
      final String response = await rootBundle.loadString(_mockPath);
      final Map<String, dynamic> data = json.decode(response);

      final List<dynamic> aulasJsonList =
          data[_aulasKey] as List<dynamic>? ?? [];

      List<ProfessorResponseDto> professores =
          await ProfessorService.fetchAllProfessors(includeInactive: true);

      Map<int, ProfessorResponseDto> professorMap = {
        for (var p in professores) p.id: p,
      };

      aulasJsonList.forEach((aula) => print(aula));

      _aulasCache = aulasJsonList.map((json) {
        ProfessorResponseDto? professor = professorMap[json['professorId']];
        if (professor == null) {
          throw Exception(
            'Professor com ID ${json['professorId']} não encontrado para a aula ${json['id']}',
          );
        }
        return AulaResponseDto.fromJson(json, professor);
      }).toList();

      _aulasCache!.forEach((aula) => print(aula.toJson()));
    } catch (e, st) {
      debugPrint('❌ Erro ao carregar o cache de aulas: $e\n$st');
      _aulasCache = [];
      throw Exception('Falha na inicialização dos dados de aulas.');
    }
  }

  static Future<List<AulaResponseDto>> fetchAllAulas({
    bool includeInactive = false,
  }) async {
    await _ensureCacheIsLoaded();
    await Future.delayed(const Duration(milliseconds: 300));

    if (includeInactive) {
      return List.from(_aulasCache!);
    }
    return _aulasCache!.where((a) => a.ativo).toList();
  }
}
