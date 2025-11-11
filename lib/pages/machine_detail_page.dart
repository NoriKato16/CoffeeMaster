import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../services/machines_service.dart';

class MachineDetailPage extends StatefulWidget {
  final Map<String, dynamic> machine; // entrada completa
  const MachineDetailPage({super.key, required this.machine});

  @override
  State<MachineDetailPage> createState() => _MachineDetailPageState();
}

class _MachineDetailPageState extends State<MachineDetailPage> {
  late Map<String, dynamic> m;

  @override
  void initState() {
    super.initState();
    m = Map<String, dynamic>.from(widget.machine);
  }

  @override
  Widget build(BuildContext context) {
    final pasos = ((m['instrucciones'] as List?)?.cast<String>() ?? const []);
    return Scaffold(
      appBar: AppBar(
        title: Text(m['nombre'] as String),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () =>
                Share.share(_shareText(m), subject: m['nombre'] as String),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final changed = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MachineEditPage(entry: m)),
              );
              if (changed == true && mounted) {
                final updated = await MachinesRepo.byId(m['id'] as String);
                if (updated != null) setState(() => m = updated);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if ((m['image'] as String?)?.isNotEmpty == true)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                m['image'] as String,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 12),
          _kv('Ratio sugerido', m['ratio_hint'].toString()),
          _kv('Molienda recomendada', m['molienda'].toString()),
          const SizedBox(height: 12),
          const Text(
            'Cómo usarla',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...pasos.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '• $p',
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _shareText(Map<String, dynamic> e) {
    final pasos = ((e['instrucciones'] as List?)?.cast<String>() ?? const []);
    return [
      'Cafetera: ${e['nombre']}',
      if ((e['ratio_hint'] ?? '').toString().isNotEmpty)
        'Ratio sugerido: ${e['ratio_hint']}',
      if ((e['molienda'] ?? '').toString().isNotEmpty)
        'Molienda: ${e['molienda']}',
      'Cómo usarla:',
      ...pasos.map((p) => '• $p'),
    ].join('\n');
  }

  Widget _kv(String k, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        SizedBox(
          width: 160,
          child: Text(
            '$k:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Text(v)),
      ],
    ),
  );
}

class MachineEditPage extends StatefulWidget {
  final Map<String, dynamic> entry;
  const MachineEditPage({super.key, required this.entry});

  @override
  State<MachineEditPage> createState() => _MachineEditPageState();
}

class _MachineEditPageState extends State<MachineEditPage> {
  final _form = GlobalKey<FormState>();
  late TextEditingController _nombre, _ratio, _molienda, _pasos;

  @override
  void initState() {
    super.initState();
    final e = widget.entry;
    _nombre = TextEditingController(text: (e['nombre'] ?? '').toString());
    _ratio = TextEditingController(text: (e['ratio_hint'] ?? '').toString());
    _molienda = TextEditingController(text: (e['molienda'] ?? '').toString());
    _pasos = TextEditingController(
      text: ((e['instrucciones'] as List?)?.cast<String>() ?? const []).join(
        '\n',
      ),
    );
  }

  @override
  void dispose() {
    _nombre.dispose();
    _ratio.dispose();
    _molienda.dispose();
    _pasos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    return Scaffold(
      appBar: AppBar(title: Text('Editar: ${e['nombre']}')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _t(_nombre, 'Nombre', req: true),
            const SizedBox(height: 12),
            _t(_ratio, 'Ratio sugerido (ej: 1:7~1:10)'),
            const SizedBox(height: 12),
            _t(_molienda, 'Molienda recomendada'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _pasos,
              minLines: 6,
              maxLines: 16,
              decoration: const InputDecoration(
                labelText: 'Pasos (uno por línea)',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final n = (v ?? '')
                    .trim()
                    .split('\n')
                    .where((x) => x.trim().isNotEmpty)
                    .length;
                return n < 3 ? 'Mínimo 3 pasos' : null;
              },
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () async {
                if (!_form.currentState!.validate()) return;
                final updated = {
                  'id': e['id'],
                  'nombre': _nombre.text.trim(),
                  'image': e['image'], // no editable aquí
                  'ratio_hint': _ratio.text.trim(),
                  'molienda': _molienda.text.trim(),
                  'instrucciones': _pasos.text
                      .split('\n')
                      .map((x) => x.trim())
                      .where((x) => x.isNotEmpty)
                      .toList(),
                };
                await MachinesRepo.upsertEntry(updated);
                if (!mounted) return;
                Navigator.pop(context, true);
              },
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                await MachinesRepo.removeEntry(e['id'] as String);
                if (!mounted) return;
                Navigator.pop(context, true);
              },
              child: const Text('Restablecer a base'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _t(TextEditingController c, String label, {bool req = false}) =>
      TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: req
            ? (v) => (v == null || v.trim().isEmpty) ? 'Obligatorio' : null
            : null,
      );
}
