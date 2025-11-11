import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'newCoffee.dart';
import 'goodPractice.dart';
import 'about.dart';
import 'favorite.dart';
import 'coffee_favorite.dart';
import 'custom_coffee.dart';
import 'coffee_detail_page.dart';
import 'preferences_page.dart';
import 'reminders_page.dart';
import 'recipes_page.dart';
import '../data/database.dart';
import '../services/SharedPreferencesService.dart' as sp;
import '../services/machines_service.dart';
import 'machine_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _prefs = sp.SharedPreferencesService();

  List<CoffeeFavorite> favorites = [];

  @override
  void initState() {
    super.initState();
  }

 
  Future<Map<String, Object>> _loadHome() async {
    final orderRecent = await _prefs.orderByRecent();

    
    final machines = (await MachinesRepo.all())
        .map((m) => Map<String, Object?>.from(m))
        .toList();

    if (orderRecent) {
      for (final m in machines) {
        final id = (m['id'] ?? '').toString(); 
        m['usage'] = await _prefs.getUsageCount(id);
      }
      machines.sort((a, b) =>
          ((b['usage'] as int?) ?? 0).compareTo(((a['usage'] as int?) ?? 0)));
    } else {
      machines.sort((a, b) => (a['nombre'] as String)
          .toLowerCase()
          .compareTo((b['nombre'] as String).toLowerCase()));
    }


    final rows = await AppDb.instance.getAllMakers();
    final customs = rows
        .map((m) => CustomCoffee(
              name: (m['name'] ?? '') as String,
              ratio: (m['ratio'] ?? '') as String,
              molienda: (m['molienda'] ?? '') as String,
              descripcion: (m['descripcion'] ?? '') as String,
              imagePath: (m['imagePath'] ?? 'assets/default.jpg') as String,
            ))
        .toList();

    if (orderRecent) {
    
      final usages = <int>[];
      for (var i = 0; i < customs.length; i++) {
        final id = 'user_${1000 + i}';
        usages.add(await _prefs.getUsageCount(id));
      }
      customs.sort((a, b) {
        final ia = customs.indexOf(a);
        final ib = customs.indexOf(b);
        return usages[ib].compareTo(usages[ia]);
      });
    } else {
      customs.sort((a, b) =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }

    return {'machines': machines, 'customs': customs};
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
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PreferencesPage()),
              );
              if (mounted) setState(() {}); // recargar orden
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.brown),
              child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              title: const Text('Recetas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RecipesPage()));
              },
            ),
            ListTile(
              title: const Text('Buenas prácticas'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GoodPracticesPage()));
              },
            ),
            ListTile(
              title: const Text('Favoritos'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => FavoritesPage(favorites: favorites)));
              },
            ),
            ListTile(
              title: const Text('Recordatorios'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RemindersPage()));
              },
            ),
            ListTile(
              title: const Text('Preferencias'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const PreferencesPage()));
                if (mounted) setState(() {}); // recargar orden
              },
            ),
            ListTile(
              title: const Text('Acerca de'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
              },
            ),
          ],
        ),
      ),

      body: FutureBuilder<Map<String, Object>>(
        future: _loadHome(),
        builder: (ctx, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final machines = (snap.data!['machines'] as List).cast<Map<String, Object?>>();
          final customs  = (snap.data!['customs']  as List).cast<CustomCoffee>();

          final children = <Widget>[
            // Catálogo base
            ...machines.map((m) {
              final id    = (m['id'] ?? '').toString();
              final name  = (m['nombre'] ?? '').toString();
              final image = ((m['image'] ?? m['image_uri']) ?? 'assets/default.jpg').toString();
              return _coffeeCard(
                context,
                id: id,
                name: name,
                imagePath: image,
                page: MachineDetailPage(machine: m),
                onTapBeforeNavigate: () async {
                  await _prefs.bumpUsage(id);
                },
                shareText: _machineShareText(m),
              );
            }),

            // Custom del usuario
            ...customs.asMap().entries.map((e) {
              final idx = e.key;
              final c   = e.value;
              final customId = 'user_${1000 + idx}';
              final shareTxt = '''
              Cafetera: ${c.name}
              Ratio: ${c.ratio}
              Molienda: ${c.molienda}

              ${c.descripcion}
              ''';
              return _coffeeCard(
                context,
                id: customId,
                name: c.name,
                imagePath: c.imagePath,
                page: CoffeeDetailPage(
                  name: c.name,
                  ratio: c.ratio,
                  molienda: c.molienda,
                  descripcion: c.descripcion,
                  imagePath: c.imagePath,
                ),
                onTapBeforeNavigate: () async {
                  await _prefs.bumpUsage(customId);
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        tooltip: 'Nueva cafetera',
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final newCoffee = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewCoffeePage()),
          );

          if (newCoffee != null && newCoffee is CustomCoffee) {
            await AppDb.instance.insertMaker({
              'name': newCoffee.name,
              'ratio': newCoffee.ratio,
              'molienda': newCoffee.molienda,
              'descripcion': newCoffee.descripcion,
              'imagePath': newCoffee.imagePath,
            });
            if (mounted) setState(() {}); // recargar lista
          }
        },
      ),
    );
  }



  Widget _coffeeCard(
    BuildContext context, {
    required String id,
    required String name,
    required String imagePath,
    required Widget page,
    bool isNew = false,
    Future<void> Function()? onTapBeforeNavigate,
    String? shareText,
    String? shareFilePath,
  }) {
    return GestureDetector(
      onTap: () async {
        if (isNew) return;
        if (onTapBeforeNavigate != null) await onTapBeforeNavigate();
        if (mounted) setState(() {}); // actualizar orden por uso
        await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        if (mounted) setState(() {}); // refrescar al volver
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Card(
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                clipBehavior: Clip.antiAlias,
                elevation: 4,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _buildImage(imagePath),
                ),
              ),
              // Favoritos
              Positioned(
                right: 12,
                top: 12,
                child: IconButton(
                  icon: Icon(
                    favorites.any((c) => c.name == name)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.brown,
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
              // Compartir
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
          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _machineShareText(Map<String, Object?> m) {
    final pasos = ((m['pasos'] as List?)?.cast<String>() ?? const []);
    return [
      'Cafetera: ${m['nombre']}',
      if ((m['ratio_hint'] ?? '').toString().isNotEmpty)
        'Ratio sugerido: ${m['ratio_hint']}',
      if ((m['molienda'] ?? '').toString().isNotEmpty)
        'Molienda: ${m['molienda']}',
      'Cómo usarla:',
      ...pasos.map((p) => '• $p'),
    ].join('\n');
  }

  Widget _buildImage(String path) {
    if (_isAsset(path)) {
      return Image.asset(path, fit: BoxFit.cover);
    }
    // archivo del sistema
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black12),
    );
  }

  bool _isAsset(String p) => p.startsWith('assets/');
}
