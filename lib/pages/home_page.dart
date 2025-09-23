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
        padding: const EdgeInsets.all(8),
        childAspectRatio: 0.8,
        children: [
          _coffeeCard(context, "Cafetera Italiana", "assets/CafeteraMoka.jpg"),
          _coffeeCard(context, "AeroPress", "assets/AeroPress.jpg"),
          _coffeeCard(context, "Prensa Francesa", "assets/PrensaFrancesa.jpg"),
          _coffeeCard(context, "Nueva cafetera", "assets/logoCoffeeMaster.jpg", isNew: true),
        ],
      ),
    );
  }

  //Widget para mostrar cada cafetera como tarjeta
 Widget _coffeeCard(BuildContext context, String name, String imagePath,
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
          MaterialPageRoute(builder: (_) => DetailPage(name: name)),
        );
      }
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Card con bordes redondeados + margen
        Card(
          margin: const EdgeInsets.all(8), // separación entre cards
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // bordes circulares
          ),
          clipBehavior: Clip.antiAlias, // recorta la imagen a la forma
          elevation: 4, // ligera sombra para resaltar
          child: AspectRatio(
            aspectRatio: 1, // cuadrada
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover, // la imagen llena el espacio
            ),
          ),
        ),
        const SizedBox(height: 5),
        // Nombre fuera de la card
        Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

}
