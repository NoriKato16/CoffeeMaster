import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ConfigurationData.dart';
import '../services/SharedPreferencesService.dart';
import '../services/machines_service.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});
  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final _prefs = SharedPreferencesService();

  bool _keepScreenOn = true;
  bool _orderByRecent = true;
  String? _defaultMachineId;                    // puede ser null
  List<Map<String, dynamic>> _machines = [];

  double _textScale = 1.0;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final machines       = await MachinesRepo.all();
    final keepScreenOn   = await _prefs.keepScreenOn();
    final orderByRecent  = await _prefs.orderByRecent();
    final defaultMachine = await _prefs.defaultMachineId();
    final textScale      = await _prefs.textScale();

    setState(() {
      _machines = machines;
      _keepScreenOn = keepScreenOn;
      _orderByRecent = orderByRecent;
      _defaultMachineId = defaultMachine;       // puede venir null
      _textScale = textScale.clamp(0.9, 1.4);
      _loading = false;
    });
  }

  Future<void> _save() async {
    await _prefs.setKeepScreenOn(_keepScreenOn);
    await _prefs.setOrderByRecent(_orderByRecent);
    await _prefs.setDefaultMachineId(_defaultMachineId);
    await _prefs.setTextScale(_textScale);

    // Notifica para aplicar el cambio global inmediato
    if (mounted) context.read<ConfigurationData>().setTextScale(_textScale);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferencias guardadas')),
    );
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
          // Mantener pantalla encendida
          SwitchListTile(
            title: const Text('Mantener pantalla encendida durante la preparación'),
            value: _keepScreenOn,
            onChanged: (v) => setState(() => _keepScreenOn = v),
          ),
          const SizedBox(height: 12),

          // Orden Home
          SwitchListTile(
            title: const Text('Ordenar inicio por uso reciente'),
            subtitle: const Text('Desactiva para ordenar alfabéticamente'),
            value: _orderByRecent,
            onChanged: (v) => setState(() => _orderByRecent = v),
          ),
          const SizedBox(height: 16),

          // Cafetera por defecto
          const Text('Cafetera por defecto para nuevas recetas'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String?>(
            initialValue: _defaultMachineId,     // reemplaza "value" deprecado
            isExpanded: true,
            items: [
              const DropdownMenuItem<String?>(value: null, child: Text('Ninguna')),
              ..._machines.map((m) => DropdownMenuItem<String?>(
                    value: m['id'] as String,
                    child: Text(m['nombre'] as String),
                  )),
            ],
            onChanged: (v) => setState(() => _defaultMachineId = v),
          ),
          const SizedBox(height: 24),

          // Tamaño de texto
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tamaño de texto en recetas'),
              Text('${(_textScale * 100).round()}%'),
            ],
          ),
          Slider(
            min: 0.9,
            max: 1.4,
            divisions: 10,
            value: _textScale,
            onChanged: (v) => setState(() => _textScale = double.parse(v.toStringAsFixed(2))),
          ),

          const SizedBox(height: 28),
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
