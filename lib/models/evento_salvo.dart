class EventoSalvo {
  final String id;
  final String titulo;
  final String local;
  final DateTime salvoEm;
  final String observacao;

  const EventoSalvo({
    required this.id,
    required this.titulo,
    required this.local,
    required this.salvoEm,
    required this.observacao,
  });

  EventoSalvo copyWith({String? observacao}) {
    return EventoSalvo(
      id: id,
      titulo: titulo,
      local: local,
      salvoEm: salvoEm,
      observacao: observacao ?? this.observacao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'local': local,
      'salvoEm': salvoEm.toIso8601String(),
      'observacao': observacao,
    };
  }

  factory EventoSalvo.fromMap(Map<String, dynamic> map) {
    return EventoSalvo(
      id: map['id'] as String,
      titulo: map['titulo'] as String,
      local: map['local'] as String,
      salvoEm: DateTime.parse(map['salvoEm'] as String),
      observacao: map['observacao'] as String? ?? '',
    );
  }
}
