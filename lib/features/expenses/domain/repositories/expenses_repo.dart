import '../entities/expense.dart';
import '../entities/expense_summary.dart';
import '../entities/currency_rate.dart';

abstract class ExpensesRepo {
  // Expense CRUD operations
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(int id);
  Future<Expense?> getExpenseById(int id);
  Future<List<Expense>> getExpenses({
    required int page,
    required int pageSize,
    DateTime? from,
    DateTime? to,
    String? category,
  });

  // Summary and totals
  Future<ExpenseSummary> getExpenseSummary({
    DateTime? from,
    DateTime? to,
    String? category,
  });
  Future<double> getTotalUsd({DateTime? from, DateTime? to});
  Future<double> getTotalIncome({DateTime? from, DateTime? to});
  Future<double> getTotalExpenses({DateTime? from, DateTime? to});

  // Currency conversion
  Future<CurrencyRate> getCurrencyRate(String fromCurrency, String toCurrency);
  Future<double> convertCurrency(
      double amount, String fromCurrency, String toCurrency);

  // Categories
  Future<List<String>> getCategories();
  Future<void> addCategory(String category);

  // Receipt management
  Future<String> saveReceipt(String filePath);
  Future<void> deleteReceipt(String filePath);
}
