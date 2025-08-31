import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_summary.dart';
import '../../domain/entities/currency_rate.dart';
import '../../domain/repositories/expenses_repo.dart';
import '../models/expense_model.dart';
import '../../../../core/db/database_helper.dart';
import '../../../../core/services/currency_service.dart';

class ExpensesRepoImpl implements ExpensesRepo {
  final DatabaseHelper _dbHelper;
  final CurrencyService _currencyService;

  ExpensesRepoImpl({
    required DatabaseHelper dbHelper,
    required CurrencyService currencyService,
  })  : _dbHelper = dbHelper,
        _currencyService = currencyService;

  @override
  Future<void> addExpense(Expense expense) async {
    final expenseModel = ExpenseModel.fromEntity(expense);
    await _dbHelper.insertExpense(expenseModel);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final expenseModel = ExpenseModel.fromEntity(expense);
    await _dbHelper.updateExpense(expenseModel);
  }

  @override
  Future<void> deleteExpense(int id) async {
    await _dbHelper.deleteExpense(id);
  }

  @override
  Future<Expense?> getExpenseById(int id) async {
    final expenseModel = await _dbHelper.getExpenseById(id);
    return expenseModel?.toEntity();
  }

  @override
  Future<List<Expense>> getExpenses({
    required int page,
    required int pageSize,
    DateTime? from,
    DateTime? to,
    String? category,
  }) async {
    final expenseModels = await _dbHelper.getExpenses(
      page: page,
      pageSize: pageSize,
      from: from,
      to: to,
      category: category,
    );

    return expenseModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ExpenseSummary> getExpenseSummary({
    DateTime? from,
    DateTime? to,
    String? category,
  }) async {
    final summary = await _dbHelper.getExpenseSummary(
      from: from,
      to: to,
      category: category,
    );

    return ExpenseSummary(
      totalBalance: summary['total_amount'] ?? 0.0,
      totalIncome: summary['total_income'] ?? 0.0,
      totalExpenses: summary['total_expenses'] ?? 0.0,
      currency: 'USD',
      fromDate: from ?? DateTime.now().subtract(const Duration(days: 30)),
      toDate: to ?? DateTime.now(),
      totalTransactions: summary['total_transactions'] ?? 0,
    );
  }

  @override
  Future<double> getTotalUsd({DateTime? from, DateTime? to}) async {
    final summary = await _dbHelper.getExpenseSummary(from: from, to: to);
    return summary['total_amount'] ?? 0.0;
  }

  @override
  Future<double> getTotalIncome({DateTime? from, DateTime? to}) async {
    final summary = await _dbHelper.getExpenseSummary(from: from, to: to);
    return summary['total_income'] ?? 0.0;
  }

  @override
  Future<double> getTotalExpenses({DateTime? from, DateTime? to}) async {
    final summary = await _dbHelper.getExpenseSummary(from: from, to: to);
    return summary['total_expenses'] ?? 0.0;
  }

  @override
  Future<CurrencyRate> getCurrencyRate(
      String fromCurrency, String toCurrency) async {
    final rate =
        await _currencyService.convertCurrency(1.0, fromCurrency, toCurrency);
    return CurrencyRate(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      rate: rate,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<double> convertCurrency(
    double amount,
    String fromCurrency,
    String toCurrency,
  ) async {
    return await _currencyService.convertCurrency(
        amount, fromCurrency, toCurrency);
  }

  @override
  Future<List<String>> getCategories() async {
    return await _dbHelper.getCategories();
  }

  @override
  Future<void> addCategory(String category) async {
    await _dbHelper.addCategory(category);
  }

  @override
  Future<String> saveReceipt(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final receiptsDir = Directory('${directory.path}/receipts');

    if (!await receiptsDir.exists()) {
      await receiptsDir.create(recursive: true);
    }

    final fileName = path.basename(filePath);
    final newPath = '${receiptsDir.path}/$fileName';

    final file = File(filePath);
    await file.copy(newPath);

    return newPath;
  }

  @override
  Future<void> deleteReceipt(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
