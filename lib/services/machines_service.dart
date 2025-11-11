import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class MachinesRepo {
  static const _assetPath  = 'assets/machines_base.json';
  static const _kOverrides = 'machines_overrides_v1';


  static Future<List<Map<String,dynamic>>> all() async {
    final base = await _loadBase();
    final ov   = await _loadOverrides();

    final byId = { for (final m in base) m['id'] as String : m };
    for (final m in ov) { byId[m['id'] as String] = _normalize(m); }

    final out = byId.values.map(_normalize).toList()
      ..sort((a,b)=> (a['nombre'] as String).toLowerCase()
        .compareTo((b['nombre'] as String).toLowerCase()));
    return out;
  }

  static Future<Map<String,dynamic>?> byId(String id) async {
    final list = await all();
    return list.firstWhere((e)=> e['id'] == id, orElse: () => {});
  }

  static Future<void> upsertEntry(Map<String,dynamic> entry) async {
    final list = await _loadOverrides();
    final clean = _normalize(entry);

    final toSave = {
      'id'           : clean['id'],
      'nombre'       : clean['nombre'],
      'image'        : clean['image'],
      'ratio_hint'   : clean['ratio_hint'],
      'molienda'     : clean['molienda'],
      'instrucciones': clean['instrucciones'],
    };
    final i = list.indexWhere((e)=> (e['id'] ?? '') == toSave['id']);
    if (i >= 0) list[i] = toSave; else list.add(toSave);
    await _saveOverrides(list);
  }

  static Future<void> removeEntry(String id) async {
    final list = await _loadOverrides()..removeWhere((e)=> (e['id'] ?? '') == id);
    await _saveOverrides(list);
  }

  static Future<List<Map<String,dynamic>>> _loadBase() async {
    final raw = await rootBundle.loadString(_assetPath);
    final j = json.decode(raw) as Map<String,dynamic>;
    final List l = (j['machines'] as List? ?? const []);
    return l.map((e)=> Map<String,dynamic>.from(e as Map)).toList();
  }

  static Future<List<Map<String,dynamic>>> _loadOverrides() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_kOverrides);
    if (raw == null || raw.isEmpty) return <Map<String,dynamic>>[];
    final List l = json.decode(raw) as List;
    return l.map((e)=> Map<String,dynamic>.from(e as Map)).toList();
  }

  static Future<void> _saveOverrides(List<Map<String,dynamic>> list) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kOverrides, json.encode(list));
  }

 
  static Map<String,dynamic> _normalize(Map<String,dynamic> src) {
    final m = Map<String,dynamic>.from(src);

   
    m['id']     = (m['id'] ?? '').toString();
    m['nombre'] = (m['nombre'] ?? '').toString();

   
    final img = (m['image'] ?? m['image_uri'] ?? '').toString();
    m['image'] = _normalizeImagePath(img, m['image_source']?.toString());

    
    final rmin = m['ratio_min'];
    final rmax = m['ratio_max'];
    if (rmin != null && rmax != null) {
      final a = _numToStr(rmin), b = _numToStr(rmax);
      m['ratio_hint'] = '1:$a~1:$b';
    } else {
      m['ratio_hint'] = (m['ratio_hint'] ?? '').toString();
    }

  
    final mol = m['molienda'];
    if (mol is List) {
      m['molienda'] = mol.map((e)=> e.toString()).join(', ');
    } else {
      m['molienda'] = (mol ?? '').toString();
    }

   
    final rawSteps = m['instrucciones'] ?? m['pasos'] ?? const <dynamic>[];
    m['instrucciones'] = (rawSteps is List)
        ? rawSteps.map((e)=> e.toString()).where((s)=> s.trim().isNotEmpty).toList()
        : <String>[];

  
    if ((m['image'] as String).isEmpty) {
      m['image'] = 'assets/images/machines/default.jpg';
    }
    return m;
  }

  static String _normalizeImagePath(String path, String? source) {
    if (path.isEmpty) return '';
   
    if (path.startsWith('asset://')) return path.substring('asset://'.length);
    if (path.startsWith('file://'))  return path.substring('file://'.length);

    if ((source ?? '') == 'asset') return path;
    return path; 
  }

  static String _numToStr(dynamic v) {
    if (v is int) return v.toString();
    if (v is double) {
      final s = v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 1);
      return s;
    }
    return v.toString();
  }
}
