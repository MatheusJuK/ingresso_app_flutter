import 'package:flutter/material.dart';
import 'package:ingresso_app_flutter/core/api_client.dart';
import 'package:ingresso_app_flutter/routes/app_routes.dart';
import 'package:ingresso_app_flutter/services/auth_service.dart';
import '../models/usuario.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _controladorNome = TextEditingController();
  final _controladorEmail = TextEditingController();
  final _controladorSenha = TextEditingController();
  final _controladorCpf = TextEditingController();
  bool _carregando = false;
  bool _receberNovidades = false;
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

  void _navegarParaPrincipal(Usuario usuario) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.principal,
      arguments: PrincipalRouteArgs(usuarioLogado: usuario),
    );
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
    if (!(_formKey.currentState?.validate() ?? false)) {
      _mostrarMensagem('Revise os campos destacados.');
      return;
    }

    final nome = _controladorNome.text.trim();
    final email = _controladorEmail.text.trim();
    final senha = _controladorSenha.text.trim();
    final cpf = _controladorCpf.text.trim();

    setState(() => _carregando = true);

    try {
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

      _navegarParaPrincipal(usuario);
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      _mostrarMensagem(e.toString());
    }
  }

  String? _validarNome(String? valor) {
    final nome = valor?.trim() ?? '';

    if (nome.isEmpty) return 'Informe seu nome completo.';
    if (nome.length < 3) return 'O nome deve ter pelo menos 3 caracteres.';

    return null;
  }

  String? _validarEmail(String? valor) {
    final email = valor?.trim() ?? '';
    final emailValido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    if (email.isEmpty) return 'Informe seu e-mail.';
    if (!emailValido) return 'Informe um e-mail válido.';

    return null;
  }

  String? _validarSenha(String? valor) {
    final senha = valor?.trim() ?? '';

    if (senha.isEmpty) return 'Informe uma senha.';
    if (senha.length < 8) return 'A senha deve ter pelo menos 8 caracteres.';

    return null;
  }

  String? _validarCpf(String? valor) {
    final cpf = valor?.replaceAll(RegExp(r'\D'), '') ?? '';

    if (cpf.isEmpty) return 'Informe seu CPF.';
    if (cpf.length != 11) return 'O CPF deve ter 11 dígitos.';

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _controladorNome,
                textCapitalization: TextCapitalization.words,
                validator: _validarNome,
                decoration: InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: const Icon(Icons.person_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controladorEmail,
                keyboardType: TextInputType.emailAddress,
                validator: _validarEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controladorSenha,
                obscureText: true,
                validator: _validarSenha,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controladorCpf,
                keyboardType: TextInputType.number,
                validator: _validarCpf,
                decoration: InputDecoration(
                  labelText: 'CPF',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                value: _receberNovidades,
                onChanged: (valor) {
                  setState(() => _receberNovidades = valor ?? false);
                },
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Receber novidades sobre eventos'),
              ),
              const SizedBox(height: 20),
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
                      : const Text(
                          'Criar Conta',
                          style: TextStyle(fontSize: 16),
                        ),
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
      ),
    );
  }
}
