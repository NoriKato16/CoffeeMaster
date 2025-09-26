import 'package:flutter/material.dart';

class AeroPressPage extends StatelessWidget {
  const AeroPressPage ({super.key});


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aero Press")),
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
              "1:15 ~ 1:17",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),

            Text(
              "Molienda:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "media fina",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),

            Text(
              "Instrucciones:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            Text(
              "Coloca el filtro en al aeropress y limpiarlo con agua para eliminar el sabor a papel"
              "colocar la cantidad deseada de café y verter la cantidad deseada de agua  "
              "quemaduras y poner a fuego bajo por aproximadamente entre 5 a 10 minutos."
              "revolver suavemente 5 veces, colocar el pistón y dejar reposar entre 2 y 3 minutos "
              "presionar el pistón hasta el fondo para extraer el café en taza\n\n ",
              style: TextStyle(fontSize: 16, height: 1.4),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      )
    );




  }

}