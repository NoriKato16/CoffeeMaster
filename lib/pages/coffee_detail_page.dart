import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class CoffeeDetailPage extends StatefulWidget {
  final String name;
  final String ratio;
  final String molienda;
  final String descripcion;
  final String imagePath; // puede ser asset o archivo

  const CoffeeDetailPage({
    super.key,
    required this.name,
    required this.ratio,
    required this.molienda,
    required this.descripcion,
    required this.imagePath,
  });

  @override
  State<CoffeeDetailPage> createState() => _CoffeeDetailPageState();
}

class _CoffeeDetailPageState extends State<CoffeeDetailPage> {
  late String _currentPath; // path actual de la imagen (asset o file)

  @override
  void initState() {
    super.initState();
    _currentPath = widget.imagePath;
  }

  bool _isFilePath(String path) {
    if (path.startsWith('assets/')) return false;
    return File(path).existsSync();
  }

  Future<void> _takePhoto() async {
    final x = await ImagePicker().pickImage(source: ImageSource.camera);
    if (x == null) return;
    setState(() => _currentPath = x.path);
  }

  void _share() {
    final text =
        '''
${widget.name}
Ratio: ${widget.ratio}
Molienda: ${widget.molienda}

${widget.descripcion}
''';
    if (_isFilePath(_currentPath)) {
      Share.shareXFiles([XFile(_currentPath)], text: text.trim());
    } else {
      Share.share(text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = _isFilePath(_currentPath)
        ? Image.file(File(_currentPath), fit: BoxFit.cover)
        : Image.asset(_currentPath, fit: BoxFit.cover);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [IconButton(icon: const Icon(Icons.share), onPressed: _share)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageWidget,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tomar foto'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Ratio: ${widget.ratio}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Molienda: ${widget.molienda}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(widget.descripcion, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
