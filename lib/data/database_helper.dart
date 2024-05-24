import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/receita.dart';

class DatabaseHelper {
  static final _databaseName = 'receitas_database.db';
  static final _databaseVersion = 1;

  static final tableReceitas = 'receitas';
  static final columnId = 'id';
  static final columnTitulo = 'titulo';
  static final columnIngredientes = 'ingredientes';
  static final columnModoPreparo = 'modo_preparo';
  static final columnCategorias = 'categorias';
  static final columnFavorita = 'favorita';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableReceitas (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnTitulo TEXT NOT NULL,
      $columnIngredientes TEXT NOT NULL,
      $columnModoPreparo TEXT NOT NULL,
      $columnCategorias TEXT NOT NULL,
      $columnFavorita INTEGER NOT NULL
    )
  ''');
  }

  Future<int> insertReceita(Receita receita) async {
    Database db = await instance.database;
    return await db.insert(tableReceitas, receita.toMap());
  }

  Future<int> updateReceita(Receita receita) async {
    Database db = await instance.database;
    int id = receita.id!;
    return await db.update(tableReceitas, receita.toMap(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteReceita(int id) async {
    Database db = await instance.database;
    return await db.delete(tableReceitas, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Receita>> getTodasReceitas() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableReceitas);
    return List.generate(maps.length, (i) {
      return Receita(
        id: maps[i][columnId],
        titulo: maps[i][columnTitulo],
        ingredientes: maps[i][columnIngredientes],
        modoPreparo: maps[i][columnModoPreparo],
        categorias: maps[i][columnCategorias],
        favorita: maps[i][columnFavorita],
      );
    });
  }

  Future<List<Receita>> getReceitasFavoritas() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      tableReceitas,
      where: '$columnFavorita = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) {
      return Receita(
        id: maps[i][columnId],
        titulo: maps[i][columnTitulo],
        ingredientes: maps[i][columnIngredientes],
        modoPreparo: maps[i][columnModoPreparo],
        categorias: maps[i][columnCategorias],
        favorita: maps[i][columnFavorita],
      );
    });
  }
}
