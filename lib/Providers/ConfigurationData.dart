import 'package:flutter/material.dart';
import '../services/SharedPreferencesService.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigurationData extends ChangeNotifier {
  final SharedPreferencesService _prefs = SharedPreferencesService();

 

  final List<String> creations = [];
  ConfigurationData() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {

    notifyListeners();
  }
}