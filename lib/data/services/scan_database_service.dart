import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/scan_record.dart';

class ScanDatabaseService {
  ScanDatabaseService._();

  static final ScanDatabaseService instance = ScanDatabaseService._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final factory = _databaseFactory;
    final path = await _databasePath();
    _database = await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE scans (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id TEXT NOT NULL,
              username TEXT NOT NULL,
              segment TEXT NOT NULL,
              barcode TEXT NOT NULL,
              entered_number TEXT NOT NULL,
              created_at TEXT NOT NULL
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute(
              "ALTER TABLE scans ADD COLUMN user_id TEXT NOT NULL DEFAULT ''",
            );
          }
        },
      ),
    );
    return _database!;
  }

  DatabaseFactory get _databaseFactory {
    if (kIsWeb) {
      return databaseFactoryFfiWeb;
    }
    return databaseFactory;
  }

  Future<String> _databasePath() async {
    if (kIsWeb) {
      return 'barscan.sqlite';
    }

    final databasePath = await getDatabasesPath();
    return p.join(databasePath, 'barscan.sqlite');
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
