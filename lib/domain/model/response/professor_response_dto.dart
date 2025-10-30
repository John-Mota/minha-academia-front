class ProfessorResponseDto {
  final int id;
  final String nome;
  final String cref;
  final String email;
  final String cpf;
  final String status;
  final String telefone;
  final bool ativo;

  ProfessorResponseDto({
    required this.id,
    required this.nome,
    required this.cref,
    required this.email,
    required this.cpf,
    required this.status,
    required this.telefone,
    required this.ativo,
  });

  factory ProfessorResponseDto.fromJson(Map<String, dynamic> json) {
    return ProfessorResponseDto(
      id: json['id'] as int,
      nome: json['nome'] as String,
      cref: json['cref'] as String,
      email: json['email'] as String,
      cpf: json['cpf'] as String,
      status: json['status'] as String,
      telefone: json['telefone'] as String,
      ativo: json['ativo'] as bool? ?? true,
    );
  }
}
