import 'package:flutter/material.dart';
import 'custom_coffee.dart';

class NewCoffeePage extends StatefulWidget {
  const NewCoffeePage({super.key});

  @override
  State<NewCoffeePage> createState() => _NewCoffeePageState();
}

class _NewCoffeePageState extends State<NewCoffeePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ratioController = TextEditingController();
  final _moliendaController = TextEditingController();
  final _descController = TextEditingController();
  final _imageController = TextEditingController(text: "assets/default.jpg");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Cafetera")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (v) => v!.isEmpty ? "Ingresa un nombre" : null,
              ),
              TextFormField(
                controller: _ratioController,
                decoration: const InputDecoration(labelText: "Ratio"),
              ),
              TextFormField(
                controller: _moliendaController,
                decoration: const InputDecoration(labelText: "Molienda"),
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Descripción"),
                maxLines: 3,
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: "Ruta de imagen (asset)"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newCoffee = CustomCoffee(
                      name: _nameController.text,
                      ratio: _ratioController.text,
                      molienda: _moliendaController.text,
                      descripcion: _descController.text,
                      imagePath: _imageController.text,
                    );
                    Navigator.pop(context, newCoffee);
                  }
                },
                child: const Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}