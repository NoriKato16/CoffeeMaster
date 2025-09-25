import 'package:flutter/material.dart';

class ItalianaPage extends StatelessWidget {
  const ItalianaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cafetera Italiana")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            
            //Image.asset("assets/italiana.png", height: 200, fit: BoxFit.cover),
            SizedBox(height: 10),

            Text(
              "Ratio:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "1:7 ~ 1:10",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),

            Text(
              "Molienda:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Fina – media fina",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),

            Text(
              "Instrucciones:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            Text(
              "Opción A): Colocar el café hasta el borde del canastillo, llenar con agua caliente el recipiente "
              "inferior sin cubrir la válvula de presión, cerrar la cafetera con un paño para evitar "
              "quemaduras y poner a fuego bajo por aproximadamente entre 5 a 10 minutos."
              "Cuando el café deje de subir y empiece a sonar como burbujea, retirar rápidamente. "
              "Recomendable pasar el recipiente interior por agua fría para cortar la ebullición "
              "y tu café quedaría listo para servir.\n\n",
              style: TextStyle(fontSize: 16, height: 1.4),
              textAlign: TextAlign.justify,
            ),
             Text(
              "Opción B): Colocar el café hasta el borde del canastillo, hacerle un agujero al medio del cafe con una cucharita, llenar con agua fría el recipiente "
              "inferior sin cubrir la válvula de presión, cerrar la cafetera  y poner a fuego alto por aproximadamente entre 5 a 10 minutos."
              "Cuando el café deje de subir y empiece a sonar como burbujea, retirar rápidamente. "
              "Recomendable pasar el recipiente interior por agua fría para cortar la ebullición "
              "y el café quedaría listo para servir.",
              style: TextStyle(fontSize: 16, height: 1.4),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
