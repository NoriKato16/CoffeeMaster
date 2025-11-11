import 'package:flutter/material.dart';

class GoodPracticesPage extends StatelessWidget {
  const GoodPracticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buenas Prácticas")),
      body: ListView(
        children: const [
          ListTile(
            title: Text("Muele el café justo antes de preparar."),
            subtitle: Text(
              "El café pierde rápidamente sus aceites aromáticos una vez molido. La molienda fresca garantiza el mejor sabor.",
            ),
          ),
          ListTile(
            title: Text(
              "Asegúrate de que la molienda sea correcta para tu cafetera.",
            ),
            subtitle: Text(
              "Usa molienda gruesa para Prensa Francesa, media para vertido (V60) y fina para Espresso o Moka. El tamaño incorrecto arruina la extracción.",
            ),
          ),
          ListTile(
            title: Text(
              "Utiliza agua filtrada o de botella de buena calidad.",
            ),
            subtitle: Text(
              "El 98 por ciento de tu café es agua. El agua de grifo puede contener cloro o un exceso de minerales que alteran el perfil de sabor.",
            ),
          ),
          ListTile(
            title: Text("Mide tu café y agua usando una báscula digital."),
            subtitle: Text(
              "La consistencia es vital. Mide el café y el agua en gramos para seguir el ratio exacto (por ejemplo, 1:15) y no por volumen.",
            ),
          ),
          ListTile(
            title: Text("Asegura la temperatura correcta del agua."),
            subtitle: Text(
              "La temperatura ideal para la mayoría de métodos es entre 90 y 96 grados. El agua debe estar caliente, no hirviendo, para evitar sabores quemados.",
            ),
          ),
          ListTile(
            title: Text(
              "Limpia a fondo la cafetera y todos sus componentes después de cada uso.",
            ),
            subtitle: Text(
              "Los aceites de café residuales se vuelven rancios rápidamente. Enjuagar solo con agua no es suficiente; límpiala para mantener el sabor de la siguiente taza.",
            ),
          ),
          ListTile(
            title: Text("Precalienta tu taza y tu equipo de preparación."),
            subtitle: Text(
              "Verter el café en una taza fría hace que pierda temperatura y sabor inmediatamente. Precalentar asegura la temperatura óptima de consumo.",
            ),
          ),
        ],
      ),
    );
  }
}
