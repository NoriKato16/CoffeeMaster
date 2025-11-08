import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecipesStore {
  static const _k = 'recipes_json';
  static Future<SharedPreferences> get _p async => SharedPreferences.getInstance();

  /// Schema de cada receta:
  /// {id:int, title:String, text:String, ratio:double, unit:String, makerIds:List<String>}
  static Future<List<Map<String, dynamic>>> all() async {
    final raw = (await _p).getString(_k);
    if (raw == null || raw.isEmpty) return [];
    final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();
    return list;
  }

  static Future<void> _save(List<Map<String, dynamic>> list) async {
    await (await _p).setString(_k, json.encode(list));
  }

  static Future<int> nextId() async {
    final ids = (await all()).map((e) => e['id'] as int).toList()..sort();
    return ids.isEmpty ? 1 : ids.last + 1;
  }

  static Future<void> upsert(Map<String, dynamic> rec) async {
    final list = await all();
    final i = list.indexWhere((e) => e['id'] == rec['id']);
    if (i >= 0) list[i] = rec; else list.add(rec);
    await _save(list);
  }

  static Future<void> delete(int id) async {
    final list = await all()..removeWhere((e) => e['id'] == id);
    await _save(list);
  }
}
