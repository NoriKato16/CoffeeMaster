import 'package:flutter/material.dart';

class PrensaFrancesaPage extends StatelessWidget {
  const PrensaFrancesaPage ({super.key});


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prensa Francesa")),
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
              "1:12 ~ 1:18",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),

            Text(
              "Molienda:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Gruesa",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),

            Text(
              "Instrucciones:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            Text(
              "c.	Verter la cantidad deseada de café en el fondo la prensa  "
              "verter agua caliente en la cantidad deseada buscando humedecer toda la cama de café"
              "tapar la prensa y dejar reposar entre 4 y 5 minutos"
              "con una cuchara romper la costra de café que se formó en la superficie, luego bajar el embolo hasta el fondo y servir\n\n "
              "Recomendación Adicional: tras 4 minutos de preparación romper la costra de café, retirar la espuma y granos que estén flotando "
              "volver a tapar y dejar reposar por 5 minutos, luego bajar el embolo hasta justo la superficie del agua para no levantar sedimentos y servir\n\n",
              style: TextStyle(fontSize: 16, height: 1.4),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      )
    );




  }

}