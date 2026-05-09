import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'luluna.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Profiller tablosu
    await db.execute('''
      CREATE TABLE profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        avatar TEXT NOT NULL,
        color TEXT NOT NULL,
        total_detections INTEGER DEFAULT 0,
        weekly_growth INTEGER DEFAULT 0,
        success_rate INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Örnek profilleri ekle
    await _insertSampleProfiles(db);
  }

  Future<void> _insertSampleProfiles(Database db) async {
    final now = DateTime.now().toIso8601String();
    
    await db.insert('profiles', {
      'name': 'Ali Yılmaz',
      'age': 8,
      'avatar': '👦',
      'color': '#2196F3',
      'total_detections': 1,
      'weekly_growth': 1,
      'success_rate': 1,
      'created_at': now,
      'updated_at': now,
    });

    await db.insert('profiles', {
      'name': 'Zeynep Kaya',
      'age': 7,
      'avatar': '👧',
      'color': '#9C27B0',
      'total_detections': 1,
      'weekly_growth': 1,
      'success_rate': 1,
      'created_at': now,
      'updated_at': now,
    });
  }

  // Tüm profilleri getir
  Future<List<Map<String, dynamic>>> getAllProfiles() async {
    final db = await database;
    return await db.query('profiles', orderBy: 'created_at DESC');
  }

  // ID'ye göre profil getir
  Future<Map<String, dynamic>?> getProfileById(int id) async {
    final db = await database;
    final results = await db.query(
      'profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  // Yeni profil ekle
  Future<int> insertProfile(Map<String, dynamic> profile) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    return await db.insert('profiles', {
      ...profile,
      'created_at': now,
      'updated_at': now,
    });
  }

  // Profil güncelle
  Future<int> updateProfile(int id, Map<String, dynamic> profile) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    return await db.update(
      'profiles',
      {
        ...profile,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Profil sil
  Future<int> deleteProfile(int id) async {
    final db = await database;
    return await db.delete(
      'profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Profil istatistiklerini güncelle
  Future<int> updateProfileStats(int id, {
    int? totalDetections,
    int? weeklyGrowth,
    int? successRate,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    final updates = <String, dynamic>{'updated_at': now};
    
    if (totalDetections != null) updates['total_detections'] = totalDetections;
    if (weeklyGrowth != null) updates['weekly_growth'] = weeklyGrowth;
    if (successRate != null) updates['success_rate'] = successRate;
    
    return await db.update(
      'profiles',
      updates,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Veritabanını kapat
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
