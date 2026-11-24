# BibliotecaBooks Mobile

Aplicativo mobile desenvolvido em Flutter e Dart, integrado à API REST em Spring Boot, para gestão de acervo, usuários e empréstimos de uma biblioteca.

## Estrutura do Projeto

O código-fonte está organizado na pasta `lib/` da seguinte forma:

```text
lib/
├── core/               # Modelos compartilhados, tema, rotas, formatadores e controle de idioma
├── l10n/               # Arquivos de internacionalização (Português, Inglês e Espanhol)
├── modules/
│   ├── auth/           # Telas e serviços de login e recuperação de senha
│   ├── admin/          # Dashboard, CRUDs de editoras, livros, usuários e empréstimos
│   └── user/           # Dashboard pessoal, visualização/edição de perfil e alteração de senha
└── main.dart           # Ponto de entrada, configuração de rotas e locale
```

## Funcionalidades Implementadas

### Autenticação e Controle de Acesso
- **Login e Redirecionamento:** Autenticação via token JWT armazenado localmente (`SharedPreferences`), direcionando o usuário para o fluxo de Administrador ou Locatário conforme seu perfil.
- **Recuperação de Senha:** Fluxo de solicitação e redefinição de senha na tela de acesso.
- **Logout:** Encerramento de sessão com limpeza do token local e retorno à tela de login.
- **Controle de Permissões:** Separação de rotas e menus por perfil no aplicativo, validada em conjunto com as regras de segurança da API.
- **Internacionalização:** Suporte a Português, Inglês e Espanhol com troca de idioma em tempo real e persistência local.

### Área do Administrador
- **Dashboard:** Indicadores gerais (total de livros, empréstimos ativos e empréstimos no mês) e listagem de atrasos críticos.
- **Editoras:** Listagem em cards com paginação, busca, ordenação (`A-Z`, `Z-A`, `Mais recente`), cadastro, edição e exclusão.
- **Livros:** Listagem em cards com paginação, busca, ordenação, vínculo com editoras, controle de quantidade total/em uso, cadastro, edição e exclusão.
- **Usuários:** Listagem em cards com busca, ordenação e ativação/inativação de contas.
- **Empréstimos:** Listagem em cards com busca e ordenação, registro de novo empréstimo (filtrando usuários ativos e livros com saldo disponível), renovação de prazo e registro de devolução.

### Área do Locatário
- **Dashboard Pessoal:** Resumo de empréstimos ativos, quantidade de atrasos e total de retiradas devolvidas.
- **Meus Livros:** Listagem dos livros em posse do usuário com data de empréstimo, prazo de devolução e indicador de dias em atraso.
- **Perfil:** Visualização dos dados cadastrais, edição de informações pessoais (`PATCH /users/me`) e alteração de senha (`PATCH /users/me/password`), sem acesso às rotas administrativas.

### Validações e Tratamento de Erros
- Validação de campos obrigatórios, formatos de e-mail, datas e quantidades antes do envio à API.
- Diálogos de confirmação para ações destrutivas ou irreversíveis (exclusão de registros e devolução de livros).
- Feedbacks visuais para estados de carregamento, listas vazias, operações concluídas e mensagens de erro retornadas pelo servidor ou falhas de conexão/timeout.

## Pré-requisitos

- Flutter SDK (versão 3.x ou superior)
- Dart SDK
- Android Studio ou VS Code com emulador Android configurado (ou dispositivo físico com depuração USB ativada)
- API Backend (`BibliotecaBooks`) em execução

## Configuração e Execução

1. Clone o repositório e acesse a branch da entrega:
   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd <PASTA_DO_PROJETO>
   git checkout <BRANCH_DA_ENTREGA>
   ```

2. Instale as dependências do projeto:
   ```bash
   flutter pub get
   ```

3. Gere os arquivos de internacionalização:
   ```bash
   flutter gen-l10n
   ```

4. Verifique o endereço base da API nos arquivos de serviço (`lib/modules/**/services/*.dart`):
   - Para **emulador Android**, utilize `http://10.0.2.2:8080`.
   - Para **dispositivo físico**, substitua pelo IP local da máquina onde o backend está rodando na mesma rede Wi-Fi (ex.: `http://192.168.x.x:8080`).

5. Execute o aplicativo:
   ```bash
   flutter run
   ```

## Geração do APK (Android)

Para gerar o arquivo de instalação APK em modo release:

```bash
flutter build apk --release
```

Após a conclusão do build, o arquivo estará disponível em:

```text
build/app/outputs/flutter-apk/app-release.apk
```