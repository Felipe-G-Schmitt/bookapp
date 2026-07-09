import 'package:flutter/material.dart';

import 'api_livros.dart';
import 'livro.dart';
import 'tela_detalhes.dart';

class TelaBusca extends StatefulWidget {
  const TelaBusca({super.key});

  @override
  State<TelaBusca> createState() => _TelaBuscaState();
}

class _TelaBuscaState extends State<TelaBusca> {
  final _controller = TextEditingController();

  bool _isLoading = false;
  String? _erro;
  List<Livro> _resultados = [];
  bool _jaBuscou = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    final termo = _controller.text.trim();

    if (termo.isEmpty) {
      setState(() => _erro = 'Digite um titulo, autor ou palavra-chave.');
      return;
    }

    setState(() {
      _isLoading = true;
      _erro = null;
      _resultados = [];
      _jaBuscou = true;
    });

    try {
      final resultado = await buscarLivros(termo);
      setState(() => _resultados = resultado);
    } catch (e) {
      setState(() => _erro = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _limpar() {
    setState(() {
      _controller.clear();
      _resultados = [];
      _erro = null;
      _jaBuscou = false;
    });
  }

  void _aoTocarLivro(Livro livro) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TelaDetalhes(livro: livro)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Livros'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _limpar,
            tooltip: 'Limpar busca',
          ),
        ],
      ),
      body: Column(
        children: [
          // Campo de busca.
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Titulo, autor ou palavra-chave',
                    hintText: 'Ex: Machado de Assis',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (_) => _buscar(),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _buscar,
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),

          Expanded(child: _construirResultados()),
        ],
      ),
    );
  }

  Widget _construirResultados() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                _erro!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _buscar,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_jaBuscou) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Digite algo acima e toque em Buscar para encontrar livros.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    if (_resultados.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Nenhum livro encontrado. Tente outra busca.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: _resultados.length,
      itemBuilder: (context, index) {
        final livro = _resultados[index];
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
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _aoTocarLivro(livro),
          ),
        );
      },
    );
  }
}
