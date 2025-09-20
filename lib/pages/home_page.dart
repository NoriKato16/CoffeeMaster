import 'package:flutter/material.dart';
import 'detail.dart';
import 'newCoffee.dart';
import 'goodPractice.dart';
import 'about.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _color = Colors.cyanAccent;

  void _setColor() {
    setState(() {
      if (_color != Colors.green) {
        _color = Colors.green;
      } else {
        _color = Colors.red;
      }
    });
  }

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
              child: Text("Menú",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
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
          ],
        ),
      ),

      // 🔹 Home con cafeteras
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _coffeeCard(context, "Cafetera Italiana"),
          _coffeeCard(context, "AeroPress"),
          _coffeeCard(context, "Prensa Francesa"),
          _coffeeCard(context, "Nueva cafetera", isNew: true),
        ],
      ),
    );
  }

  //Widget para mostrar cada cafetera como tarjeta
  Widget _coffeeCard(BuildContext context, String name, {bool isNew = false}) {
    return GestureDetector(
      onTap: () {
        if (isNew) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewCoffeePage()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailPage(name: name)),
          );
        }
      },
      child: Card(
        color: isNew ? Colors.green[200] : Colors.brown[100],
        child: Center(
          child: Text(name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
