import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'database_constants.dart';
import 'dao/dao_schema.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();

  static Database? _database;
  final List<DaoSchema> _registeredSchemas = [];

  void registerDao(DaoSchema schema) {
    _registeredSchemas.add(schema);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, DatabaseConstants.databaseName);

    return await openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    for (var schema in _registeredSchemas) {
      await schema.onCreate(db, version);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (var schema in _registeredSchemas) {
      await schema.onUpgrade(db, oldVersion, newVersion);
    }
  }

  Future<void> _onDowngrade(Database db, int oldVersion, int newVersion) async {
    for (var schema in _registeredSchemas) {
      await schema.onDowngrade(db, oldVersion, newVersion);
    }
  }
}
