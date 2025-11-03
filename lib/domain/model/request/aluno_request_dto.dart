class AlunoRequestDto {
  final String nome;
  final String matricula;
  final String plano;
  final String status;
  final String email;
  final String cpf;
  final String dataNascimento;
  final String telefone;

  AlunoRequestDto({
    required this.nome,
    required this.matricula,
    required this.plano,
    required this.status,
    required this.email,
    required this.cpf,
    required this.dataNascimento,
    required this.telefone,
  });

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'matricula': matricula,
    'plano': plano,
    'status': status,
    'email': email,
    'cpf': cpf,
    'dataNascimento': dataNascimento,
    'telefone': telefone,
  };
}
