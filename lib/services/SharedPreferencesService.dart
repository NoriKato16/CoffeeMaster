import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

 
  static const _kUnit = 'unit'; 
  static const _kDefaultRatio = 'default_ratio';
  static const _kLastMakerId = 'last_maker_id';
  static const _kFavRecipeIds = 'fav_recipe_ids';
  static const _kUsagePrefix = 'usage_';

  static const _kKeepScreenOn     = 'keep_screen_on';      
  static const _kOrderRecent      = 'order_recent';        
  static const _kDefaultMachineId = 'default_machine_id';  
  static const _kTextScale        = 'text_scale';          


  Future<void> setUnit(String v) async {
    final p = await _prefs;
    await p.setString(_kUnit, v);
  }

  Future<void> setDefaultRatio(double v) async {
    final p = await _prefs;
    await p.setDouble(_kDefaultRatio, v);
  }

  Future<void> setLastMakerId(int? v) async {
    final p = await _prefs;
    if (v == null) {
      await p.remove(_kLastMakerId);
    } else {
      await p.setInt(_kLastMakerId, v);
    }
  }

  Future<void> setFavRecipeIds(List<String> ids) async {
    final p = await _prefs;
    await p.setStringList(_kFavRecipeIds, ids);
  }


  Future<String> unit() async {
    final p = await _prefs;
    return p.getString(_kUnit) ?? 'g';
  }

  Future<double> defaultRatio() async {
    final p = await _prefs;
    return p.getDouble(_kDefaultRatio) ?? 15.0;
  }

  Future<int?> lastMakerId() async {
    final p = await _prefs;
    return p.getInt(_kLastMakerId);
  }

  Future<List<String>> favRecipeIds() async {
    final p = await _prefs;
    return p.getStringList(_kFavRecipeIds) ?? <String>[];
  }


  static String formatRatio(double r) {
    final isInt = r.truncateToDouble() == r;
    return '1:${r.toStringAsFixed(isInt ? 0 : 1)}';
  }

  static List<String> parseCommaIds(String s) {
    return s
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<int> getUsageCount(String makerId) async {
    final p = await _prefs;
    return p.getInt('$_kUsagePrefix$makerId') ?? 0;
  }

  Future<void> bumpUsage(String makerId) async {
    final p = await _prefs;
    final k = '$_kUsagePrefix$makerId';
    final v = p.getInt(k) ?? 0;
    await p.setInt(k, v + 1);
  }

  Future<void> resetUsage(String makerId) async {
    final p = await _prefs;
    await p.remove('$_kUsagePrefix$makerId');
  }

  static String joinCommaIds(List<String> ids) => ids.join(', ');

 
  Future<bool> keepScreenOn() async {
    final p = await _prefs;
    return p.getBool(_kKeepScreenOn) ?? true;
  }

  Future<void> setKeepScreenOn(bool v) async {
    final p = await _prefs;
    await p.setBool(_kKeepScreenOn, v);
  }

  
  Future<bool> orderByRecent() async {
    final p = await _prefs;
    return p.getBool(_kOrderRecent) ?? true;
  }

  Future<void> setOrderByRecent(bool v) async {
    final p = await _prefs;
    await p.setBool(_kOrderRecent, v);
  }

  
  Future<String?> defaultMachineId() async {
    final p = await _prefs;
    return p.getString(_kDefaultMachineId);
  }

  Future<void> setDefaultMachineId(String? id) async {
    final p = await _prefs;
    if (id == null || id.isEmpty) {
      await p.remove(_kDefaultMachineId);
    } else {
      await p.setString(_kDefaultMachineId, id);
    }
  }

 
  Future<double> textScale() async {
    final p = await _prefs;
    return p.getDouble(_kTextScale) ?? 1.0; 
  }

  Future<void> setTextScale(double v) async {
    final p = await _prefs;
    await p.setDouble(_kTextScale, v);
  }
}
