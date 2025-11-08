import 'package:flutter/material.dart';
import '../services/SharedPreferencesService.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final _prefs = SharedPreferencesService();

  String _unit = 'g';
  double _ratio = 15.0;
  int? _lastMakerId;
  final _favIdsCtrl = TextEditingController();

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final unit = await _prefs.unit();
    final ratio = await _prefs.defaultRatio();
    final lastId = await _prefs.lastMakerId();
    final favIds = await _prefs.favRecipeIds();
    setState(() {
      _unit = unit;
      _ratio = ratio;
      _lastMakerId = lastId;
      _favIdsCtrl.text = SharedPreferencesService.joinCommaIds(favIds);
      _loading = false;
    });
  }

  Future<void> _save() async {
    await _prefs.setUnit(_unit);
    await _prefs.setDefaultRatio(_ratio);
    await _prefs.setLastMakerId(_lastMakerId);
    await _prefs.setFavRecipeIds(
      SharedPreferencesService.parseCommaIds(_favIdsCtrl.text),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferencias guardadas')),
    );
  }

  @override
  void dispose() {
    _favIdsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   if (_loading) {
  return Scaffold(
    appBar: AppBar(title: const Text('Preferencias')),
    body: const Center(child: CircularProgressIndicator()),
  );
}

    return Scaffold(
      appBar: AppBar(title: const Text('Preferencias')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Unidad
          const Text('Unidad de medida'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _unit,
            items: const [
              DropdownMenuItem(value: 'g', child: Text('Gramos (g)')),
              DropdownMenuItem(value: 'ml', child: Text('Mililitros (ml)')),
            ],
            onChanged: (v) => setState(() => _unit = v ?? 'g'),
          ),
          const SizedBox(height: 24),

          // Ratio por defecto
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ratio por defecto'),
              Text(SharedPreferencesService.formatRatio(_ratio)),
            ],
          ),
          Slider(
            min: 5,
            max: 25,
            divisions: 20,
            value: _ratio,
            onChanged: (v) => setState(() => _ratio = v),
          ),
          const SizedBox(height: 24),

          // Última cafetera
          const Text('Última cafetera utilizada (ID opcional)'),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: _lastMakerId?.toString() ?? '',
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'p. ej. 3',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() {
              _lastMakerId = int.tryParse(v.trim());
            }),
          ),
          const SizedBox(height: 24),

          // Favoritos
          const Text('IDs de recetas favoritas (separadas por coma)'),
          const SizedBox(height: 8),
          TextField(
            controller: _favIdsCtrl,
            decoration: const InputDecoration(
              hintText: '1, 5, 12',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 32),

          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Guardar cambios'),
          ),
        ],
      ),
    );
  }
}
