import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injector.dart';
import 'features/expenses/presentation/pages/dashboard_page.dart';
import 'features/expenses/presentation/blocs/list_expenses/list_expenses_bloc.dart';
import 'features/expenses/presentation/blocs/list_expenses/list_expenses_event.dart';
import 'features/expenses/presentation/blocs/add_expense/add_expense_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Expense Tracker',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: const Color(0xFF246BFD),
            scaffoldBackgroundColor: const Color(0xFFF0F4FA),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF246BFD),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF246BFD),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
          home: MultiBlocProvider(
            providers: [
              BlocProvider<ListExpensesBloc>(
                create: (context) =>
                    getIt<ListExpensesBloc>()..add(const LoadFirstPage()),
              ),
              BlocProvider<AddExpenseBloc>(
                create: (context) => getIt<AddExpenseBloc>(),
              ),
            ],
            child: const DashboardPage(),
          ),
        );
      },
    );
  }
}
