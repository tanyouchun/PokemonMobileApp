import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
        ),
      ),
      home: HomePage(),
    );
  }
}

class Pokemon {
  final String name;
  final String imageUrl;
  final String type;
  bool isFavorite;

  Pokemon({required this.name, required this.imageUrl, required this.type, this.isFavorite = false,});
}

List<Pokemon> pokemonList = [
  Pokemon(
    name: 'Pikachu ⚡',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
    type: 'Electric',
  ),
  Pokemon(
    name: 'Charmander 🔥',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png',
    type: 'Fire',
  ),
  Pokemon(
    name: 'Squirtle 💧',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png',
    type: 'Water',
  ),
  Pokemon(
    name: 'Bulbasaur 🌿',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
    type: 'Grass',
  ),
  Pokemon(
    name: 'Jigglypuff 🎤',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/39.png',
    type: 'Fairy',
  ),
  Pokemon(
    name: 'Meowth 💰',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/52.png',
    type: 'Normal',
  ),
  Pokemon(
    name: 'Psyduck 🤯',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/54.png',
    type: 'Water',
  ),
  Pokemon(
    name: 'Eevee ✨',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/133.png',
    type: 'Normal',
  ),
  Pokemon(
    name: 'Snorlax 😴',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/143.png',
    type: 'Normal',
  ),
  Pokemon(
    name: 'Togepi 🌟',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/175.png',
    type: 'Fairy',
  ),
  Pokemon(
    name: 'Piplup 🐧',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/393.png',
    type: 'Water',
  ),
  Pokemon(
    name: 'Torchic 🔥',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/255.png',
    type: 'Fire',
  ),
];


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  String selectedType = 'All';

  void toggleFavorite(Pokemon p) {
    setState(() {
      p.isFavorite = !p.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Pokemon> filtered = pokemonList.where((p) {
      final matchesName = p.name.toLowerCase().contains(searchQuery.toLowerCase());

      bool matchesType;
      if (selectedType == 'All') {
        matchesType = true;
      } else if (selectedType == 'Favourite') {
        matchesType = p.isFavorite;
      } else {
        matchesType = p.type == selectedType;
      }

      return matchesName && matchesType;
    }).toList();

     filtered.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return 0;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('🎉 Pokémon Fun!'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          AppSearchBar(onChanged: (val) => setState(() => searchQuery = val)),
          AppTypeFilter(
            selectedType: selectedType,
            onChanged: (val) => setState(() => selectedType = val),
          ),
          Expanded(child: PokemonGrid(pokemonList: filtered, onFavoriteToggle: toggleFavorite)),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Pokemon pokemon;

  const DetailPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pokemon.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(pokemon.imageUrl, height: 120),
            SizedBox(height: 16),
            Text(
              pokemon.name,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(
              'Type: ${pokemon.type}',
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}

class AppSearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const AppSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: '🔍 Search for your pokemon',
          filled: true,
          fillColor: Colors.pink.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class AppTypeFilter extends StatelessWidget {
  final String selectedType;
  final Function(String) onChanged;

  final List<String> types = [
  'All',
  'Favourite',
  'Electric',
  'Fire',
  'Water',
  'Grass',
  'Fairy',
  'Normal'
];

  AppTypeFilter({super.key, required this.selectedType, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: DropdownButtonFormField<String>(
        value: selectedType,
        items: types.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
        onChanged: (val) => onChanged(val!),
        decoration: InputDecoration(
          labelText: '🎨 Choose Type',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class PokemonGrid extends StatelessWidget {
  final List<Pokemon> pokemonList;
  final Function(Pokemon) onFavoriteToggle;

  const PokemonGrid({super.key, required this.pokemonList, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8, 
      ),
      itemCount: pokemonList.length,
      itemBuilder: (context, index) {
       return PokemonCard(
          pokemon: pokemonList[index],
          onFavoriteToggle: () => onFavoriteToggle(pokemonList[index]),
       );
      },
    );
  }
}
class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback onFavoriteToggle;

  const PokemonCard({super.key, required this.pokemon, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailPage(pokemon: pokemon)),
      ),
      child: Card(
        color: Colors.amber.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    pokemon.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: onFavoriteToggle,
                ),
            ),
            Image.network(pokemon.imageUrl, height: 100),
            SizedBox(height: 4),
            Text(
              pokemon.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(pokemon.type),
          ],
        ),
      ),
    );
  }
}