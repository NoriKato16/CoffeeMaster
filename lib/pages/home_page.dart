import 'package:flutter/material.dart';

import 'dart:io';
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
import 'preferences_page.dart';
import 'reminders_page.dart';
import 'recipes_page.dart';
import '../data/database.dart';
import '../services/SharedPreferencesService.dart' as sp;
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _prefs = sp.SharedPreferencesService();

  List<CoffeeFavorite> favorites = [];
  List<CustomCoffee> customCoffees = [];

  // Cafeteras base
  final List<Map<String, Object?>> _builtIns = [
    {
      'id': 1,
      'name': 'Cafetera Italiana',
      'image': 'assets/CafeteraMoka.jpg',
      'page': ItalianaPage(),
    },
    {
      'id': 2,
      'name': 'AeroPress',
      'image': 'assets/AeroPress.jpg',
      'page': AeroPressPage(),
    },
    {
      'id': 3,
      'name': 'Prensa Francesa',
      'image': 'assets/PrensaFrancesa.jpg',
      'page': PrensaFrancesaPage(),
    },
  ];
  Widget _buildImage(String path) {
    if (_isAsset(path)) return Image.asset(path, fit: BoxFit.cover);
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        // si NO es asset, intenta como archivo
        return Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black12),
        );
      },
    );
  }

  bool _isAsset(String p) => p.startsWith('assets/');

  Future<List<Map<String, Object?>>> _rankedBuiltIns() async {
    final list = [..._builtIns];
    for (final m in list) {
      final id = m['id'] as int;
      final usage = await _prefs.getUsageCount('$id'); // usage_1, usage_2, ...
      m['usage'] = usage;
    }
    list.sort(
      (a, b) =>
          ((b['usage'] as int?) ?? 0).compareTo(((a['usage'] as int?) ?? 0)),
    );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PreferencesPage()),
              );
            },
          ),
        ],
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
              title: const Text("Recetas"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecipesPage()),
                );
              },
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
            ListTile(
              title: const Text("Recordatorios"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RemindersPage()),
                );
              },
            ),
            ListTile(
              title: const Text("Preferencias"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PreferencesPage()),
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
          ],
        ),
      ),

      // Home con cafeteras ordenadas por uso
      body: FutureBuilder<List<Map<String, Object?>>>(
        future: _rankedBuiltIns(),
        builder: (ctx, snap) {
          final ranked = snap.data ?? _builtIns;

          final children = <Widget>[
            // base ordenadas por uso
            ...ranked.map(
              (m) => _coffeeCard(
                context,
                m['id'] as int,
                m['name'] as String,
                m['image'] as String,
                m['page'] as Widget,
                onTapBeforeNavigate: () async {
                  await _prefs.bumpUsage('${m['id']}');
                  await _prefs.setLastMakerId(m['id'] as int);
                },
                shareText: 'Cafetera: ${m['name']}',
              ),
            ),
            // cafeteras agregadas por el usuario
            ...customCoffees.asMap().entries.map((e) {
              final idx = e.key;
              final c = e.value;
              final customId = 1000 + idx; // ID
              final shareTxt =
                  '''
                Cafetera: ${c.name}
                Ratio: ${c.ratio}
                Molienda: ${c.molienda}

                ${c.descripcion}
                 ''';
              return _coffeeCard(
                context,
                customId,
                c.name,
                c.imagePath,
                CoffeeDetailPage(
                  name: c.name,
                  ratio: c.ratio,
                  molienda: c.molienda,
                  descripcion: c.descripcion,
                  imagePath: c.imagePath,
                ),
                onTapBeforeNavigate: () async {
                  await _prefs.bumpUsage('$customId');
                  await _prefs.setLastMakerId(customId);
                },
                shareText: shareTxt,
                shareFilePath: c.imagePath,
              );
            }),
          ];

          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(8),
            childAspectRatio: 0.8,
            children: children,
          );
        },
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

          if (newCoffee != null && newCoffee is CustomCoffee) {
            setState(() {
              customCoffees.add(newCoffee);
            });
          }
        },
      ),
    );
  }

  // Tarjeta de cafetera
  Widget _coffeeCard(
    BuildContext context,
    int id,
    String name,
    String imagePath,
    Widget page, {
    bool isNew = false,
    Future<void> Function()? onTapBeforeNavigate,
    String? shareText,
    String? shareFilePath,
  }) {
    return GestureDetector(
      onTap: () async {
        if (isNew) return;
        if (onTapBeforeNavigate != null) await onTapBeforeNavigate();

        // Refresca AHORA para reordenar
        if (mounted) setState(() {});

        await Navigator.push(context, MaterialPageRoute(builder: (_) => page));

        // Y refresca al volver también
        if (mounted) setState(() {});
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
                  child: _buildImage(imagePath), // ver helper abajo
                ),
              ),
              // Fav a la derecha
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
              // Compartir a la izquierda
              Positioned(
                left: 12,
                top: 12,
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    final txt = (shareText ?? 'Cafetera: $name').trim();
                    if (shareFilePath != null && !_isAsset(shareFilePath!)) {
                      Share.shareXFiles([XFile(shareFilePath!)], text: txt);
                    } else {
                      Share.share(txt);
                    }
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
