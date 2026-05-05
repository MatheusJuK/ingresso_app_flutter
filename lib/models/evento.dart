class Evento {
  final String id;
  final String titulo;
  final String descricao;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String status;
  final String local;
  final String organizadorId;
 
  Evento({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.status,
    required this.local,
    required this.organizadorId,
  });
}
 