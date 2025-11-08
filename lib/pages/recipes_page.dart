import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../services/recipes_service.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});
  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _items = await RecipesStore.all();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      // NO uses const aquí
      return Scaffold(
        appBar: AppBar(title: const Text('Recetas')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Recetas')),
      body: _items.isEmpty
          ? const Center(child: Text('Sin recetas'))
          : ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final r = _items[i];
                return ListTile(
                  title: Text(r['title'] ?? 'Sin título'),
                  subtitle: Text('Ratio 1:${r['ratio'] ?? 15} ${r['unit'] ?? 'g'}'),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RecipeForm(initial: r)),
                    );
                    await _load();
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          final text = '''
Receta: ${r['title']}
Ratio: 1:${r['ratio']} ${r['unit']}
Cafeteras: ${(r['makerIds'] as List?)?.join(', ') ?? ''}
${r['text'] ?? ''}
''';
                          Share.share(text.trim());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await RecipesStore.delete(r['id'] as int);
                          await _load();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RecipeForm()),
          );
          await _load();
        },
      ),
    );
  }
}

class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key, this.initial});
  final Map<String, dynamic>? initial;

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  late final TextEditingController _title;
  late final TextEditingController _text;
  double _ratio = 15;
  String _unit = 'g';
  final Set<String> _makerIds = {};

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: (widget.initial?['title'] ?? '') as String);
    _text  = TextEditingController(text: (widget.initial?['text'] ?? '') as String);
    _ratio = ((widget.initial?['ratio'] ?? 15) as num).toDouble();
    _unit  = (widget.initial?['unit'] ?? 'g').toString();
    _makerIds.addAll(((widget.initial?['makerIds'] as List?)?.cast<String>() ?? const []));
  }

  @override
  void dispose() {
    _title.dispose();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Añade más cafeteras aquí según tu app
    final makers = const [
      {'id': 'it', 'name': 'Cafetera Italiana'},
      {'id': 'ae', 'name': 'AeroPress'},
      {'id': 'pf', 'name': 'Prensa Francesa'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(widget.initial == null ? 'Nueva receta' : 'Editar receta')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _text,
            minLines: 5,
            maxLines: 10,
            decoration: const InputDecoration(labelText: 'Texto de la receta', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Ratio 1:'),
              Expanded(
                child: Slider(
                  min: 5,
                  max: 25,
                  divisions: 20,
                  value: _ratio,
                  onChanged: (v) => setState(() => _ratio = v),
                ),
              ),
              SizedBox(
                width: 52,
                child: Text(_ratio.toStringAsFixed(0), textAlign: TextAlign.center),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _unit,
                items: const [
                  DropdownMenuItem(value: 'g', child: Text('g')),
                  DropdownMenuItem(value: 'ml', child: Text('ml')),
                ],
                onChanged: (v) => setState(() => _unit = v ?? 'g'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Cafeteras adecuadas'),
          Wrap(
            spacing: 8,
            children: makers.map((m) {
              final id = m['id'] as String;
              final selected = _makerIds.contains(id);
              return FilterChip(
                label: Text(m['name'] as String),
                selected: selected,
                onSelected: (v) {
                  setState(() => v ? _makerIds.add(id) : _makerIds.remove(id));
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () async {
              final id = widget.initial?['id'] ?? await RecipesStore.nextId();
              final rec = {
                'id': id,
                'title': _title.text.trim(),
                'text': _text.text.trim(),
                'ratio': _ratio,
                'unit': _unit,
                'makerIds': _makerIds.toList(),
              };
              await RecipesStore.upsert(rec);
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
