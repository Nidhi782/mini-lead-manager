import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/lead_model.dart';

class LeadDbService {
  static final LeadDbService instance = LeadDbService._init();
  static Database? _database;

  LeadDbService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('leads.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE leads (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        contact TEXT NOT NULL,
        notes TEXT,
        status TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertLead(Lead lead) async {
    final db = await database;
    return await db.insert('leads', lead.toMap());
  }

  Future<List<Lead>> getAllLeads() async {
    final db = await database;
    final result = await db.query(
      'leads',
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Lead.fromMap(map)).toList();
  }

  /// Get leads with pagination
  /// [limit] - number of leads to fetch
  /// [offset] - number of leads to skip
  Future<List<Lead>> getLeadsPaginated({
    int limit = 20,
    int offset = 0,
    String? status,
    String? searchQuery,
  }) async {
    final db = await database;

    String? whereClause;
    List<dynamic>? whereArgs;

    if (status != null && status != 'All') {
      if (searchQuery != null && searchQuery.isNotEmpty) {
        whereClause = 'status = ? AND name LIKE ?';
        whereArgs = [status, '%$searchQuery%'];
      } else {
        whereClause = 'status = ?';
        whereArgs = [status];
      }
    } else if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause = 'name LIKE ?';
      whereArgs = ['%$searchQuery%'];
    }

    final result = await db.query(
      'leads',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'createdAt DESC',
      limit: limit,
      offset: offset,
    );
    return result.map((map) => Lead.fromMap(map)).toList();
  }

  /// Get total count of leads (for pagination)
  Future<int> getLeadsCount({
    String? status,
    String? searchQuery,
  }) async {
    final db = await database;

    String? whereClause;
    List<dynamic>? whereArgs;

    if (status != null && status != 'All') {
      if (searchQuery != null && searchQuery.isNotEmpty) {
        whereClause = 'status = ? AND name LIKE ?';
        whereArgs = [status, '%$searchQuery%'];
      } else {
        whereClause = 'status = ?';
        whereArgs = [status];
      }
    } else if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause = 'name LIKE ?';
      whereArgs = ['%$searchQuery%'];
    }

    final result = await db.rawQuery(
      whereClause != null
          ? 'SELECT COUNT(*) as count FROM leads WHERE $whereClause'
          : 'SELECT COUNT(*) as count FROM leads',
      whereArgs,
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Lead>> getLeadsByStatus(String status) async {
    final db = await database;
    final result = await db.query(
      'leads',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Lead.fromMap(map)).toList();
  }

  Future<List<Lead>> searchLeads(String query) async {
    final db = await database;
    final result = await db.query(
      'leads',
      where: 'name LIKE ? OR contact LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Lead.fromMap(map)).toList();
  }

  Future<Lead?> getLeadById(int id) async {
    final db = await database;
    final result = await db.query(
      'leads',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Lead.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateLead(Lead lead) async {
    final db = await database;
    return await db.update(
      'leads',
      lead.toMap(),
      where: 'id = ?',
      whereArgs: [lead.id],
    );
  }

  Future<int> deleteLead(int id) async {
    final db = await database;
    return await db.delete(
      'leads',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Export all leads as a pretty-printed JSON string
  Future<String> exportLeadsAsJson() async {
    final leads = await getAllLeads();
    final List<Map<String, dynamic>> leadsJson =
        leads.map((lead) => lead.toMap()).toList();

    // Convert to JSON with pretty printing (2 spaces indentation)
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(leadsJson);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
