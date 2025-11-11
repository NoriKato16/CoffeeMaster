import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class RecipesRepoV2 {
  static const _kOverrides = 'recipes_overrides_v2';
  static const _assetPath = 'assets/recipes_base.json';

  static Future<Map<String, dynamic>> _loadBase() async {
    final raw = await rootBundle.loadString(_assetPath);
    return json.decode(raw) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> _loadOv() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_kOverrides);
    if (raw == null || raw.isEmpty) return {'schemaVersion': 2, 'recipes': []};
    return json.decode(raw) as Map<String, dynamic>;
  }

  static Future<void> _saveOv(Map<String, dynamic> j) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kOverrides, json.encode(j));
  }

  
  static Future<List<Map<String, dynamic>>> all() async {
    final base = await _loadBase();
    final ov = await _loadOv();

    final byId = <String, Map<String, dynamic>>{};
    for (final r in (base['recipes'] as List)) {
      byId[(r as Map)['id'] as String] = Map<String, dynamic>.from(r);
    }

    for (final o in (ov['recipes'] as List)) {
      final patch = Map<String, dynamic>.from(o as Map);
      final id = patch['id'] as String;
      final tgt = Map<String, dynamic>.from(
        byId[id] ??
            {
              'id': id,
              'titulo': '',
              'tags': <String>[],
              'dificultad': 'media',
              'variantes': <dynamic>[],
            },
      );

      for (final k in ['titulo', 'tags', 'dificultad']) {
        if (patch.containsKey(k)) tgt[k] = patch[k];
      }

      if (patch['variantes'] is List) {
        final current = (tgt['variantes'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
        final byMid = {for (final v in current) v['machine_id'] as String: v};
        for (final v in (patch['variantes'] as List)) {
          final pv = Map<String, dynamic>.from(v as Map);
          final mid = pv['machine_id'] as String;
          final tv = Map<String, dynamic>.from(
            byMid[mid] ?? {'machine_id': mid},
          );
          for (final k in [
            'ratio',
            'molienda',
            'agua_c',
            'tiempo_s',
            'rendimiento_ml',
            'pasos',
          ]) {
            if (pv.containsKey(k)) tv[k] = pv[k];
          }
          byMid[mid] = tv;
        }
        tgt['variantes'] = byMid.values.toList();
      }

      byId[id] = tgt;
    }

    final out = byId.values.map((e) => Map<String, dynamic>.from(e)).toList();
    out.sort(
      (a, b) => (a['titulo'] as String).toLowerCase().compareTo(
        (b['titulo'] as String).toLowerCase(),
      ),
    );
    return out;
  }

  static Future<List<Map<String, dynamic>>> forMachine(String machineId) async {
    final rs = await all();
    return rs
        .where(
          (r) => (r['variantes'] as List).any(
            (v) => (v as Map)['machine_id'] == machineId,
          ),
        )
        .toList();
  }

  static Future<Map<String, dynamic>?> variantOf(
    Map<String, dynamic> recipe,
    String machineId,
  ) async {
    for (final v in (recipe['variantes'] as List)) {
      final mv = v as Map<String, dynamic>;
      if (mv['machine_id'] == machineId) return mv;
    }
    return null;
  }

  static Future<void> upsertVariantOverride({
    required String recipeId,
    required String machineId,
    String? ratio,
    String? molienda,
    int? aguaC,
    int? tiempoS,
    int? rendimientoMl,
    List<String>? pasos,
  }) async {
    final ov = await _loadOv();
    final list = (ov['recipes'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    Map<String, dynamic>? rec = list.firstWhere(
      (e) => e['id'] == recipeId,
      orElse: () => <String, dynamic>{},
    );
    final exists = rec.isNotEmpty;
    if (!exists) rec = {'id': recipeId, 'variantes': <dynamic>[]};

    final vars =
        (rec!['variantes'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        <Map<String, dynamic>>[];
    Map<String, dynamic>? v = vars.firstWhere(
      (e) => e['machine_id'] == machineId,
      orElse: () => <String, dynamic>{},
    );
    final vExists = v.isNotEmpty;
    if (!vExists) v = {'machine_id': machineId};

    if (ratio != null) v['ratio'] = ratio;
    if (molienda != null) v['molienda'] = molienda;
    if (aguaC != null) v['agua_c'] = aguaC;
    if (tiempoS != null) v['tiempo_s'] = tiempoS;
    if (rendimientoMl != null) v['rendimiento_ml'] = rendimientoMl;
    if (pasos != null) v['pasos'] = pasos;

    final i = vars.indexWhere((e) => e['machine_id'] == machineId);
    if (i >= 0) {
      vars[i] = v;
    } else {
      vars.add(v);
    }
    rec['variantes'] = vars;

    final rIndex = list.indexWhere((e) => e['id'] == recipeId);
    if (rIndex >= 0) {
      list[rIndex] = rec;
    } else {
      list.add(rec);
    }

    ov['recipes'] = list;
    await _saveOv(ov);
  }

  static Future<void> removeVariantOverride({
    required String recipeId,
    required String machineId,
  }) async {
    final ov = await _loadOv();
    final list = (ov['recipes'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    final ri = list.indexWhere((e) => e['id'] == recipeId);
    if (ri < 0) return; // no hay override para esa receta

    final rec = Map<String, dynamic>.from(list[ri]);
    final vars =
        (rec['variantes'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        <Map<String, dynamic>>[];
    vars.removeWhere((v) => v['machine_id'] == machineId);
    if (vars.isEmpty &&
        (rec.keys.toSet().difference({'id', 'variantes'}).isEmpty)) {
      
      list.removeAt(ri);
    } else {
      rec['variantes'] = vars;
      list[ri] = rec;
    }

    ov['recipes'] = list;
    await _saveOv(ov);
  }
}
