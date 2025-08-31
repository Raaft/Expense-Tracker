
import '../../domain/entities/expense.dart';

abstract class ExpensesRepo {




  Future<void> addExpense(Expense e) ;


  Future<List<Expense>> getExpenses({required int page, required int pageSize, DateTime? from, DateTime? to});
  Future<double> getTotalUsd({DateTime? from, DateTime? to});


}
