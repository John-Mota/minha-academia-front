// AlunoService.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:minha_academia_front/domain/model/request/aluno_request_dto.dart';
import 'package:minha_academia_front/domain/model/response/aluno_response_dto.dart';

class AlunoService {
  static const String _mockPath = 'mock.json';
  static const String _alunosKey = 'alunos';

  static List<AlunoResponseDto>? _alunosCache;
  static Future<void> _ensureCacheIsLoaded() async {
    if (_alunosCache != null) return;

    try {
      final String response = await rootBundle.loadString(_mockPath);

      final dynamic data = json.decode(response);
      List<dynamic> alunosJsonList;

      if (data is Map<String, dynamic>) {
        alunosJsonList = data[_alunosKey] as List<dynamic>? ?? [];
      } else {
        alunosJsonList = [];
      }

      _alunosCache = alunosJsonList
          .map((json) => AlunoResponseDto.fromJson(json))
          .toList();
    } catch (e) {
      _alunosCache = [];
      throw Exception('Falha na inicialização dos dados de alunos.');
    }
  }

  static Future<List<AlunoResponseDto>> fetchAllAlunos({
    bool includeInactive = false,
  }) async {
    await _ensureCacheIsLoaded();
    await Future.delayed(const Duration(milliseconds: 300));

    if (includeInactive) {
      return List.from(_alunosCache!);
    } else {
      return _alunosCache!.where((a) => a.ativo).toList();
    }
  }

  static Future<AlunoResponseDto?> fetchAlunoById(int id) async {
    await _ensureCacheIsLoaded();
    await Future.delayed(const Duration(milliseconds: 100));
    return _alunosCache!.firstWhereOrNull((a) => a.id == id);
  }

  static Future<AlunoResponseDto> createAluno(
    AlunoRequestDto requestDto,
  ) async {
    await _ensureCacheIsLoaded();
    await Future.delayed(const Duration(milliseconds: 400));

    int newId = (_alunosCache!.isEmpty
        ? 1
        : (_alunosCache!.map((a) => a.id).reduce((a, b) => a > b ? a : b) + 1));

    final alunoToSave = AlunoResponseDto(
      id: newId,
      nome: requestDto.nome,
      matricula: requestDto.matricula,
      plano: requestDto.plano,
      status: 'Ativo',
      email: requestDto.email,
      cpf: requestDto.cpf,
      dataNascimento: requestDto.dataNascimento,
      telefone: requestDto.telefone,
      ativo: true,
    );

    _alunosCache!.add(alunoToSave);
    return alunoToSave;
  }

  static Future<AlunoResponseDto> updateAluno(
    int id,
    AlunoRequestDto requestDto,
  ) async {
    await _ensureCacheIsLoaded();
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _alunosCache!.indexWhere((a) => a.id == id);
    if (index == -1) {
      throw Exception('Aluno com ID $id não encontrado para atualização.');
    }

    final currentAtivoStatus = _alunosCache![index].ativo;

    final alunoToUpdate = AlunoResponseDto(
      id: id,
      nome: requestDto.nome,
      matricula: requestDto.matricula,
      plano: requestDto.plano,
      status: requestDto.status,
      email: requestDto.email,
      cpf: requestDto.cpf,
      dataNascimento: requestDto.dataNascimento,
      telefone: requestDto.telefone,
      ativo: currentAtivoStatus,
    );

    _alunosCache![index] = alunoToUpdate;
    return alunoToUpdate;
  }

  static Future<void> deleteAluno(int id) async {
    await _ensureCacheIsLoaded();
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _alunosCache!.indexWhere((a) => a.id == id);
    if (index == -1) {
      throw Exception('Aluno com ID $id não encontrado para exclusão.');
    }

    final alunoToMarkInactive = _alunosCache![index];
    _alunosCache![index] = AlunoResponseDto(
      id: alunoToMarkInactive.id,
      nome: alunoToMarkInactive.nome,
      matricula: alunoToMarkInactive.matricula,
      plano: alunoToMarkInactive.plano,
      status: 'Inativo',
      email: alunoToMarkInactive.email,
      cpf: alunoToMarkInactive.cpf,
      dataNascimento: alunoToMarkInactive.dataNascimento,
      telefone: alunoToMarkInactive.telefone,
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
