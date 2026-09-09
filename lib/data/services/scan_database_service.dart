import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/scan_record.dart';

class ScanDatabaseService {
  ScanDatabaseService._();

  static final ScanDatabaseService instance = ScanDatabaseService._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final databasePath = await getDatabasesPath();
    final path = p.join(databasePath, 'barscan.sqlite');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE scans (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            segment TEXT NOT NULL,
            barcode TEXT NOT NULL,
            entered_number TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
    return _database!;
  }

  Future<int> insert(ScanRecord record) async {
    final db = await database;
    return db.insert('scans', record.toDatabase());
  }

  Future<List<ScanRecord>> records() async {
    final db = await database;
    final rows = await db.query('scans', orderBy: 'created_at DESC');
    return rows.map(ScanRecord.fromDatabase).toList();
  }

  Future<int> count() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) AS total FROM scans');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> delete(int id) async {
    final db = await database;
    await db.delete('scans', where: 'id = ?', whereArgs: [id]);
  }
}
