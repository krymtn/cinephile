import 'package:sqflite/sqflite.dart';

abstract class DaoSchema {
  /// The name of the schema.
  String get name;
  /// Called when the database is created for the first time.
  /// The DAO should execute its CREATE TABLE statement here.
  Future<void> onCreate(Database db, int version);

  /// Called when the database needs to be upgraded.
  /// The DAO should execute ALTER TABLE or data migration statements here.
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion);

  /// Called when the database needs to be downgraded.
  Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    // Default implementation does nothing
  }
}
