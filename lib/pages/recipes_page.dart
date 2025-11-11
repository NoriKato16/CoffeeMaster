import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../services/recipes_service.dart'; // usa RecipesRepoFlat

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});
  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  late Future<List<Map<String, dynamic>>> _f;

  @override
  void initState() {
    super.initState();
    _f = RecipesRepoFlat.all();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recetas')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _f,
        builder: (_, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());
          final items = snap.data!;
          if (items.isEmpty) return const Center(child: Text('Sin recetas'));

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final e = items[i];
              return ListTile(
                title: Text((e['titulo'] ?? 'Sin título').toString()),
                subtitle: Text(
                  '${_machineName((e['machine_id'] ?? '').toString())} • Ratio ${e['ratio']}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    final pasos =
                        ((e['pasos'] as List?)?.cast<String>() ?? const []);
                    final s = StringBuffer()
                      ..writeln('Receta: ${e['titulo']}')
                      ..writeln(
                        'Cafetera: ${_machineName((e['machine_id'] ?? '').toString())}',
                      )
                      ..writeln('Ratio: ${e['ratio']}')
                      ..writeln('Molienda: ${e['molienda']}')
                      ..writeln('Agua: ${e['agua_c']} °C')
                      ..writeln('Tiempo: ${e['tiempo_s']} s')
                      ..writeln('Rendimiento: ${e['rendimiento_ml']} ml')
                      ..writeln('Pasos:')
                      ..writeln(pasos.map((p) => '• $p').join('\n'));
                    Share.share(s.toString(), subject: e['titulo'].toString());
                  },
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _RecipeEntryDetail(entry: e),
                    ),
                  );
                  if (!mounted) return;
                  setState(() {
                    _f = RecipesRepoFlat.all();
                  });
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final created = await _createNewEntry(context);
          if (!mounted) return;
          if (created == true) {
            setState(() {
              _f = RecipesRepoFlat.all();
            });
          }
        },
      ),
    );
  }

  Future<bool?> _createNewEntry(BuildContext context) async {
    final titleCtrl = TextEditingController();
    String machineId = _machineIds.first;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nueva receta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Título de la receta',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Cafetera',
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: machineId,
                  items: _machineIds
                      .map(
                        (id) => DropdownMenuItem(
                          value: id,
                          child: Text(_machineName(id)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => machineId = v ?? machineId,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );

    if (ok != true) return false;
    final title = titleCtrl.text.trim();
    if (title.isEmpty) return false;

    final id = 'user:${_slugify(title)}|$machineId';
    final entry = {
      'id': id,
      'titulo': title,
      'machine_id': machineId,
      'ratio': '1:15',
      'molienda': 'media',
      'agua_c': 92,
      'tiempo_s': 180,
      'rendimiento_ml': 250,
      'pasos': <String>[
        'Calienta el agua a 92 °C.',
        'Muele el café (molienda media).',
        'Sigue el método de la cafetera seleccionada y extrae.',
      ],
    };

    final changed = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _RecipeEntryEdit(entry: entry)),
    );
    return changed == true;
  }

  String _slugify(String s) {
    final lower = s.toLowerCase();
    final only = lower.replaceAll(RegExp(r'[^a-z0-9 _-]'), '');
    return only.replaceAll(RegExp(r'\s+'), '_');
  }

  List<String> get _machineIds => const [
    'moka',
    'french_press',
    'aeropress',
    'espresso_machine',
    'v60',
    'kalita_wave',
    'chemex',
    'phin',
    'clever',
    'sifon',
    'cold_brew',
    'cezve',
  ];

  String _machineName(String id) {
    switch (id) {
      case 'moka':
        return 'Moka';
      case 'french_press':
        return 'Prensa francesa';
      case 'aeropress':
        return 'AeroPress';
      case 'espresso_machine':
        return 'Espresso';
      case 'v60':
        return 'V60';
      case 'kalita_wave':
        return 'Kalita';
      case 'chemex':
        return 'Chemex';
      case 'phin':
        return 'Phin';
      case 'clever':
        return 'Clever';
      case 'sifon':
        return 'Sifón';
      case 'cold_brew':
        return 'Cold Brew';
      case 'cezve':
        return 'Cezve';
      default:
        return id;
    }
  }
}

// -------------------- Detalle --------------------

class _RecipeEntryDetail extends StatefulWidget {
  final Map<String, dynamic> entry;
  const _RecipeEntryDetail({required this.entry});
  @override
  State<_RecipeEntryDetail> createState() => _RecipeEntryDetailState();
}

class _RecipeEntryDetailState extends State<_RecipeEntryDetail> {
  late Map<String, dynamic> e;

  @override
  void initState() {
    super.initState();
    e = Map<String, dynamic>.from(widget.entry);
  }

  @override
  Widget build(BuildContext context) {
    final pasos = ((e['pasos'] as List?)?.cast<String>() ?? const []);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${e['titulo']} • ${_machineName((e['machine_id'] ?? '').toString())}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final s = StringBuffer()
                ..writeln('Receta: ${e['titulo']}')
                ..writeln(
                  'Cafetera: ${_machineName((e['machine_id'] ?? '').toString())}',
                )
                ..writeln('Ratio: ${e['ratio']}')
                ..writeln('Molienda: ${e['molienda']}')
                ..writeln('Agua: ${e['agua_c']} °C')
                ..writeln('Tiempo: ${e['tiempo_s']} s')
                ..writeln('Rendimiento: ${e['rendimiento_ml']} ml')
                ..writeln('Pasos:')
                ..writeln(pasos.map((p) => '• $p').join('\n'));
              Share.share(s.toString(), subject: e['titulo'].toString());
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final changed = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => _RecipeEntryEdit(entry: e)),
              );
              if (changed == true && mounted) {
                final updated = await RecipesRepoFlat.byId(
                  (e['id'] ?? '').toString(),
                );
                if (updated != null) {
                  setState(() {
                    e = updated;
                  });
                }
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _kv('Ratio', e['ratio'].toString()),
          _kv('Molienda', e['molienda'].toString()),
          _kv('Agua', '${e['agua_c']} °C'),
          _kv('Tiempo', '${e['tiempo_s']} s'),
          _kv('Rendimiento', '${e['rendimiento_ml']} ml'),
          const SizedBox(height: 12),
          const Text(
            'Pasos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (pasos.isEmpty)
            const Text(
              'Sin pasos definidos.',
              style: TextStyle(color: Colors.black54),
            )
          else
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

  Widget _kv(String k, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$k:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Text(v)),
      ],
    ),
  );

  String _machineName(String id) {
    switch (id) {
      case 'moka':
        return 'Moka';
      case 'french_press':
        return 'Prensa francesa';
      case 'aeropress':
        return 'AeroPress';
      case 'espresso_machine':
        return 'Espresso';
      case 'v60':
        return 'V60';
      case 'kalita_wave':
        return 'Kalita';
      case 'chemex':
        return 'Chemex';
      case 'phin':
        return 'Phin';
      case 'clever':
        return 'Clever';
      case 'sifon':
        return 'Sifón';
      case 'cold_brew':
        return 'Cold Brew';
      case 'cezve':
        return 'Cezve';
      default:
        return id;
    }
  }
}

// -------------------- Editor --------------------

class _RecipeEntryEdit extends StatefulWidget {
  final Map<String, dynamic> entry;
  const _RecipeEntryEdit({required this.entry});
  @override
  State<_RecipeEntryEdit> createState() => _RecipeEntryEditState();
}

class _RecipeEntryEditState extends State<_RecipeEntryEdit> {
  final _form = GlobalKey<FormState>();
  late TextEditingController _ratio, _molienda, _agua, _tiempo, _rend, _pasos;

  @override
  void initState() {
    super.initState();
    final e = widget.entry;
    _ratio = TextEditingController(text: (e['ratio'] ?? '').toString());
    _molienda = TextEditingController(text: (e['molienda'] ?? '').toString());
    _agua = TextEditingController(text: (e['agua_c'] ?? 92).toString());
    _tiempo = TextEditingController(text: (e['tiempo_s'] ?? 180).toString());
    _rend = TextEditingController(
      text: (e['rendimiento_ml'] ?? 250).toString(),
    );
    _pasos = TextEditingController(
      text: ((e['pasos'] as List?)?.cast<String>() ?? const []).join('\n'),
    );
  }

  @override
  void dispose() {
    _ratio.dispose();
    _molienda.dispose();
    _agua.dispose();
    _tiempo.dispose();
    _rend.dispose();
    _pasos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    return Scaffold(
      appBar: AppBar(title: Text('Editar: ${e['titulo']}')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _t(_ratio, 'Ratio', req: true),
            const SizedBox(height: 12),
            _t(_molienda, 'Molienda', req: true),
            const SizedBox(height: 12),
            _n(_agua, 'Agua (°C)', 20, 100),
            const SizedBox(height: 12),
            _n(_tiempo, 'Tiempo (s)', 1, 3600),
            const SizedBox(height: 12),
            _n(_rend, 'Rendimiento (ml)', 10, 2000),
            const SizedBox(height: 12),
            TextFormField(
              controller: _pasos,
              minLines: 6,
              maxLines: 14,
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
                  'titulo': e['titulo'],
                  'machine_id': e['machine_id'],
                  'ratio': _ratio.text.trim(),
                  'molienda': _molienda.text.trim(),
                  'agua_c': int.parse(_agua.text.trim()),
                  'tiempo_s': int.parse(_tiempo.text.trim()),
                  'rendimiento_ml': int.parse(_rend.text.trim()),
                  'pasos': _pasos.text
                      .split('\n')
                      .map((x) => x.trim())
                      .where((x) => x.isNotEmpty)
                      .toList(),
                };
                await RecipesRepoFlat.upsertEntry(updated);
                if (!mounted) return;
                Navigator.pop(context, true);
              },
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                await RecipesRepoFlat.removeEntry((e['id'] ?? '').toString());
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

  Widget _n(TextEditingController c, String label, int min, int max) =>
      TextFormField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (v) {
          final n = int.tryParse(v ?? '');
          if (n == null) return 'Número';
          if (n < min || n > max) return '$min–$max';
          return null;
        },
      );
}
