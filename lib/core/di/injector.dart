import 'package:get_it/get_it.dart';
import '../db/database_helper.dart';
import '../services/currency_service.dart';
import '../../features/expenses/domain/repositories/expenses_repo.dart';
import '../../features/expenses/data/repositories/expenses_repo_impl.dart';
import '../../features/expenses/domain/usecases/get_expenses_uc.dart';
import '../../features/expenses/domain/usecases/add_expense_uc.dart';
import '../../features/expenses/domain/usecases/get_expense_summary_uc.dart';
import '../../features/expenses/domain/usecases/convert_currency_uc.dart';
import '../../features/expenses/domain/usecases/get_categories_uc.dart';
import '../../features/expenses/presentation/blocs/list_expenses/list_expenses_bloc.dart';
import '../../features/expenses/presentation/blocs/add_expense/add_expense_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Core
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  getIt.registerLazySingleton<CurrencyService>(() => CurrencyService());

  // Repositories
  getIt.registerLazySingleton<ExpensesRepo>(
    () => ExpensesRepoImpl(
      dbHelper: getIt(),
      currencyService: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetExpensesUC(getIt()));
  getIt.registerLazySingleton(() => AddExpenseUC(getIt()));
  getIt.registerLazySingleton(() => GetExpenseSummaryUC(getIt()));
  getIt.registerLazySingleton(() => ConvertCurrencyUC(getIt()));
  getIt.registerLazySingleton(() => GetCategoriesUC(getIt()));

  // BLoCs
  getIt.registerFactory(() => ListExpensesBloc(getIt()));
  getIt.registerFactory(() => AddExpenseBloc(
        addExpenseUC: getIt(),
        convertCurrencyUC: getIt(),
        getCategoriesUC: getIt(),
      ));
}
