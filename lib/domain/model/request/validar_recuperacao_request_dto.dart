// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ValidarRecuperacaoRequestDto {
  String? pinCode;
  String? novaSenha;
  ValidarRecuperacaoRequestDto({this.pinCode, this.novaSenha});

  ValidarRecuperacaoRequestDto copyWith({String? pinCode, String? novaSenha}) {
    return ValidarRecuperacaoRequestDto(
      pinCode: pinCode ?? this.pinCode,
      novaSenha: novaSenha ?? this.novaSenha,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'pinCode': pinCode, 'novaSenha': novaSenha};
  }

  factory ValidarRecuperacaoRequestDto.fromMap(Map<String, dynamic> map) {
    return ValidarRecuperacaoRequestDto(
      pinCode: map['pinCode'] != null ? map['pinCode'] as String : null,
      novaSenha: map['novaSenha'] != null ? map['novaSenha'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ValidarRecuperacaoRequestDto.fromJson(String source) =>
      ValidarRecuperacaoRequestDto.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() =>
      'ValidarRecuperacaoRequestDto(pinCode: $pinCode, novaSenha: $novaSenha)';

  @override
  bool operator ==(covariant ValidarRecuperacaoRequestDto other) {
    if (identical(this, other)) return true;

    return other.pinCode == pinCode && other.novaSenha == novaSenha;
  }

  @override
  int get hashCode => pinCode.hashCode ^ novaSenha.hashCode;
}
