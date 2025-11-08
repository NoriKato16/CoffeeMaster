import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AppDb {
  AppDb._();
  static final AppDb instance = AppDb._();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), 'coffeemaster.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (d, v) async {
        // Tabla de cafeteras 
        await d.execute('''
          CREATE TABLE makers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            ratio TEXT,
            molienda TEXT,
            descripcion TEXT,
            imagePath TEXT
          );
        ''');

        await d.execute('''
          CREATE TABLE recipes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            body TEXT,
            created_at TEXT
          );
        ''');
        // Relación receta-cafetera (muchos a muchos)
        await d.execute('''
          CREATE TABLE recipe_maker(
            recipe_id INTEGER NOT NULL,
            maker_id  INTEGER NOT NULL,
            PRIMARY KEY (recipe_id, maker_id)
          );
        ''');
      },
    );
    return _db!;
  }


  Future<int> insertMaker(Map<String, dynamic> m) async {
    final d = await db;
    return d.insert('makers', m, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllMakers() async {
    final d = await db;
    return d.query('makers', orderBy: 'id DESC');
  }

  Future<int> deleteMaker(int id) async {
    final d = await db;
    return d.delete('makers', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateMaker(int id, Map<String, dynamic> m) async {
    final d = await db;
    return d.update('makers', m, where: 'id = ?', whereArgs: [id]);
  }

  
  Future<int> insertRecipe(Map<String, dynamic> r) async {
    final d = await db;
    return d.insert('recipes', r, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllRecipes() async {
    final d = await db;
    return d.query('recipes', orderBy: 'id DESC');
  }

  Future<void> linkRecipeToMaker(int recipeId, int makerId) async {
    final d = await db;
    await d.insert('recipe_maker', {
      'recipe_id': recipeId,
      'maker_id': makerId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }
}
