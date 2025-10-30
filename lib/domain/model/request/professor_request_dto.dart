class ProfessorRequestDto {
  final String nome;
  final String cref;
  final String email;
  final String cpf;
  final String status;
  final String telefone;

  ProfessorRequestDto({
    required this.nome,
    required this.cref,
    required this.email,
    required this.cpf,
    required this.status,
    required this.telefone,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cref': cref,
      'email': email,
      'cpf': cpf,
      'status': status,
      'telefone': telefone,
    };
  }
}
