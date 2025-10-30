class LoginResponseDto {
  final String token;
  final int usuarioId;
  final String nome;
  final String perfil;
  LoginResponseDto({
    required this.token,
    required this.usuarioId,
    required this.nome,
    required this.perfil,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      token: json['token'] as String,
      usuarioId: json['usuarioId'] as int,
      nome: json['nome'] as String,
      perfil: json['perfil'] as String,
    );
  }
}
