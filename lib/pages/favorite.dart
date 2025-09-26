import 'package:flutter/material.dart';
import 'coffee_favorite.dart';

class FavoritesPage extends StatelessWidget {
  final List<CoffeeFavorite> favorites;

  const FavoritesPage({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favoritos")),
      body: favorites.isEmpty
          ? const Center(child: Text("No tienes favoritos aún"))
          : GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(8),
              childAspectRatio: 0.8,
              children: favorites
                  .map(
                    (c) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => c.page),
                        );
                      },
                      child: Column(
                        children: [
                          Card(
                            margin: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            elevation: 4,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child:
                                  Image.asset(c.imagePath, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            c.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}