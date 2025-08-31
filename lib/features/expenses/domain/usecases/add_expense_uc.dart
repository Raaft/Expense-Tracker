import '../entities/expense.dart';

import '../repositories/expenses_repo.dart';

class AddExpenseUC {
  final ExpensesRepo repo;
  AddExpenseUC(this.repo);

  Future<void> call(Expense e) => repo.addExpense(e);
}
