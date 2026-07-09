import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'livro.dart';

Future<List<Livro>> buscarLivros(String termo) async {
  final uri = Uri.https('openlibrary.org', '/search.json', {
    'q': termo,
    'limit': '20',
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
