import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';


class RecipesRepoFlat {
  static const _assetPath  = 'assets/recipes_base.json';      // base v2
  static const _kOverrides = 'recipes_overrides_flat_v1';     // lista de entradas planas


  static Future<List<Map<String, dynamic>>> _loadBaseFlat() async {
    final raw = await rootBundle.loadString(_assetPath);
    final j = json.decode(raw) as Map<String, dynamic>;
    final List base = (j['recipes'] as List? ?? const []);
    final out = <Map<String, dynamic>>[];

    for (final r0 in base.cast<Map>()) {
      final r = Map<String, dynamic>.from(r0);
      final titulo = (r['titulo'] ?? '').toString();
      final idBase = (r['id'] ?? '').toString();
      final List vars = (r['variantes'] as List? ?? const []);
      for (final v0 in vars.cast<Map>()) {
        final v = Map<String, dynamic>.from(v0);
        final mid = (v['machine_id'] ?? '').toString();
        out.add({
          'id'            : '$idBase|$mid', // id compuesto
          'titulo'        : titulo,
          'machine_id'    : mid,
          'ratio'         : (v['ratio'] ?? '').toString(),
          'molienda'      : (v['molienda'] ?? '').toString(),
          'agua_c'        : (v['agua_c'] as num? ?? 90).toInt(),
          'tiempo_s'      : (v['tiempo_s'] as num? ?? 180).toInt(),
          'rendimiento_ml': (v['rendimiento_ml'] as num? ?? 200).toInt(),
          'pasos'         : ((v['pasos'] as List?)?.map((e) => e.toString()).toList() ?? const <String>[]),
        });
      }
    }
    out.sort((a, b) => (a['titulo'] as String).toLowerCase().compareTo((b['titulo'] as String).toLowerCase()));
    return out;
  }


  static Future<List<Map<String, dynamic>>> _loadOverrides() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_kOverrides);
    if (raw == null || raw.isEmpty) return <Map<String, dynamic>>[];
    final List l = json.decode(raw) as List;
    return l.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> _saveOverrides(List<Map<String, dynamic>> list) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kOverrides, json.encode(list));
  }


  static Future<List<Map<String, dynamic>>> all() async {
    final base = await _loadBaseFlat();
    final ov = await _loadOverrides();

    final byId = {for (final e in base) e['id'] as String: e};
    for (final e in ov) {
      byId[e['id'] as String] = e; 
    }
    final out = byId.values.toList();
    out.sort((a, b) => (a['titulo'] as String).toLowerCase().compareTo((b['titulo'] as String).toLowerCase()));
    return out;
  }

  static Future<List<Map<String, dynamic>>> forMachine(String machineId) async {
    final list = await all();
    return list.where((e) => e['machine_id'] == machineId).toList();
  }

  static Future<Map<String, dynamic>?> byId(String id) async {
    final list = await all();
    return list.firstWhere((e) => e['id'] == id, orElse: () => {});
  }

  
  static Future<void> upsertEntry(Map<String, dynamic> entry) async {
    final list = await _loadOverrides();
    final i = list.indexWhere((e) => e['id'] == entry['id']);
    final clean = {
      'id'            : entry['id'],
      'titulo'        : entry['titulo'],
      'machine_id'    : entry['machine_id'],
      'ratio'         : entry['ratio'],
      'molienda'      : entry['molienda'],
      'agua_c'        : (entry['agua_c'] as num).toInt(),
      'tiempo_s'      : (entry['tiempo_s'] as num).toInt(),
      'rendimiento_ml': (entry['rendimiento_ml'] as num).toInt(),
      'pasos'         : ((entry['pasos'] as List).map((e) => e.toString()).toList()),
    };
    if (i >= 0) {
      list[i] = clean;
    } else {
      list.add(clean);
    }
    await _saveOverrides(list);
  }

  static Future<void> removeEntry(String id) async {
    final list = await _loadOverrides()..removeWhere((e) => e['id'] == id);
    await _saveOverrides(list);
  }
}
