# Como usar o ApiClient com Dio e sessão por cookies

Este projeto centraliza as chamadas HTTP em `lib/core/api_client.dart`. A ideia é que telas, widgets e serviços de domínio não criem `Dio` diretamente: todo acesso à API deve passar pelo `ApiClient`.

## Configuração do ambiente

Crie um arquivo `.env` na raiz do projeto com a URL base da API:

```env
API_BASEURL=http://localhost:3100
```

Em produção, use a URL pública da API:

```env
API_BASEURL=https://api.seu-dominio.com
```

O nome da variável precisa ser exatamente `API_BASEURL`, porque o `ApiClient` lê essa chave usando `flutter_dotenv`.

## Inicialização no app

Antes de carregar o `.env` ou criar o `ApiClient`, inicialize os bindings do Flutter:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final apiClient = await ApiClient.create();

  runApp(
    Provider<ApiClient>.value(
      value: apiClient,
      child: const MainApp(),
    ),
  );
}
```

O `ApiClient.create()` é assíncrono porque ele depende de `path_provider` para descobrir onde persistir os cookies da sessão.

## Como consumir em services ou repositories

Services e repositories devem receber o `ApiClient` por injeção de dependência. Eles não devem importar `Dio`, criar `Dio()` nem usar o pacote `http`.

Exemplo:

```dart
class ShowsRepository {
  ShowsRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Show>> listShows() async {
    final response = await _apiClient.get<List<dynamic>>('/shows');
    final data = response.data ?? [];

    return data
        .map((item) => Show.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
```

Em uma tela ou controller usando `provider`:

```dart
final apiClient = context.read<ApiClient>();
final repository = ShowsRepository(apiClient);
```

## Exemplo simples de service

Um service deve concentrar chamadas de uma área da API. Ele recebe o `ApiClient` no construtor e usa os métodos `get`, `post` e `clearSession`.

Exemplo de autenticação:

```dart
class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _apiClient.post('/login', data: {
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> me() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/me');
    return response.data ?? {};
  }

  Future<void> logout() async {
    await _apiClient.post('/logout');
    await _apiClient.clearSession();
  }
}
```

Exemplo de listagem:

```dart
class ShowsService {
  ShowsService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Show>> findAll() async {
    final response = await _apiClient.get<List<dynamic>>('/shows');
    final data = response.data ?? [];

    return data
        .map((item) => Show.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Show> findById(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/shows/$id');
    return Show.fromJson(response.data ?? {});
  }
}
```

## Exemplo simples de controller

Um controller pode cuidar de estado de tela, loading e erro. Ele não deve criar `Dio` nem ler `.env`; ele usa um service.

```dart
class AuthController extends ChangeNotifier {
  AuthController(this._authService);

  final AuthService _authService;

  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? user;

  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.login(email: email, password: password);
      user = await _authService.me();
    } catch (_) {
      errorMessage = 'Não foi possível entrar. Verifique seus dados.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    user = null;
    notifyListeners();
  }
}
```

## Exemplo de injeção com Provider

Depois que o `ApiClient` é criado no `main`, você pode disponibilizar services e controllers a partir dele:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final apiClient = await ApiClient.create();

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        Provider<AuthService>(
          create: (context) => AuthService(context.read<ApiClient>()),
        ),
        ChangeNotifierProvider<AuthController>(
          create: (context) => AuthController(context.read<AuthService>()),
        ),
      ],
      child: const MainApp(),
    ),
  );
}
```

Em uma tela:

```dart
class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return ElevatedButton(
      onPressed: authController.isLoading
          ? null
          : () {
              context.read<AuthController>().login(
                    'usuario@email.com',
                    'senha',
                  );
            },
      child: Text(authController.isLoading ? 'Entrando...' : 'Entrar'),
    );
  }
}
```

## Onde cada responsabilidade fica

- `ApiClient`: configura Dio, base URL, timeouts, cookies, interceptors e limpeza de sessão.
- `Service`: chama endpoints e transforma responses simples.
- `Repository`: opcional; útil quando precisar combinar API, cache local ou regras de dados.
- `Controller`: controla loading, erro, estado da tela e chama services.
- `Widget`: renderiza UI e dispara ações no controller.

## Sessão por cookies

O `ApiClient` usa:

- `PersistCookieJar` para persistir cookies entre aberturas do app.
- `CookieManager` para anexar cookies automaticamente nas requests e salvar cookies recebidos em responses.
- `clearSession()` para apagar cookies no logout ou quando a API retornar sessão inválida.

Fluxo esperado:

```dart
await apiClient.post('/login', data: {
  'email': email,
  'password': password,
});

final me = await apiClient.get<Map<String, dynamic>>('/me');

await apiClient.clearSession();
```

Não envie cookies manualmente em headers. O `CookieManager` já faz esse trabalho.

## Tratamento de erro 401

Quando a API retorna `401 Unauthorized`, o `ApiClient` limpa os cookies persistidos. Mesmo assim, a camada de autenticação do app ainda precisa reagir a esse erro para voltar o usuário ao estado deslogado.

Exemplo de responsabilidade fora do `ApiClient`:

```dart
try {
  await repository.loadPrivateData();
} on DioException catch (error) {
  if (error.response?.statusCode == 401) {
    authController.logoutLocally();
  }
}
```

O `ApiClient` cuida da infraestrutura HTTP; a decisão de navegação e estado de usuário deve ficar na camada de autenticação/UI state.

## Logs

O `LogInterceptor` deve ficar ativo apenas em debug. Logs com body de request/response podem conter dados pessoais, credenciais ou informações sensíveis. Em produção, não registre payloads completos.

## Regras arquiteturais

- Use `ApiClient` como única entrada HTTP.
- Não crie `Dio()` fora de `lib/core/api_client.dart`.
- Não use `package:http` para chamadas REST do app.
- Não leia `.env` em repositories, services ou widgets.
- Não manipule cookies manualmente em telas.
- Crie o `ApiClient` uma vez no bootstrap do app e injete a mesma instância.
- Para logout, chame `apiClient.clearSession()`.
- Para encerrar o cliente em testes ou teardown, chame `apiClient.close()`.

## Checklist de produção

- `API_BASEURL` configurada sem aspas extras no `.env`.
- `WidgetsFlutterBinding.ensureInitialized()` chamado antes de `dotenv.load`.
- `ApiClient` injetado no app, não apenas criado.
- `path_provider` declarado como dependência direta no `pubspec.yaml`.
- `package:http` removido se não houver uso real.
- Backend configurado para cookies compatíveis com mobile e produção.
- Cookies seguros em HTTPS usando atributos adequados no servidor.
- Fluxo de logout e expiração de sessão tratado pela camada de autenticação.
