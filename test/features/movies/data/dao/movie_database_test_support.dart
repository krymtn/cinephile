import 'package:cinephileapp/features/movies/data/dao/movie_dao_schema.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

bool _sqfliteFfiInitialized = false;

/// Call once per test file (e.g. in `setUpAll`) so sqflite uses the FFI implementation.
void ensureSqfliteFfiInitialized() {
  if (_sqfliteFfiInitialized) return;
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  _sqfliteFfiInitialized = true;
}

/// Opens a disposable on-disk database with [MovieDaoSchema] applied at version 1.
///
/// Use a unique file name so parallel or repeated runs do not clash; delete in tearDown.
Future<Database> openMovieTestDatabase() async {
  ensureSqfliteFfiInitialized();
  final schema = MovieDaoSchema();
  final unique =
      'movie_test_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecondsSinceEpoch}.db';
  return databaseFactory.openDatabase(
    unique,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) => schema.onCreate(db, version),
    ),
  );
}

Future<void> closeAndDeleteTestDatabase(Database db) async {
  final path = db.path;
  await db.close();
  await databaseFactory.deleteDatabase(path);
}
