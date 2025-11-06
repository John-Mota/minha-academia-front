import 'package:minha_academia_front/domain/model/response/professor_response_dto.dart';

class AulaResponseDto {
  final int id;
  final String nome;
  final ProfessorResponseDto professor;
  final String descricao;
  final int capacidade;
  final int vagasOcupadas;
  final int duracaoMinutos;
  final List<String> diasSemana;
  final String horario;
  final bool ativo;

  AulaResponseDto({
    required this.id,
    required this.nome,
    required this.professor,
    required this.descricao,
    required this.capacidade,
    required this.vagasOcupadas,
    required this.duracaoMinutos,
    required this.diasSemana,
    required this.horario,
    required this.ativo,
  });

  factory AulaResponseDto.fromJson(
    Map<String, dynamic> json,
    ProfessorResponseDto professor,
  ) {
    return AulaResponseDto(
      id: json['id'],
      nome: json['nome'],
      professor: professor,
      descricao: json['descricao'],
      capacidade: json['capacidade'],
      vagasOcupadas: json['vagasOcupadas'],
      duracaoMinutos: json['duracaoMinutos'],
      diasSemana: List<String>.from(json['diasSemana']),
      horario: json['horario'],
      ativo: json['ativo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'professor': professor.nome,
      'duracaoMinutos': '$duracaoMinutos min',
      'vagas': '$vagasOcupadas / $capacidade',
    };
  }
}
