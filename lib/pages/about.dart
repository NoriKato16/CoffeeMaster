import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de la aplicación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Coffee Master',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            Text(
              'Nombre del desarrollador:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Noriyuki Kato',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'Descripción de la aplicación:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Coffee Master es una aplicación creada para ayudar a baristas y entusiastas del café a conocer las diferentes formas de preparar café con distintas cafeteras. '
              'La aplicación permite visualizar información detallada de cada método, añadir cafeteras favoritas y compartir conocimientos con otros usuarios.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),

            Text(
              'Versión:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '1.0.0',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'Tecnologías utilizadas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '- Flutter\n- Dart\n- Visual Studio Code\n- GitHub',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
