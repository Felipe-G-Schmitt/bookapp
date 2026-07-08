// App de Busca e Organizacao de Livros (Open Library API).
// PARTE 1 - Estrutura inicial e navegacao.
//
// Nesta parte montamos apenas o esqueleto do app: o MaterialApp e a
// navegacao por abas (BottomNavigationBar), seguindo o exemplo da aula.
// As telas reais (busca e favoritos) serao adicionadas nas proximas partes.
// Por enquanto usamos telas provisorias (placeholders).

import 'package:flutter/material.dart';

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
    _PlaceholderBusca(),
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
// Telas provisorias (placeholders).
// Serao substituidas pelas telas reais nas proximas partes do trabalho.
// -------------------------------------------------------------------

class _PlaceholderBusca extends StatelessWidget {
  const _PlaceholderBusca();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Livros'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Tela de busca (em desenvolvimento).',
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
