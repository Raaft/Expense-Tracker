import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../../features/expenses/data/datasources/local_ds.dart';
import '../../features/expenses/data/datasources/remote_data_source.dart';
import '../../features/expenses/data/repositories/expenses_repo_impl.dart';
import '../../features/expenses/domain/usecases/add_expense_uc.dart';
import '../../features/expenses/domain/usecases/get_expenses_uc.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // Dio
  sl.registerLazySingleton<Dio>(() => DioClient.build());

  // DB

  // Data sources
  sl.registerLazySingleton<ExpenseDB>(() => ExpenseDB());
  sl.registerLazySingleton<ExchangeRateRemoteDataSource>(() => ExchangeRateRemoteDataSourceImpl(sl<Dio>()));

  // Repo
  sl.registerLazySingleton<ExpensesRepoImpl>(() => ExpensesRepoImpl(
    local: sl<ExpenseDB>(),
    remote: sl<ExchangeRateRemoteDataSource>(),
  ));

  // Usecases
  sl.registerLazySingleton(() => GetExpensesUC(sl<ExpensesRepoImpl>()));
  sl.registerLazySingleton(() => AddExpenseUC(sl<ExpensesRepoImpl>()));

}
