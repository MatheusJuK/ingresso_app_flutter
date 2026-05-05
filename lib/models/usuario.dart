class Usuario {
  final String id;
  final String nome;
  final String email;
  final String senhaHash;
  final String? cpf;
  final String cargo;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
 
  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senhaHash,
    this.cpf,
    this.cargo = 'cliente',
    required this.criadoEm,
    required this.atualizadoEm,
  });
}
 