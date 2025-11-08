import 'package:flutter/material.dart';
import 'about_survey_page.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de la aplicación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Coffee Master', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            const Text('Nombre del desarrollador:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Noriyuki Kato', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            const Text('Descripción de la aplicación:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text(
              'Coffee Master es una aplicación creada para ayudar a baristas y entusiastas del café a conocer las diferentes formas de preparar café con distintas cafeteras. '
              'La aplicación permite visualizar información detallada de cada método, añadir cafeteras favoritas y compartir conocimientos con otros usuarios.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),

            const Text('Versión:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('1.2.0', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            const Text('Tecnologías utilizadas:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('- Flutter\n- Dart\n- Visual Studio Code\n- GitHub', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutSurveyPage()),
                );
              },
              icon: const Icon(Icons.assignment_outlined),
              label: const Text('Responder cuestionario'),
            ),
          ],
        ),
      ),
    );
  }
}
