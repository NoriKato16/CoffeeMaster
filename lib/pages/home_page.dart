import 'package:flutter/material.dart';
import 'detail.dart';
import 'newCoffee.dart';
import 'goodPractice.dart';
import 'about.dart';
import 'cItaliana.dart';
import 'cAeroPress.dart';
import 'cPrensaFrancesa.dart';


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
        padding: const EdgeInsets.all(8),
        childAspectRatio: 0.8,
        children: [
          _coffeeCard(context, "Cafetera Italiana", "assets/CafeteraMoka.jpg", ItalianaPage()),
          _coffeeCard(context, "AeroPress", "assets/AeroPress.jpg", AeroPressPage()),
          _coffeeCard(context, "Prensa Francesa", "assets/PrensaFrancesa.jpg", PrensaFrancesaPage()),
          _coffeeCard(context, "Nueva cafetera", "assets/logoCoffeeMaster.jpg", NewCoffeePage(), isNew: true),
        ],
      ),
    );
  }

  //Widget para mostrar cada cafetera como tarjeta
Widget _coffeeCard(BuildContext context, String name, String imagePath, Widget page,
    {bool isNew = false}) {
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
          MaterialPageRoute(builder: (_) => page),
        );
      }
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
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
