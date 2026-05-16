class Ingresso {
  final String id;
  final String pedidoId;
  final String eventoId;
  final String usuarioId;
  final String codigoQr;
  final String status;
  final DateTime? utilizadoEm;

  Ingresso({
    required this.id,
    required this.pedidoId,
    required this.eventoId,
    required this.usuarioId,
    required this.codigoQr,
    required this.status,
    this.utilizadoEm,
  });

  factory Ingresso.fromJson(Map<String, dynamic> json) {
    return Ingresso(
      id: json['id'] as String,
      pedidoId:
          json['pedidoId'] as String? ??
          json['orderId'] as String? ??
          json['pedido_id'] as String? ??
          json['order_id'] as String? ??
          '',
      eventoId:
          json['eventoId'] as String? ??
          json['eventId'] as String? ??
          json['evento_id'] as String? ??
          json['event_id'] as String? ??
          '',
      usuarioId:
          json['usuarioId'] as String? ??
          json['userId'] as String? ??
          json['usuario_id'] as String? ??
          json['user_id'] as String? ??
          '',
      codigoQr:
          json['codigoQr'] as String? ??
          json['codigo'] as String? ??
          json['codigo_qr'] as String? ??
          json['qr_code'] as String? ??
          '',
      status: json['status'] as String? ?? 'VALIDO',
      utilizadoEm: json['utilizadoEm'] != null
          ? DateTime.tryParse(json['utilizadoEm'] as String)
          : json['utilizado_em'] != null
          ? DateTime.tryParse(json['utilizado_em'] as String)
          : null,
    );
  }
}
