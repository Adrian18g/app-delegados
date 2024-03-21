import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static final _eventosTableName = 'eventos';
  static final _usuariosTableName = 'usuarios';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'delegados.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_eventosTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT,
        titulo TEXT,
        descripcion TEXT,
        foto TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $_usuariosTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        apellido TEXT,
        matricula TEXT,
        foto TEXT
      )
    ''');
  }

  Future<void> insertEvento(Map<String, dynamic> evento) async {
    final db = await database;
    await db.insert(_eventosTableName, evento);
  }

  Future<List<Map<String, dynamic>>> getEventos() async {
    final db = await database;
    return await db.query(_eventosTableName);
  }

  Future<void> deleteEvento(int id) async {
    final db = await database;
    await db.delete(
      _eventosTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateEvento(Map<String, dynamic> evento) async {
    final db = await database;
    await db.update(
      _eventosTableName,
      evento,
      where: 'id = ?',
      whereArgs: [evento['id']],
    );
  }

  Future<void> insertUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    await db.insert(_usuariosTableName, usuario);
  }

  Future<List<Map<String, dynamic>>> getUsuarios() async {
    final db = await database;
    return await db.query(_usuariosTableName);
  }

  Future<void> deleteUsuario(int id) async {
    final db = await database;
    await db.delete(
      _usuariosTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    await db.update(
      _usuariosTableName,
      usuario,
      where: 'id = ?',
      whereArgs: [usuario['id']],
    );
  }
}
