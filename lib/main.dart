
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/injector.dart';
import 'features/expenses/domain/usecases/add_expense_uc.dart';
import 'features/expenses/domain/usecases/get_expenses_uc.dart';
import 'features/expenses/presentation/blocs/list_expenses/list_expenses_bloc.dart';
import 'features/expenses/presentation/blocs/add_expense/add_expense_bloc.dart';

import 'features/expenses/presentation/blocs/list_expenses/list_expenses_event.dart';
import 'features/expenses/presentation/pages/dashboard_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 13 Pro Max reference
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ListExpensesBloc(sl<GetExpensesUC>())..add(const LoadFirstPage()),
            ),
            BlocProvider(
              create: (_) => AddExpenseBloc(sl<AddExpenseUC>()),

            ),

          ],
          child: MaterialApp(
            title: 'Expense Tracker',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              scaffoldBackgroundColor: const Color(0xFFF8F9FB),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
            ),
            home: const DashboardPage(),
          ),
        );
      },
    );
  }
}
