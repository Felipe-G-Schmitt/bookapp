// Modelo que representa um livro.
// Segue o padrao do exemplo da aula (Endereco/Post): construtor + factory fromJson.
// Tambem tem toJson/fromFavorito, que serao usados na parte de favoritos.

class Livro {
  final String chave; // identificador unico da Open Library (ex: /works/OL45804W)
  final String titulo;
  final String autor;
  final int? ano;
  final int? capaId; // id da imagem de capa (pode ser nulo)

  Livro({
    required this.chave,
    required this.titulo,
    required this.autor,
    this.ano,
    this.capaId,
  });

  // URL da capa. Se nao houver capaId, retorna null.
  String? get urlCapa {
    if (capaId == null) return null;
    return 'https://covers.openlibrary.org/b/id/$capaId-M.jpg';
  }

  // Cria um Livro a partir de um item da busca da Open Library.
  factory Livro.fromJson(Map<String, dynamic> json) {
    // O campo author_name vem como uma lista. Pegamos o primeiro nome.
    final autores = json['author_name'] as List<dynamic>?;
    final nomeAutor = (autores != null && autores.isNotEmpty)
        ? autores.first as String
        : 'Autor desconhecido';

    return Livro(
      chave: json['key'] as String? ?? '',
      titulo: json['title'] as String? ?? 'Sem titulo',
      autor: nomeAutor,
      ano: json['first_publish_year'] as int?,
      capaId: json['cover_i'] as int?,
    );
  }

  // Converte o Livro em um mapa (usado para salvar nos favoritos).
  Map<String, dynamic> toJson() {
    return {
      'key': chave,
      'title': titulo,
      'author': autor,
      'year': ano,
      'cover_i': capaId,
    };
  }

  // Recria um Livro a partir do mapa salvo nos favoritos.
  factory Livro.fromFavorito(Map<String, dynamic> json) {
    return Livro(
      chave: json['key'] as String? ?? '',
      titulo: json['title'] as String? ?? 'Sem titulo',
      autor: json['author'] as String? ?? 'Autor desconhecido',
      ano: json['year'] as int?,
      capaId: json['cover_i'] as int?,
    );
  }
}
