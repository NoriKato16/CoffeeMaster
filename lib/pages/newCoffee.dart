import 'package:flutter/material.dart';

class NewCoffeePage extends StatelessWidget {
  const NewCoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Cafetera")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: "Nombre de la cafetera"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Cafetera guardada")),
                );
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
