import 'package:flutter/material.dart';
import 'package:ingresso_app_flutter/core/api_client.dart';
import 'package:ingresso_app_flutter/models/usuario.dart';
import 'package:ingresso_app_flutter/services/auth_service.dart';
import 'tela_cadastro.dart';
import 'tela_principal.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _controladorEmail = TextEditingController();
  final _controladorSenha = TextEditingController();
  bool _carregando = false;
  bool _mostrarSenha = false;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _inicializarServicos();
  }

  Future<void> _inicializarServicos() async {
    final apiClient = await ApiClient.create();
    _authService = AuthService(apiClient);
  }

  @override
  void dispose() {
    _controladorEmail.dispose();
    _controladorSenha.dispose();
    super.dispose();
  }

  void _realizarLogin() async {
    final email = _controladorEmail.text.trim();
    final senha = _controladorSenha.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      _mostrarMensagem('Preencha todos os campos.');
      return;
    }

    setState(() => _carregando = true);

    try {
      final response = await _authService.signIn(email: email, password: senha);

      if (!mounted) return;
      setState(() => _carregando = false);

      // Converte UserData para Usuario
      final usuario = Usuario(
        id: response.user.id,
        cpf: response.user.cpf,
        nome: response.user.name,
        email: response.user.email,
        senhaHash: '',
        criadoEm: response.user.createdAt,
        atualizadoEm: response.user.updatedAt ?? response.user.createdAt,
      );

      _navegarParaPrincipal(usuario);
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      _mostrarMensagem(e.toString());
    }
  }

  void _navegarParaPrincipal(Usuario usuario) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => TelaPrincipal(usuarioLogado: usuario)),
    );
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.confirmation_number,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Ingressos App',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Faça login para continuar',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _controladorEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controladorSenha,
                  obscureText: !_mostrarSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _mostrarSenha ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _mostrarSenha = !_mostrarSenha),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: _carregando ? null : _realizarLogin,
                    child: _carregando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Entrar', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TelaCadastro()),
                    );
                  },
                  child: const Text('Não tem conta? Cadastre-se'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
