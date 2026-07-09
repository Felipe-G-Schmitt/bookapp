// Tela que lista os livros favoritados e permite remove-los.

import 'package:flutter/material.dart';

import 'favoritos.dart';
import 'livro.dart';
import 'tela_detalhes.dart';

class TelaFavoritos extends StatefulWidget {
  const TelaFavoritos({super.key});

  @override
  State<TelaFavoritos> createState() => _TelaFavoritosState();
}

class _TelaFavoritosState extends State<TelaFavoritos> {
  List<Livro> _favoritos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    final lista = await Favoritos.listar();
    setState(() {
      _favoritos = lista;
      _carregando = false;
    });
  }

  Future<void> _remover(Livro livro) async {
    await Favoritos.remover(livro.chave);
    await _carregar();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Livro removido dos favoritos.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _abrirDetalhes(Livro livro) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TelaDetalhes(livro: livro)),
    );
    // Ao voltar da tela de detalhes, recarrega (o usuario pode ter desfavoritado la).
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregar,
            tooltip: 'Recarregar',
          ),
        ],
      ),
      body: _construirCorpo(),
    );
  }

  Widget _construirCorpo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_favoritos.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_border, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Voce ainda nao tem livros favoritos.\nBusque um livro e toque no coracao.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: _favoritos.length,
      itemBuilder: (context, index) {
        final livro = _favoritos[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: SizedBox(
              width: 40,
              child: livro.urlCapa != null
                  ? Image.network(
                      livro.urlCapa!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.menu_book, color: Colors.grey),
                    )
                  : const Icon(Icons.menu_book, color: Colors.grey),
            ),
            title: Text(livro.titulo),
            subtitle: Text(
              '${livro.autor}${livro.ano != null ? ' - ${livro.ano}' : ''}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _remover(livro),
              tooltip: 'Remover',
            ),
            onTap: () => _abrirDetalhes(livro),
          ),
        );
      },
    );
  }
}
