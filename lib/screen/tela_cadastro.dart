import 'package:flutter/material.dart';
import 'package:ingresso_app_flutter/core/api_client.dart';
import 'package:ingresso_app_flutter/services/auth_service.dart';
import '../models/usuario.dart';
import 'tela_principal.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _controladorNome = TextEditingController();
  final _controladorEmail = TextEditingController();
  final _controladorSenha = TextEditingController();
  final _controladorCpf = TextEditingController();
  bool _carregando = false;
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

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorEmail.dispose();
    _controladorSenha.dispose();
    _controladorCpf.dispose();
    super.dispose();
  }

  void _realizarCadastro() async {
    final nome = _controladorNome.text.trim();
    final email = _controladorEmail.text.trim();
    final senha = _controladorSenha.text.trim();
    final cpf = _controladorCpf.text.trim();

    if (nome.isEmpty || email.isEmpty || senha.isEmpty || cpf.isEmpty) {
      _mostrarMensagem('Preencha todos os campos.');
      return;
    }

    if (senha.length < 8) {
      _mostrarMensagem('A senha deve ter pelo menos 8 caracteres.');
      return;
    }

    setState(() => _carregando = true);

    try {
      // Faz o cadastro e navega direto para a tela principal
      final signUpResp = await _authService.signUp(
        cpf: cpf,
        name: nome,
        email: email,
        password: senha,
      );

      if (!mounted) return;
      setState(() => _carregando = false);

      final usuario = Usuario(
        id: signUpResp.user.id,
        nome: signUpResp.user.name,
        email: signUpResp.user.email,
        senhaHash: '',
        cpf: signUpResp.user.cpf,
        criadoEm: signUpResp.user.createdAt,
        atualizadoEm: signUpResp.user.updatedAt ?? signUpResp.user.createdAt,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TelaPrincipal(usuarioLogado: usuario),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      _mostrarMensagem(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _controladorNome,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Nome completo',
                prefixIcon: const Icon(Icons.person_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controladorCpf,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'CPF (opcional)',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _carregando ? null : _realizarCadastro,
                child: _carregando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Criar Conta', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Já tenho conta'),
            ),
          ],
        ),
      ),
    );
  }
}
