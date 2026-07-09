# App de Busca e Organizacao de Livros
 
Aplicativo mobile em Flutter para pesquisar livros por titulo, autor ou palavra-chave,
visualizar informacoes e salvar os favoritos localmente para consulta posterior.
 
## Curso
 
Análise e desenvolvimento de sistemas
 
## Unidade curricular
 
Desenvolvimento para dispositivos móveis
 
## Alunos
 
- Nome do Felipe Gabriel Schmitt
- Nome do Felipe Hlatki Vieira
- Nome do João Eduardo Matos
 
## O que foi utilizado (tecnico)
 
- **Flutter / Dart** - desenvolvimento do app.
- **http** - requisicoes a API publica.
- **Open Library API** - fonte dos dados dos livros (`https://openlibrary.org/search.json`).
- **shared_preferences** - armazenamento local dos favoritos (persistem entre execucoes).
- **Material Design 3** - interface (cards, icones, tema por cor semente).
 
### Organizacao dos arquivos (pasta `lib`)
 
- `main.dart` - ponto de entrada; navegacao entre as duas abas (Buscar e Favoritos).
- `livro.dart` - modelo do livro, com `fromJson` (API) e `toJson`/`fromFavorito` (favoritos).
- `api_livros.dart` - funcao que consulta a Open Library, com tratamento de erro e timeout.
- `favoritos.dart` - salva, lista e remove favoritos usando `shared_preferences`.
- `tela_busca.dart` - tela inicial de busca, com loading, erro e mensagens de vazio.
- `tela_detalhes.dart` - detalhes do livro e botao de favoritar/desfavoritar.
- `tela_favoritos.dart` - lista de favoritos, com opcao de remover.
 
## Funcionalidades
 
- Busca de livros por titulo, autor ou palavra-chave.
- Consulta a API publica (Open Library) exibindo capa, titulo, autor e ano.
- Tela de detalhes com informacoes adicionais.
- Favoritar e desfavoritar livros; visualizar a lista de favoritos.
- Remover livros dos favoritos.
- Indicador de carregamento (loading) durante as buscas.
- Mensagens de feedback para erro de rede, busca vazia e nenhum resultado.
- Botao para limpar/reiniciar a busca.
- Navegacao clara: busca -> detalhes -> favoritos.
- Favoritos persistem entre execucoes do app (armazenamento local).
 
## Como instalar e rodar
 
1. Instale o Flutter SDK.
2. Clone o repositorio.
3. Acesse a pasta do projeto.
4. Execute:
 
```bash
flutter pub get
flutter run
```
 
Se necessario, configure um emulador Android ou conecte um dispositivo fisico.
 
## Organizacao do trabalho em equipe
 
Cada integrante ficou responsavel por uma parte do projeto e abriu ao menos um
pull request. Exemplo de divisao:
 
- Aluno 1: estrutura inicial e navegacao (`main.dart`, `livro.dart`).
- Aluno 2: integracao com a API publica (`api_livros.dart`, `tela_busca.dart`).
- Aluno 3: armazenamento local, favoritos, tela de detalhes e README (`favoritos.dart`, `tela_favoritos.dart`, `tela_detalhes.dart`).