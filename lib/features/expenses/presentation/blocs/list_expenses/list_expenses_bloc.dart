import 'package:flutter_bloc/flutter_bloc.dart';
import 'list_expenses_event.dart';
import 'list_expenses_state.dart';
import '../../../domain/usecases/get_expenses_uc.dart';

class ListExpensesBloc extends Bloc<ListExpensesEvent, ListExpensesState> {
  final GetExpensesUC getExpenses;
  static const int pageSize = 10;
  int _page = 1;
  DateTime? _from;
  DateTime? _to;

  ListExpensesBloc(this.getExpenses) : super(const ListExpensesState()) {
    on<LoadFirstPage>(_onLoadFirst);
    on<LoadNextPage>(_onLoadNext);
  }

  Future<void> _onLoadFirst(LoadFirstPage e, Emitter<ListExpensesState> emit) async {
    emit(state.copyWith(loading: true, items: [], hasMore: true, error: null));
    _page = 1;
    _from = e.from;
    _to = e.to;
    try {
      final items = await getExpenses.call(page: _page, pageSize: pageSize, from: _from, to: _to);
      emit(state.copyWith(loading: false, items: items, hasMore: items.length == pageSize));
    } catch (ex) {
      emit(state.copyWith(loading: false, error: ex.toString()));
    }
  }

  Future<void> _onLoadNext(LoadNextPage e, Emitter<ListExpensesState> emit) async {
    if (!state.hasMore || state.loading) return;
    emit(state.copyWith(loading: true));
    _page++;
    try {
      final next = await getExpenses.call(page: _page, pageSize: pageSize, from: _from, to: _to);
      emit(state.copyWith(loading: false, items: [...state.items, ...next], hasMore: next.length == pageSize));
    } catch (ex) {
      emit(state.copyWith(loading: false, error: ex.toString()));
    }
  }
}
