// lib/domain/model/response/aluno_response_dto.dart

class AlunoResponseDto {
  final int id;
  final String nome;
  final String matricula;
  final String plano;
  final String status;
  final String email;
  final String cpf;
  final String dataNascimento;
  final String telefone;
  final bool ativo; // NOVO: Adicionado ativo

  AlunoResponseDto({
    required this.id,
    required this.nome,
    required this.matricula,
    required this.plano,
    required this.status,
    required this.email,
    required this.cpf,
    required this.dataNascimento,
    required this.telefone,
    required this.ativo, // NOVO: Adicionado ao construtor
  });

  factory AlunoResponseDto.fromJson(Map<String, dynamic> json) {
    return AlunoResponseDto(
      id: json['id'] as int,
      nome: json['nome'] as String,
      matricula: json['matricula'] as String,
      plano: json['plano'] as String,
      status: json['status'] as String,
      email: json['email'] as String,
      cpf: json['cpf'] as String,
      dataNascimento: json['dataNascimento'] as String,
      telefone: json['telefone'] as String,
      // Assume 'ativo' se não estiver presente no JSON, mas tenta ler como bool
      ativo: json['ativo'] as bool? ?? (json['status'] == 'Ativo'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'matricula': matricula,
      'plano': plano,
      'status': status,
      'email': email,
      'cpf': cpf,
      'dataNascimento': dataNascimento,
      'telefone': telefone,
      'ativo': ativo,
    };
  }
}
