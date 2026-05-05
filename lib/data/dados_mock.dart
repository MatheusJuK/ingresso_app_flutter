import '../models/usuario.dart';
import '../models/evento.dart';
import '../models/tipo_ingresso.dart';
import '../models/pedido.dart';
import '../models/ingresso.dart';
 
final List<Usuario> usuariosMock = [
  Usuario(
    id: 'u1',
    nome: 'João Silva',
    email: 'joao@email.com',
    senhaHash: '123456',
    cpf: '123.456.789-00',
    criadoEm: DateTime(2024, 1, 10),
    atualizadoEm: DateTime(2024, 1, 10),
  ),
  Usuario(
    id: 'u2',
    nome: 'Maria Souza',
    email: 'maria@email.com',
    senhaHash: '123456',
    criadoEm: DateTime(2024, 2, 5),
    atualizadoEm: DateTime(2024, 2, 5),
  ),
];
 
final List<Evento> eventosMock = [
  Evento(
    id: 'e1',
    titulo: 'Show de Rock Nacional',
    descricao: 'Uma noite incrível com as melhores bandas de rock do Brasil. Venha curtir muito rock and roll com toda a família!',
    dataInicio: DateTime(2025, 8, 15, 20, 0),
    dataFim: DateTime(2025, 8, 15, 23, 59),
    status: 'ATIVO',
    local: 'Espaço das Américas, São Paulo - SP',
    organizadorId: 'u1',
  ),
  Evento(
    id: 'e2',
    titulo: 'Festival de Jazz',
    descricao: 'O melhor festival de jazz da região, com artistas nacionais e internacionais se apresentando em dois palcos simultâneos.',
    dataInicio: DateTime(2025, 9, 5, 18, 0),
    dataFim: DateTime(2025, 9, 7, 22, 0),
    status: 'ATIVO',
    local: 'Parque Ibirapuera, São Paulo - SP',
    organizadorId: 'u1',
  ),
  Evento(
    id: 'e3',
    titulo: 'Festa Junina 2025',
    descricao: 'A tradicional festa junina com muita comida típica, quadrilha, forró ao vivo e sorteio de prêmios!',
    dataInicio: DateTime(2025, 6, 21, 17, 0),
    dataFim: DateTime(2025, 6, 21, 23, 0),
    status: 'ATIVO',
    local: 'Centro de Convenções, Teresina - PI',
    organizadorId: 'u2',
  ),
  Evento(
    id: 'e4',
    titulo: 'Peça Teatral: O Fantasma',
    descricao: 'Uma premiada peça de teatro que traz emoção, suspense e muito talento ao palco. Baseada no clássico da literatura mundial.',
    dataInicio: DateTime(2025, 7, 10, 20, 0),
    dataFim: DateTime(2025, 7, 10, 22, 30),
    status: 'ATIVO',
    local: 'Teatro Municipal, Rio de Janeiro - RJ',
    organizadorId: 'u2',
  ),
];
 
final List<TipoIngresso> tiposIngressoMock = [
  TipoIngresso(
    id: 'ti1',
    eventoId: 'e1',
    nome: 'Pista',
    preco: 80.00,
    quantidadeTotal: 500,
    quantidadeVendida: 120,
    inicioVenda: DateTime(2025, 5, 1),
    fimVenda: DateTime(2025, 8, 14),
    ativo: true,
  ),
  TipoIngresso(
    id: 'ti2',
    eventoId: 'e1',
    nome: 'VIP',
    preco: 180.00,
    quantidadeTotal: 100,
    quantidadeVendida: 45,
    inicioVenda: DateTime(2025, 5, 1),
    fimVenda: DateTime(2025, 8, 14),
    ativo: true,
  ),
  TipoIngresso(
    id: 'ti3',
    eventoId: 'e2',
    nome: 'Entrada Geral',
    preco: 60.00,
    quantidadeTotal: 1000,
    quantidadeVendida: 300,
    inicioVenda: DateTime(2025, 6, 1),
    fimVenda: DateTime(2025, 9, 4),
    ativo: true,
  ),
  TipoIngresso(
    id: 'ti4',
    eventoId: 'e2',
    nome: 'Camarote',
    preco: 250.00,
    quantidadeTotal: 50,
    quantidadeVendida: 10,
    inicioVenda: DateTime(2025, 6, 1),
    fimVenda: DateTime(2025, 9, 4),
    ativo: true,
  ),
  TipoIngresso(
    id: 'ti5',
    eventoId: 'e3',
    nome: 'Adulto',
    preco: 30.00,
    quantidadeTotal: 300,
    quantidadeVendida: 80,
    inicioVenda: DateTime(2025, 5, 15),
    fimVenda: DateTime(2025, 6, 20),
    ativo: true,
  ),
  TipoIngresso(
    id: 'ti6',
    eventoId: 'e3',
    nome: 'Criança (até 12 anos)',
    preco: 15.00,
    quantidadeTotal: 200,
    quantidadeVendida: 40,
    inicioVenda: DateTime(2025, 5, 15),
    fimVenda: DateTime(2025, 6, 20),
    ativo: true,
  ),
  TipoIngresso(
    id: 'ti7',
    eventoId: 'e4',
    nome: 'Plateia',
    preco: 120.00,
    quantidadeTotal: 200,
    quantidadeVendida: 150,
    inicioVenda: DateTime(2025, 5, 1),
    fimVenda: DateTime(2025, 7, 9),
    ativo: true,
  ),
  TipoIngresso(
    id: 'ti8',
    eventoId: 'e4',
    nome: 'Frisa',
    preco: 200.00,
    quantidadeTotal: 50,
    quantidadeVendida: 20,
    inicioVenda: DateTime(2025, 5, 1),
    fimVenda: DateTime(2025, 7, 9),
    ativo: true,
  ),
];
 
List<Pedido> pedidosMock = [];
 
List<Ingresso> ingressosMock = [];
 
List<TipoIngresso> buscarTiposIngressoPorEvento(String eventoId) {
  return tiposIngressoMock.where((t) => t.eventoId == eventoId).toList();
}
 
Evento? buscarEventoPorId(String eventoId) {
  try {
    return eventosMock.firstWhere((e) => e.id == eventoId);
  } catch (_) {
    return null;
  }
}
 
List<Pedido> buscarPedidosPorUsuario(String usuarioId) {
  return pedidosMock.where((p) => p.usuarioId == usuarioId).toList();
}
 
List<Ingresso> buscarIngressosPorUsuario(String usuarioId) {
  return ingressosMock.where((i) => i.usuarioId == usuarioId).toList();
}
 
Usuario? autenticarUsuario(String email, String senha) {
  try {
    return usuariosMock.firstWhere(
      (u) => u.email == email && u.senhaHash == senha,
    );
  } catch (_) {
    return null;
  }
}
 
bool emailJaCadastrado(String email) {
  return usuariosMock.any((u) => u.email == email);
}
 
void cadastrarUsuario(Usuario novoUsuario) {
  usuariosMock.add(novoUsuario);
}