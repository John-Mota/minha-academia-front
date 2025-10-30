import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:minha_academia_front/domain/model/request/login_request_dto.dart';
import 'package:minha_academia_front/domain/model/response/login_response_dto.dart';

class AuthService {
  static const String _mockPath = 'mock.json';
  static const String _usuariosKey = 'usuarios';

  static List<Map<String, dynamic>>? _usuariosCache;

  static Future<void> _ensureCacheIsLoaded() async {
    if (_usuariosCache != null) return;

    try {
      final String response = await rootBundle.loadString(_mockPath);
      final Map<String, dynamic> data = json.decode(response);

      final List<dynamic> usuariosListRaw = data[_usuariosKey];

      _usuariosCache = List<Map<String, dynamic>>.from(usuariosListRaw);
    } catch (e) {
      debugPrint(
        'AUTH SERVICE CRITICAL ERROR: Falha na inicialização do Mock.',
      );
      debugPrint('Detalhes da Exceção: $e');

      _usuariosCache = [];
      throw Exception('Falha na inicialização dos dados de autenticação.');
    }
  }

  static Future<LoginResponseDto> login(LoginRequestDto request) async {
    await _ensureCacheIsLoaded();
    await Future.delayed(const Duration(milliseconds: 500));

    final userMap = _usuariosCache!.firstWhereOrNull(
      (user) => user['email'] == request.email,
    );

    if (userMap == null) {
      throw Exception('Credenciais inválidas: Usuário não encontrado.');
    }
    if (userMap['senhaHash'] != request.senha) {
      throw Exception('Credenciais inválidas: Senha incorreta.');
    }
    final String mockToken =
        'MOCK_JWT_USER_${userMap['id']}_${DateTime.now().millisecondsSinceEpoch}';

    return LoginResponseDto(
      token: mockToken,
      usuarioId: userMap['id'] as int,
      nome: userMap['nome'] as String,
      perfil: userMap['perfil'] as String,
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
