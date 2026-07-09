import 'package:flutter/material.dart';

import 'favoritos.dart';
import 'livro.dart';

class TelaDetalhes extends StatefulWidget {
  final Livro livro;

  const TelaDetalhes({super.key, required this.livro});

  @override
  State<TelaDetalhes> createState() => _TelaDetalhesState();
}

class _TelaDetalhesState extends State<TelaDetalhes> {
  bool _ehFavorito = false;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _verificarFavorito();
  }

  Future<void> _verificarFavorito() async {
    final resultado = await Favoritos.ehFavorito(widget.livro.chave);
    setState(() {
      _ehFavorito = resultado;
      _carregando = false;
    });
  }

  Future<void> _alternarFavorito() async {
    if (_ehFavorito) {
      await Favoritos.remover(widget.livro.chave);
    } else {
      await Favoritos.adicionar(widget.livro);
    }

    setState(() => _ehFavorito = !_ehFavorito);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _ehFavorito
              ? 'Livro adicionado aos favoritos.'
              : 'Livro removido dos favoritos.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final livro = widget.livro;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 240,
              child: livro.urlCapa != null
                  ? Image.network(
                      livro.urlCapa!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.menu_book,
                        size: 120,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(Icons.menu_book, size: 120, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Text(
              livro.titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            _CampoInfo(icone: Icons.person, label: 'Autor', valor: livro.autor),
            _CampoInfo(
              icone: Icons.calendar_today,
              label: 'Ano de publicacao',
              valor: livro.ano?.toString() ?? 'Nao informado',
            ),
            _CampoInfo(
              icone: Icons.vpn_key,
              label: 'Identificador',
              valor: livro.chave,
            ),
            const SizedBox(height: 24),

            _carregando
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _alternarFavorito,
                    icon: Icon(
                      _ehFavorito ? Icons.favorite : Icons.favorite_border,
                    ),
                    label: Text(
                      _ehFavorito
                          ? 'Remover dos favoritos'
                          : 'Adicionar aos favoritos',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _ehFavorito ? Colors.red.shade100 : null,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _CampoInfo extends StatelessWidget {
  final IconData icone;
  final String label;
  final String valor;

  const _CampoInfo({
    required this.icone,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(valor, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
