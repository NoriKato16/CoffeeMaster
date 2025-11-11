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
      onCreate: (d, _) async {
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
            body TEXT
          );
        ''');

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


  Future<int> insertMaker(Map<String, dynamic> m) async =>
      (await db).insert('makers', m, conflictAlgorithm: ConflictAlgorithm.replace);

  Future<List<Map<String, dynamic>>> getAllMakers() async =>
      (await db).query('makers', orderBy: 'id DESC');

  Future<int> updateMaker(int id, Map<String, dynamic> m) async =>
      (await db).update('makers', m, where: 'id = ?', whereArgs: [id]);

  Future<int> deleteMaker(int id) async =>
      (await db).delete('makers', where: 'id = ?', whereArgs: [id]);


  Future<int> insertRecipe(Map<String, dynamic> r) async =>
      (await db).insert('recipes', r, conflictAlgorithm: ConflictAlgorithm.replace);

  Future<int> updateRecipe(int id, Map<String, dynamic> r) async =>
      (await db).update('recipes', r, where: 'id = ?', whereArgs: [id]);

  Future<int> deleteRecipe(int id) async =>
      (await db).delete('recipes', where: 'id = ?', whereArgs: [id]);

  Future<List<Map<String, dynamic>>> getAllRecipes() async =>
      (await db).query('recipes', orderBy: 'id DESC');


  Future<void> replaceRecipeLinks(int recipeId, List<int> makerIds) async {
    final d = await db;
    final batch = d.batch();
    batch.delete('recipe_maker', where: 'recipe_id = ?', whereArgs: [recipeId]);
    for (final m in makerIds) {
      batch.insert('recipe_maker', {'recipe_id': recipeId, 'maker_id': m},
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }

  Future<List<int>> makersForRecipe(int recipeId) async {
    final rows = await (await db).query(
      'recipe_maker',
      columns: ['maker_id'],
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );
    return rows.map((e) => e['maker_id'] as int).toList();
  }
}
