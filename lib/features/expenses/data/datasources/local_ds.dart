import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/expense.dart';

class ExpenseDB {
  static final ExpenseDB _instance = ExpenseDB._internal();
  factory ExpenseDB() => _instance;
  ExpenseDB._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expenses.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT NOT NULL,
            amountOriginal REAL NOT NULL,
            currencyCode TEXT NOT NULL,
            amountUsd REAL NOT NULL,
            date TEXT NOT NULL,
            receiptPath TEXT
          )
        ''');
      },
    );
  }

  Future<int> insert(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', _toMap(expense));
  }

  Future<List<Expense>> fetchAll({
    required int page,
    required int pageSize,
  }) async {
    final db = await database;
    final offset = (page - 1) * pageSize;

    final rows = await db.query(
      'expenses',
      orderBy: 'date DESC',
      limit: pageSize,
      offset: offset,
    );

    return rows.map((r) => _fromMap(r)).toList();
  }

  Future<List<Expense>> fetchByDateRange({
    required int page,
    required int pageSize,
    DateTime? from,
    DateTime? to,
  }) async {
    final db = await database;
    final offset = (page - 1) * pageSize;

    String? where;
    List<String>? whereArgs;
    if (from != null && to != null) {
      where = 'date BETWEEN ? AND ?';
      whereArgs = [from.toIso8601String(), to.toIso8601String()];
    }

    final rows = await db.query(
      'expenses',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'date DESC',
      limit: pageSize,
      offset: offset,
    );

    return rows.map((r) => _fromMap(r)).toList();
  }

  Future<int> update(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      _toMap(expense),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getTotalUsd({DateTime? from, DateTime? to}) async {
    final db = await database;
    String where = '';
    List<String> args = [];
    if (from != null && to != null) {
      where = 'WHERE date BETWEEN ? AND ?';
      args = [from.toIso8601String(), to.toIso8601String()];
    }
    final res = await db.rawQuery(
      'SELECT SUM(amountUsd) as total FROM expenses $where',
      args,
    );
    final total = res.first['total'] as num?;
    return (total ?? 0).toDouble();
  }

  // helpers
  Map<String, dynamic> _toMap(Expense e) => {
        'id': e.id,
        'category': e.category,
        'amountOriginal': e.amountOriginal,
        'currencyCode': e.currencyCode,
        'amountUsd': e.amountUsd,
        'date': e.date.toIso8601String(),
        'receiptPath': e.receiptPath,
      };

  Expense _fromMap(Map<String, dynamic> m) => Expense(
        id: m['id'] as int?,
        category: m['category'] as String? ?? '',
        amountOriginal: (m['amountOriginal'] as num?)?.toDouble() ?? 0.0,
        currencyCode: m['currencyCode'] as String? ?? 'USD',
        amountUsd: (m['amountUsd'] as num?)?.toDouble() ?? 0.0,
        date: DateTime.tryParse(m['date'] as String? ?? '') ?? DateTime.now(),
        receiptPath: m['receiptPath'] as String?,
      );
}
