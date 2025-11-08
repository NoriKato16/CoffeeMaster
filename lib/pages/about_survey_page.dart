import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSurveyPage extends StatefulWidget {
  const AboutSurveyPage({super.key});

  @override
  State<AboutSurveyPage> createState() => _AboutSurveyPageState();
}

class _AboutSurveyPageState extends State<AboutSurveyPage> {
  List<Map<String, dynamic>> _questions = [];
  final Map<String, dynamic> _answers = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final raw = await rootBundle.loadString('assets/cuestionario.json');
    _questions = (json.decode(raw) as List).cast<Map<String, dynamic>>();

    final p = await SharedPreferences.getInstance();
    for (final q in _questions) {
      final id = q['id'] as String;
      final type = q['type'] as String;
      if (p.containsKey('about_$id')) {
        _answers[id] = p.get('about_$id');
      } else {
        if (type == 'slider') {
          _answers[id] = ((q['min'] ?? 1) as num).toDouble();
        } else if (type == 'choice') {
          final opts = (q['options'] as List?)?.cast<String>() ?? const <String>[];
          _answers[id] = opts.isNotEmpty ? opts.first : '';
        } else {
          _answers[id] = '';
        }
      }
    }
    setState(() => _loading = false);
  }

  Future<void> _saveAll() async {
    final p = await SharedPreferences.getInstance();
    for (final e in _answers.entries) {
      final k = 'about_${e.key}';
      final v = e.value;
      if (v is int)        { await p.setInt(k, v); }
      else if (v is double){ await p.setDouble(k, v); }
      else if (v is bool)  { await p.setBool(k, v); }
      else if (v is String){ await p.setString(k, v); }
      else if (v is List)  { await p.setStringList(k, v.cast<String>()); }
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Respuestas guardadas')),
    );
  }

  Future<void> _sendEmail() async {
    final sb = StringBuffer()..writeln('Cuestionario Coffee Master')..writeln('');
    for (final q in _questions) {
      final id = q['id'] as String;
      final label = q['label'] as String;
      sb.writeln('$label: ${_answers[id]}');
    }
    final subject = Uri.encodeComponent('Cuestionario Coffee Master');
    final body    = Uri.encodeComponent(sb.toString());
    final uri = Uri.parse('mailto:noriks16@gmail.com?subject=$subject&body=$body');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cuestionario')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuestionario'),
        actions: [
          IconButton(
            tooltip: 'Guardar',
            onPressed: _saveAll,
            icon: const Icon(Icons.save_outlined),
          ),
          IconButton(
            tooltip: 'Enviar por correo',
            onPressed: _sendEmail,
            icon: const Icon(Icons.mail_outline),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _questions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _buildItem(_questions[i]),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: FilledButton(
          onPressed: () async { await _saveAll(); await _sendEmail(); },
          child: const Text('Guardar y enviar'),
        ),
      ),
    );
  }

  Widget _buildItem(Map<String, dynamic> q) {
    final id = q['id'] as String;
    final label = q['label'] as String;
    final type = q['type'] as String;

    switch (type) {
      case 'text':
        return TextFormField(
          initialValue: (_answers[id] ?? '') as String,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          onChanged: (v) => _answers[id] = v,
        );

      case 'number':
        return TextFormField(
          initialValue: (_answers[id]?.toString() ?? ''),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          onChanged: (v) => _answers[id] = int.tryParse(v) ?? 0,
        );

      case 'choice':
        final opts = (q['options'] as List?)?.cast<String>() ?? const <String>[];
        final current = (_answers[id] as String?) ?? (opts.isNotEmpty ? opts.first : '');
        return InputDecorator(
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: current.isEmpty && opts.isNotEmpty ? opts.first : current,
              items: [for (final o in opts) DropdownMenuItem(value: o, child: Text(o))],
              onChanged: (v) => setState(() => _answers[id] = v ?? ''),
            ),
          ),
        );

      case 'slider':
        final min = ((q['min'] ?? 1) as num).toDouble();
        final max = ((q['max'] ?? 5) as num).toDouble();
        final v = ((_answers[id] ?? min) as num).toDouble();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$label: ${v.toStringAsFixed(0)}'),
            Slider(
              min: min, max: max, divisions: (max - min).toInt(),
              value: v,
              onChanged: (x) => setState(() => _answers[id] = x),
            ),
          ],
        );

      default:
        return ListTile(title: Text(label), subtitle: const Text('Tipo no soportado'));
    }
  }
}
