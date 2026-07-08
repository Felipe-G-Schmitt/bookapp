// App de Busca e Organizacao de Livros (Open Library API).
// PARTE 2 - Integracao com a API publica.
//
// A aba "Buscar" agora usa a tela real (TelaBusca), que consulta a API.
// A aba "Favoritos" continua como placeholder ate a parte de armazenamento local.

import 'package:flutter/material.dart';

import 'tela_busca.dart';

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
  // Controla qual aba esta selecionada.
  int _currentIndex = 0;

  // Lista de telas exibidas em cada aba.
  // Usamos IndexedStack para manter o estado de cada aba ao alternar.
  final List<Widget> _paginas = const [
    TelaBusca(),
    _PlaceholderFavoritos(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _paginas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
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

// -------------------------------------------------------------------
// Tela provisoria de favoritos.
// Sera substituida pela tela real na parte de armazenamento local.
// -------------------------------------------------------------------

class _PlaceholderFavoritos extends StatelessWidget {
  const _PlaceholderFavoritos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_border, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Tela de favoritos (em desenvolvimento).',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
