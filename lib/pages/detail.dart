import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String name;
  const DetailPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.coffee, size: 100, color: Colors.brown),
            Text("Detalles de $name"),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Añadido a favoritos")),
                );
              },
              child: const Text("Añadir a favoritos"),
            ),
          ],
        ),
      ),
    );
  }
}
