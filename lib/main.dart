// App de Busca e Organizacao de Livros (Open Library API).
//
// Versao completa: a aba "Buscar" consulta a API e a aba "Favoritos"
// mostra os livros salvos localmente. A navegacao para detalhes acontece
// a partir das duas telas.

import 'package:flutter/material.dart';

import 'tela_busca.dart';
import 'tela_favoritos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Livros',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Usamos uma Key na tela de favoritos para forcar o recarregamento
  // sempre que o usuario voltar para essa aba (assim um livro favoritado
  // na busca ja aparece na lista).
  Key _favoritosKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final paginas = [
      const TelaBusca(),
      TelaFavoritos(key: _favoritosKey),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: paginas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // Ao entrar na aba de favoritos, recriamos a tela para recarregar a lista.
            if (index == 1) _favoritosKey = UniqueKey();
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
