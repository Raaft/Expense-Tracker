import '../entities/expense.dart';
import '../repositories/expenses_repo.dart';

class AddExpenseUC {
  final ExpensesRepo repo;
  AddExpenseUC(this.repo);

  Future<void> call(Expense expense) async {
    // Convert currency to USD if not already in USD
    double amountUsd = expense.amountUsd;
    if (expense.currencyCode != 'USD') {
      amountUsd = await repo.convertCurrency(
        expense.amountOriginal,
        expense.currencyCode,
        'USD',
      );
    }

    final expenseWithUsd = expense.copyWith(amountUsd: amountUsd);
    await repo.addExpense(expenseWithUsd);
  }
}
