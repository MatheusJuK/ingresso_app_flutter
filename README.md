# Ingressos App Flutter

Aplicativo mobile em Flutter para venda de ingressos de eventos. O app consome uma API REST própria, permite cadastro/login, listagem de eventos, seleção de ingressos, carrinho, pedidos, ingressos do usuário e preferências locais.

## Requisitos

- Flutter SDK instalado
- Dart SDK incluído no Flutter
- Emulador Android, dispositivo físico ou simulador iOS
- API do projeto rodando localmente ou em uma URL acessível

## Configuração

1. Instale as dependências:

```bash
flutter pub get
```

2. Crie o arquivo `.env` na raiz do projeto usando o `.env.example` como base:

```env
API_BASE_URL=http://10.0.2.2:3100
```

No emulador Android, `10.0.2.2` aponta para o `localhost` da máquina. Em dispositivo físico, use o IP da máquina na rede.

## Execução

```bash
flutter run
```

Para gerar um APK debug:

```bash
flutter build apk --debug
```

## Recursos implementados

- Interface responsiva com Material 3, tema claro/escuro e componentes reutilizáveis.
- Formulário de cadastro com validação de nome, e-mail, senha, CPF e checkbox.
- Navegação por rotas nomeadas com passagem de dados entre login, cadastro, principal e detalhe do evento.
- Consumo de API REST com `Dio`, loading, tratamento de erro e listas assíncronas.
- Armazenamento local com `SharedPreferences` para tema e eventos salvos com CRUD.
- Gerenciamento de estado com `StatefulWidget`, `StatelessWidget`, `setState` e `ValueNotifier`.
- Configuração de publicação com nome do app, pacote, ícone e splash screen personalizados.
