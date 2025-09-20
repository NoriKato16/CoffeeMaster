import 'package:flutter/material.dart';

class GoodPracticesPage extends StatelessWidget {
  const GoodPracticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buenas Prácticas")),
      body: ListView(
        children: const [
          ListTile(title: Text("Usa café recién molido.")),
          ListTile(title: Text("Limpia la cafetera después de cada uso.")),
          ListTile(title: Text("Utiliza agua filtrada.")),
        ],
      ),
    );
  }
}
