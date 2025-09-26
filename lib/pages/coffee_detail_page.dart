import 'package:flutter/material.dart';

class CoffeeDetailPage extends StatelessWidget {
  final String name;
  final String ratio;
  final String molienda;
  final String descripcion;
  final String imagePath;

  const CoffeeDetailPage({
    super.key,
    required this.name,
    required this.ratio,
    required this.molienda,
    required this.descripcion,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text("Ratio: $ratio",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Molienda: $molienda",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              descripcion,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}