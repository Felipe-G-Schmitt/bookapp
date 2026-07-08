// Comunicacao com a API publica Open Library.
// Segue o mesmo padrao de tratamento de erro do exemplo (timeout, statusCode, etc).

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'livro.dart';

// Busca livros por titulo, autor ou palavra-chave.
Future<List<Livro>> buscarLivros(String termo) async {
  // A Open Library retorna varios resultados; limitamos a 20 para ficar rapido.
  final uri = Uri.https('openlibrary.org', '/search.json', {
    'q': termo,
    'limit': '20',
    // Pedimos apenas os campos que usamos, deixando a resposta mais leve.
    'fields': 'key,title,author_name,first_publish_year,cover_i',
  });

  http.Response response;

  try {
    response = await http.get(uri).timeout(const Duration(seconds: 10));
  } on TimeoutException {
    throw Exception('Tempo limite excedido. Verifique sua conexao.');
  } catch (e) {
    throw Exception('Sem conexao com a internet.');
  }

  if (response.statusCode != 200) {
    throw Exception('Erro do servidor: ${response.statusCode}');
  }

  final json = jsonDecode(response.body) as Map<String, dynamic>;
  final docs = json['docs'] as List<dynamic>? ?? [];

  return docs
      .map((item) => Livro.fromJson(item as Map<String, dynamic>))
      .toList();
}
