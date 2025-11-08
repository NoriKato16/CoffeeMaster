import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  void dispose() {
    _nameController.dispose();
    _ratioController.dispose();
    _moliendaController.dispose();
    _descController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  bool _isFilePath(String p) {
    if (p.startsWith('assets/')) return false;
    return File(p).existsSync();
  }

  Future<void> _takePhoto() async {
    final x = await ImagePicker().pickImage(source: ImageSource.camera);
    if (x == null) return;
    setState(() => _imageController.text = x.path);
  }

  Future<void> _pickFromGallery() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x == null) return;
    setState(() => _imageController.text = x.path);
  }

  @override
  Widget build(BuildContext context) {
    final img = _isFilePath(_imageController.text)
        ? Image.file(File(_imageController.text), fit: BoxFit.cover)
        : Image.asset(_imageController.text, fit: BoxFit.cover);

    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Cafetera")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Preview imagen
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ColoredBox(color: Colors.black12, child: img),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Tomar foto'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galería'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (v) =>
                    v!.trim().isEmpty ? "Ingresa un nombre" : null,
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
                decoration: const InputDecoration(
                  labelText: "Ruta de imagen (asset o archivo)",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newCoffee = CustomCoffee(
                      name: _nameController.text.trim(),
                      ratio: _ratioController.text.trim(),
                      molienda: _moliendaController.text.trim(),
                      descripcion: _descController.text.trim(),
                      imagePath: _imageController.text.trim(),
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
