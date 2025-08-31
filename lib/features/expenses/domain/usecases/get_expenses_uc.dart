import '../entities/expense.dart';
import '../repositories/expenses_repo.dart';

class GetExpensesUC {
  final ExpensesRepo repo;
  GetExpensesUC(this.repo);

  Future<List<Expense>> call({
    required int page,
    required int pageSize,
    DateTime? from,
    DateTime? to,
    String? category,
  }) {
    return repo.getExpenses(
      page: page,
      pageSize: pageSize,
      from: from,
      to: to,
      category: category,
    );
  }
}
