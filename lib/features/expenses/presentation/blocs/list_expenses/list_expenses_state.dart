import 'package:equatable/equatable.dart';
import '../../../domain/entities/expense.dart';

class ListExpensesState extends Equatable {
  final bool loading;
  final List<Expense> items;
  final bool hasMore;
  final String? error;

  const ListExpensesState({this.loading = false, this.items = const [], this.hasMore = true, this.error});

  ListExpensesState copyWith({bool? loading, List<Expense>? items, bool? hasMore, String? error}) {
    return ListExpensesState(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, items, hasMore, error];
}
