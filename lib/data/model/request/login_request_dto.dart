import 'dart:convert';

class LoginRequestDto {
  String email;
  String senha;

  LoginRequestDto({this.email = '', this.senha = ''});

  LoginRequestDto copyWith({String? email, String? senha}) {
    return LoginRequestDto(
      email: email ?? this.email,
      senha: senha ?? this.senha,
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'senha': senha};
  }

  factory LoginRequestDto.fromMap(Map<String, dynamic> map) {
    return LoginRequestDto(
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginRequestDto.fromJson(String source) =>
      LoginRequestDto.fromMap(json.decode(source));

  @override
  String toString() => 'LoginRequestDto(email: $email, senha: $senha)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginRequestDto &&
        other.email == email &&
        other.senha == senha;
  }

  @override
  int get hashCode => email.hashCode ^ senha.hashCode;
}
