import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/base_entity.dart';
import '../database_constants.dart';

abstract class BaseDao<T extends BaseEntity> {
  final Database db;
  final Uuid uuid = const Uuid();

  BaseDao(this.db);

  // The table name
  String get tableName;

  // Converts a Map from SQLite back into the object
  T fromMap(Map<String, dynamic> map);

  // Standard Insert
  Future<void> insert(T item) async {
    await db.insert(
      tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Standard Update
  Future<void> update(T item) async {
    await db.update(
      tableName,
      item.toMap(),
      where: '${BaseColumns.id} = ?',
      whereArgs: [item.id],
    );
  }

  // Soft Delete (Used by the UI when the user deletes something offline)
  Future<void> softDelete(String id) async {
    final transactionId = uuid.v4();

    await db.update(
      tableName,
      {
        BaseColumns.deletedAt: DateTime.now().toIso8601String(),
        BaseColumns.updatedAt: DateTime.now().toIso8601String(),
        BaseColumns.syncId: transactionId,
        BaseColumns.syncStatus: 3, // 3 means "pending delete on server"
      },
      where: '${BaseColumns.id} = ?',
      whereArgs: [id],
    );
  }

  // Hard Delete (Used by the background sync process AFTER the server confirms deletion)
  Future<void> hardDelete(String id) async {
    await db.delete(tableName, where: '${BaseColumns.id} = ?', whereArgs: [id]);
  }

  // Get all active (non-deleted) records
  Future<List<T>> getAll() async {
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '${BaseColumns.deletedAt} IS NULL',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  // Get all items modified after a certain date (useful for syncing)
  Future<List<T>> getModifiedSince(DateTime lastSyncTime) async {
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '${BaseColumns.updatedAt} > ?',
      whereArgs: [lastSyncTime.toIso8601String()],
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  // Standard offline-first tracking columns
  static const String baseColumns =
      '''
    ${BaseColumns.createdAt} TEXT NOT NULL,
    ${BaseColumns.updatedAt} TEXT NOT NULL,
    ${BaseColumns.deletedAt} TEXT,
    ${BaseColumns.syncId} TEXT,
    ${BaseColumns.syncStatus} INTEGER DEFAULT 0
  ''';
}
