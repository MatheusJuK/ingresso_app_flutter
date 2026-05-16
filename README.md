# Ingressos App Flutter

Aplicativo mobile em Flutter para venda de ingressos de eventos. O app consome uma API REST propria, permite cadastro/login, listagem de eventos, selecao de ingressos, carrinho, pedidos, ingressos do usuario, tema claro/escuro e eventos salvos localmente com CRUD em `SharedPreferences`.

## Pre-requisitos

- Flutter SDK instalado e configurado no `PATH`.
- Android Studio instalado.
- Android SDK configurado pelo Android Studio.
- Emulador Android criado pelo Device Manager do Android Studio.
- API do projeto rodando localmente ou em uma URL acessivel.

## Como preparar o emulador no Android Studio

1. Abra o Android Studio.
2. Acesse **More Actions > Device Manager**.
3. Crie ou selecione um emulador Android.
4. Inicie o emulador antes de rodar o app.
5. Confirme no terminal se o dispositivo aparece:

```bash
flutter devices
```

## Configuracao do projeto

1. Clone ou baixe o repositorio.
2. Entre na pasta do projeto:

```bash
cd ingresso_app_flutter
```

3. Instale as dependencias:

```bash
flutter pub get
```

4. Crie o arquivo `.env` na raiz do projeto usando o `.env.example` como base:

```env
API_BASE_URL=http://10.0.2.2:3100
```

No emulador Android, `10.0.2.2` aponta para o `localhost` da maquina. Se a API estiver em outra URL, substitua o valor de `API_BASE_URL`.

## Como rodar

Com o emulador aberto no Android Studio e a API rodando:

```bash
flutter run
```

Tambem e possivel abrir a pasta no Android Studio e executar pelo botao **Run**, selecionando o emulador Android como dispositivo.

## Como gerar APK debug

```bash
flutter build apk --debug
```

O arquivo gerado fica em:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## Verificacoes uteis

Rodar analise estatica:

```bash
flutter analyze
```

Limpar build, se necessario:

```bash
flutter clean
flutter pub get
```

## Funcionalidades implementadas

- Interface responsiva com Material 3, tema claro/escuro e componentes reutilizaveis.
- Formulario de cadastro com validacao de nome, e-mail, senha, CPF e checkbox.
- Navegacao por rotas nomeadas com passagem de dados.
- Consumo de API REST com `Dio`, loading, tratamento de erro e listas assincronas.
- Armazenamento local com `SharedPreferences` para tema e eventos salvos.
- CRUD local demonstravel em **Perfil > Eventos Salvos**.
- Gerenciamento de estado com `StatefulWidget`, `StatelessWidget`, `setState` e `ValueNotifier`.
- Simulacao de publicacao com nome do app, pacote, icone e splash screen personalizados.
- Funcionalidade extra de animacoes e microinteracoes com `Hero`, `AnimatedSwitcher`, `AnimatedContainer` e `AnimatedScale`.

## Observacoes sobre a API

O app espera que a API esteja disponivel no endereco definido em `API_BASE_URL`. Para uso no emulador Android com API local na porta `3100`, utilize:

```env
API_BASE_URL=http://10.0.2.2:3100
```

Não é recomendado o Debug em dispositivo físico devido a inconsistência no acesso a API por motivos que não achamos mesmo pesquisando extensivamente, mas
caso rode em dispositivo fisico, use o IP da maquina na rede, por exemplo:

```env
API_BASE_URL=http://192.168.0.10:3100
```
