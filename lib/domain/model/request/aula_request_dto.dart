class AulaRequestDto {
  final String nome;
  final int professorId;
  final String descricao;
  final int capacidade;
  final int duracaoMinutos;
  final List<String> diasSemana;
  final String horario;

  AulaRequestDto({
    required this.nome,
    required this.professorId,
    required this.descricao,
    required this.capacidade,
    required this.duracaoMinutos,
    required this.diasSemana,
    required this.horario,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'professorId': professorId,
      'descricao': descricao,
      'capacidade': capacidade,
      'duracaoMinutos': duracaoMinutos,
      'diasSemana': diasSemana,
      'horario': horario,
    };
  }
}
