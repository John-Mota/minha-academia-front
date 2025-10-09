import 'dart:convert';

class TokenResponseDto {
  String token;

  TokenResponseDto({required this.token});

  TokenResponseDto copyWith({String? token}) {
    return TokenResponseDto(token: token ?? this.token);
  }

  Map<String, dynamic> toMap() {
    return {'token': token};
  }

  factory TokenResponseDto.fromMap(Map<String, dynamic> map) {
    return TokenResponseDto(token: map['token'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory TokenResponseDto.fromJson(String source) =>
      TokenResponseDto.fromMap(json.decode(source));

  @override
  String toString() => 'TokenResponseDto(token: $token)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TokenResponseDto && other.token == token;
  }

  @override
  int get hashCode => token.hashCode;
}
