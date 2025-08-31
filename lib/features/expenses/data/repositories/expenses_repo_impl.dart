
import '../../domain/repositories/expenses_repo.dart';
import '../datasources/local_ds.dart';
import '../datasources/remote_data_source.dart';
import '../../domain/entities/expense.dart';
import '../models/expense_model.dart';

class ExpensesRepoImpl  extends ExpensesRepo{
  final ExpenseDB local;
  final ExchangeRateRemoteDataSource remote;

  ExpensesRepoImpl({required this.local, required this.remote});

  Future<void> addExpense(Expense e) async {
try{    final code = e.currencyCode.toUpperCase();
final toUsd = await remote.getExchangeRates(code);

final usdAmount = e.amountOriginal / toUsd;
final model = ExpenseModel(
  category: e.category,
  amountOriginal: e.amountOriginal,
  currencyCode: code,
  amountUsd: usdAmount,
  date: e.date,
  receiptPath: e.receiptPath,
);
print ('model =>>${model}');
await local.insert(model);
}
catch(e) {
  rethrow;
}
  }

  Future<List<Expense>> getExpenses({required int page, required int pageSize, DateTime? from, DateTime? to}) {
    return local.fetchByDateRange(page: page, pageSize: pageSize, from: from, to: to);
  }

  Future<double> getTotalUsd({DateTime? from, DateTime? to}) => local.getTotalUsd(from: from, to: to);
}
