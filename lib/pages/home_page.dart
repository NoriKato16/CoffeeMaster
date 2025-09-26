import 'package:flutter/material.dart';
import 'newCoffee.dart';
import 'goodPractice.dart';
import 'about.dart';
import 'cItaliana.dart';
import 'cAeroPress.dart';
import 'cPrensaFrancesa.dart';
import 'favorite.dart';
import 'coffee_favorite.dart';
import 'custom_coffee.dart';
import 'coffee_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ✅ Inicializamos listas desde el inicio
  List<CoffeeFavorite> favorites = [];
  List<CustomCoffee> customCoffees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      // Drawer
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.brown),
              child: Text(
                "Menú",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              title: const Text("Buenas prácticas"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GoodPracticesPage()),
                );
              },
            ),
            ListTile(
              title: const Text("Acerca de"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AboutScreen()),
                );
              },
            ),
            ListTile(
              title: const Text("Favoritos"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FavoritesPage(favorites: favorites),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // Home con cafeteras
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
        childAspectRatio: 0.8,
        children: [
          _coffeeCard(context, "Cafetera Italiana", "assets/CafeteraMoka.jpg",
              ItalianaPage()),
          _coffeeCard(
              context, "AeroPress", "assets/AeroPress.jpg", AeroPressPage()),
          _coffeeCard(context, "Prensa Francesa", "assets/PrensaFrancesa.jpg",
              PrensaFrancesaPage()),

          // ✅ Cafeteras agregadas por el usuario (si hay)
          ...(customCoffees.isNotEmpty
              ? customCoffees.map(
                  (c) => _coffeeCard(
                    context,
                    c.name,
                    c.imagePath,
                    CoffeeDetailPage(
                      name: c.name,
                      ratio: c.ratio,
                      molienda: c.molienda,
                      descripcion: c.descripcion,
                      imagePath: c.imagePath,
                    ),
                  ),
                )
              : []),
        ],
      ),

      // Botón de nueva cafetera
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        tooltip: "Nueva cafetera",
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final newCoffee = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewCoffeePage()),
          );

          // ✅ Validar null antes de usar
          if (newCoffee != null && newCoffee is CustomCoffee) {
            setState(() {
              customCoffees.add(newCoffee);
            });
          }
        },
      ),
    );
  }

  // Widget para mostrar cada cafetera como tarjeta
  Widget _coffeeCard(
    BuildContext context,
    String name,
    String imagePath,
    Widget page, {
    bool isNew = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isNew) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
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
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),
              // Botón de favorito
              Positioned(
                right: 12,
                top: 12,
                child: IconButton(
                  icon: Icon(
                    favorites.any((c) => c.name == name)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      if (favorites.any((c) => c.name == name)) {
                        favorites.removeWhere((c) => c.name == name);
                      } else {
                        favorites.add(CoffeeFavorite(name, imagePath, page));
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}