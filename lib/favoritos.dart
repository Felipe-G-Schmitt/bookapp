import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'livro.dart';

class Favoritos {
  static const _chave = 'livros_favoritos';

  static Future<List<Livro>> listar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_chave);

    if (texto == null || texto.isEmpty) return [];

    final lista = jsonDecode(texto) as List<dynamic>;
    return lista
        .map((item) => Livro.fromFavorito(item as Map<String, dynamic>))
        .toList();
  }

  static Future<void> _salvarLista(List<Livro> livros) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = jsonEncode(livros.map((l) => l.toJson()).toList());
    await prefs.setString(_chave, texto);
  }

  static Future<bool> ehFavorito(String chave) async {
    final favoritos = await listar();
    return favoritos.any((l) => l.chave == chave);
  }

  static Future<void> adicionar(Livro livro) async {
    final favoritos = await listar();
    if (favoritos.any((l) => l.chave == livro.chave)) return;
    favoritos.add(livro);
    await _salvarLista(favoritos);
  }

  static Future<void> remover(String chave) async {
    final favoritos = await listar();
    favoritos.removeWhere((l) => l.chave == chave);
    await _salvarLista(favoritos);
  }
}
