// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AlterarSenhaDto {
  String? senhaAtual;
  String? senhaNova;
  AlterarSenhaDto({this.senhaAtual, this.senhaNova});

  AlterarSenhaDto copyWith({String? senhaAtual, String? senhaNova}) {
    return AlterarSenhaDto(
      senhaAtual: senhaAtual ?? this.senhaAtual,
      senhaNova: senhaNova ?? this.senhaNova,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'senhaAtual': senhaAtual, 'senhaNova': senhaNova};
  }

  factory AlterarSenhaDto.fromMap(Map<String, dynamic> map) {
    return AlterarSenhaDto(
      senhaAtual: map['senhaAtual'] as String,
      senhaNova: map['senhaNova'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlterarSenhaDto.fromJson(String source) =>
      AlterarSenhaDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AlterarSenhaDto(senhaAtual: $senhaAtual, senhaNova: $senhaNova)';

  @override
  bool operator ==(covariant AlterarSenhaDto other) {
    if (identical(this, other)) return true;

    return other.senhaAtual == senhaAtual && other.senhaNova == senhaNova;
  }

  @override
  int get hashCode => senhaAtual.hashCode ^ senhaNova.hashCode;
}
