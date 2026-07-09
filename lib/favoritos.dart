// Armazenamento local dos livros favoritos usando shared_preferences.
// Salvamos a lista de favoritos como uma string JSON, que persiste entre execucoes.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'livro.dart';

class Favoritos {
  static const _chave = 'livros_favoritos';

  // Le a lista de favoritos salva no dispositivo.
  static Future<List<Livro>> listar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_chave);

    if (texto == null || texto.isEmpty) return [];

    final lista = jsonDecode(texto) as List<dynamic>;
    return lista
        .map((item) => Livro.fromFavorito(item as Map<String, dynamic>))
        .toList();
  }

  // Salva a lista completa no dispositivo.
  static Future<void> _salvarLista(List<Livro> livros) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = jsonEncode(livros.map((l) => l.toJson()).toList());
    await prefs.setString(_chave, texto);
  }

  // Verifica se um livro ja esta nos favoritos.
  static Future<bool> ehFavorito(String chave) async {
    final favoritos = await listar();
    return favoritos.any((l) => l.chave == chave);
  }

  // Adiciona um livro aos favoritos (se ainda nao existir).
  static Future<void> adicionar(Livro livro) async {
    final favoritos = await listar();
    if (favoritos.any((l) => l.chave == livro.chave)) return;
    favoritos.add(livro);
    await _salvarLista(favoritos);
  }

  // Remove um livro dos favoritos.
  static Future<void> remover(String chave) async {
    final favoritos = await listar();
    favoritos.removeWhere((l) => l.chave == chave);
    await _salvarLista(favoritos);
  }
}
