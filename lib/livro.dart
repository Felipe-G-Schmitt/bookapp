class Livro {
  final String chave;
  final String titulo;
  final String autor;
  final int? ano;
  final int? capaId;

  Livro({
    required this.chave,
    required this.titulo,
    required this.autor,
    this.ano,
    this.capaId,
  });

  String? get urlCapa {
    if (capaId == null) return null;
    return 'https://covers.openlibrary.org/b/id/$capaId-M.jpg';
  }

  factory Livro.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    return {
      'key': chave,
      'title': titulo,
      'author': autor,
      'year': ano,
      'cover_i': capaId,
    };
  }

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
