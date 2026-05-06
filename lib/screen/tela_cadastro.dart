import 'package:flutter/material.dart';
import '../data/dados_mock.dart';
import '../models/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorEmail.dispose();
    _controladorSenha.dispose();
    _controladorCpf.dispose();
    super.dispose();
  }

  void _realizarCadastro() {
    final nome = _controladorNome.text.trim();
    final email = _controladorEmail.text.trim();
    final senha = _controladorSenha.text.trim();

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      _mostrarMensagem('Preencha nome, email e senha.');
      return;
    }

    if (emailJaCadastrado(email)) {
      _mostrarMensagem('Este email já está cadastrado.');
      return;
    }

    setState(() => _carregando = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      final novoUsuario = Usuario(
        id: 'u${DateTime.now().millisecondsSinceEpoch}',
        nome: nome,
        email: email,
        senhaHash: senha,
        cpf: _controladorCpf.text.trim().isEmpty
            ? null
            : _controladorCpf.text.trim(),
        criadoEm: DateTime.now(),
        atualizadoEm: DateTime.now(),
      );

      cadastrarUsuario(novoUsuario);

      if (!mounted) return;
      setState(() => _carregando = false);

      _mostrarMensagem('Cadastro realizado! Faça login.');
      Navigator.pop(context);
    });
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> cadastrarUsuario(Usuario usuario) async {
    final url = Uri.parse('https://localhost:3100/api/auth/sign-up/email');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': usuario.nome,
        'email': usuario.email,
        'password': usuario.senhaHash,
        'cpf': usuario.cpf,
      }),
    );

    if (response.statusCode == 200) {
      print('Usuário cadastrado com sucesso!');
    } else {
      print('Erro ao cadastrar usuário: ${response.statusCode}');
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
