class EventoResponse {
  final String id;
  final String titulo;
  final String descricao;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String status;
  final String local;
  final UsuarioResponse organizador;

  EventoResponse({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.status,
    required this.local,
    required this.organizador,
  });

  factory EventoResponse.fromJson(Map<String, dynamic> json) {
    return EventoResponse(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String,
      dataInicio: DateTime.parse(json['dataInicio'] as String),
      dataFim: DateTime.parse(json['dataFim'] as String),
      status: json['status'] as String,
      local: json['local'] as String,
      organizador: UsuarioResponse.fromJson(
        json['organizador'] as Map<String, dynamic>,
      ),
    );
  }
}

class UsuarioResponse {
  final String id;
  final String cpf;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UsuarioResponse({
    required this.id,
    required this.cpf,
    required this.name,
    required this.email,
    required this.createdAt,
    this.updatedAt,
  });

  factory UsuarioResponse.fromJson(Map<String, dynamic> json) {
    return UsuarioResponse(
      id: json['id'] as String,
      cpf: json['cpf'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
}

class TipoIngressoResponse {
  final String id;
  final String eventoId;
  final String nome;
  final int preco;
  final int quantidadeTotal;
  final int quantidadeVendida;
  final DateTime inicioVenda;
  final DateTime fimVenda;
  final bool ativo;

  TipoIngressoResponse({
    required this.id,
    required this.eventoId,
    required this.nome,
    required this.preco,
    required this.quantidadeTotal,
    required this.quantidadeVendida,
    required this.inicioVenda,
    required this.fimVenda,
    required this.ativo,
  });

  factory TipoIngressoResponse.fromJson(Map<String, dynamic> json) {
    return TipoIngressoResponse(
      id: json['id'] as String,
      eventoId: json['eventoId'] as String,
      nome: json['nome'] as String,
      preco: json['preco'] as int,
      quantidadeTotal: json['quantidadeTotal'] as int,
      quantidadeVendida: json['quantidadeVendida'] as int,
      inicioVenda: DateTime.parse(json['inicioVenda'] as String),
      fimVenda: DateTime.parse(json['fimVenda'] as String),
      ativo: json['ativo'] as bool,
    );
  }

  int get quantidadeDisponivel => quantidadeTotal - quantidadeVendida;
}

class PedidoResponse {
  final String id;
  final String userId;
  final int quantidadeTotal;
  final String status;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  PedidoResponse({
    required this.id,
    required this.userId,
    required this.quantidadeTotal,
    required this.status,
    required this.criadoEm,
    required this.atualizadoEm,
  });

  factory PedidoResponse.fromJson(Map<String, dynamic> json) {
    return PedidoResponse(
      id: json['id'] as String,
      userId: json['userId'] as String,
      quantidadeTotal: json['quantidadeTotal'] as int,
      status: json['status'] as String,
      criadoEm: DateTime.parse(json['criadoEm'] as String),
      atualizadoEm: DateTime.parse(json['atualizadoEm'] as String),
    );
  }
}
