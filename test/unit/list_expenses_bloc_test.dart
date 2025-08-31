import 'package:bloc_test/bloc_test.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_expenses_uc.dart';
import 'package:expense_tracker/features/expenses/presentation/blocs/list_expenses/list_expenses_bloc.dart';
import 'package:expense_tracker/features/expenses/presentation/blocs/list_expenses/list_expenses_event.dart';
import 'package:expense_tracker/features/expenses/presentation/blocs/list_expenses/list_expenses_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetExpensesUC extends Mock implements GetExpensesUC {}

void main() {
  late MockGetExpensesUC mockGetExpensesUC;
  late ListExpensesBloc bloc;

  // fake test data
  final expensesPage1 = List.generate(
    10,
    (i) => Expense(
      id: i,
      category: 'Food',
      amountOriginal: 100.0,
      currencyCode: 'EGP',
      amountUsd: 3.0,
      date: DateTime(2025, 1, 1),
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    ),
  );

  final expensesPage2 = List.generate(
    5,
    (i) => Expense(
      id: i + 10,
      category: 'Transport',
      amountOriginal: 200.0,
      currencyCode: 'EGP',
      amountUsd: 6.0,
      date: DateTime(2025, 1, 2),
      createdAt: DateTime(2025, 1, 2),
      updatedAt: DateTime(2025, 1, 2),
    ),
  );

  setUp(() {
    mockGetExpensesUC = MockGetExpensesUC();
    bloc = ListExpensesBloc(mockGetExpensesUC);
  });

  tearDown(() {
    bloc.close();
  });

  group('LoadFirstPage', () {
    blocTest<ListExpensesBloc, ListExpensesState>(
      'emits [loading, loaded with items] when success',
      build: () {
        when(() => mockGetExpensesUC.call(
              page: 1,
              pageSize: ListExpensesBloc.pageSize,
              from: any(named: 'from'),
              to: any(named: 'to'),
            )).thenAnswer((_) async => expensesPage1);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadFirstPage()),
      expect: () => [
        const ListExpensesState(
            loading: true, items: [], hasMore: true, error: null),
        ListExpensesState(
            loading: false, items: expensesPage1, hasMore: false, error: null),
      ],
    );

    blocTest<ListExpensesBloc, ListExpensesState>(
      'emits [loading, error] when exception occurs',
      build: () {
        when(() => mockGetExpensesUC.call(
              page: 1,
              pageSize: ListExpensesBloc.pageSize,
              from: any(named: 'from'),
              to: any(named: 'to'),
            )).thenThrow(Exception('network error'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadFirstPage()),
      expect: () => [
        const ListExpensesState(
            loading: true, items: [], hasMore: true, error: null),
        const ListExpensesState(
            loading: false,
            items: [],
            hasMore: true,
            error: 'Exception: network error'),
      ],
    );
  });

  group('LoadNextPage', () {
    blocTest<ListExpensesBloc, ListExpensesState>(
      'emits [loading, append next page] when hasMore=true',
      build: () {
        // First page returns exactly pageSize items, so hasMore will be true
        when(() => mockGetExpensesUC.call(
                  page: 1,
                  pageSize: ListExpensesBloc.pageSize,
                  from: any(named: 'from'),
                  to: any(named: 'to'),
                ))
            .thenAnswer((_) async => expensesPage1); // Return exactly 10 items

        when(() => mockGetExpensesUC.call(
              page: 2,
              pageSize: ListExpensesBloc.pageSize,
              from: any(named: 'from'),
              to: any(named: 'to'),
            )).thenAnswer((_) async => expensesPage2);

        return bloc;
      },
      act: (bloc) async {
        bloc.add(const LoadFirstPage());
        await Future.delayed(Duration.zero); // wait for first page done
        bloc.add(LoadNextPage());
      },
      expect: () => [
        const ListExpensesState(
            loading: true, items: [], hasMore: true, error: null),
        ListExpensesState(
            loading: false, items: expensesPage1, hasMore: true, error: null),
        ListExpensesState(
            loading: true, items: expensesPage1, hasMore: true, error: null),
        ListExpensesState(
          loading: false,
          items: [...expensesPage1, ...expensesPage2],
          hasMore: false,
          error: null,
        ),
      ],
    );

    blocTest<ListExpensesBloc, ListExpensesState>(
      'does not emit when hasMore=false',
      build: () => bloc,
      seed: () => const ListExpensesState(
        loading: false,
        items: [],
        hasMore: false,
      ),
      act: (bloc) => bloc.add(LoadNextPage()),
      expect: () => [],
    );
  });
}
