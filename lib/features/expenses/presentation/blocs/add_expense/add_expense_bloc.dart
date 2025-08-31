
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_expense_uc.dart';
import '../../../domain/entities/expense.dart';
import 'add_expense_event.dart';
import 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<SubmitExpense, AddExpenseState> {
  final AddExpenseUC addExpenseUC;

  AddExpenseBloc(this.addExpenseUC) : super(const AddExpenseState()) {
    on<SubmitExpense>(_onSubmit);
  }

  Future<void> _onSubmit(SubmitExpense e, Emitter<AddExpenseState> emit) async {
    emit(state.copyWith(saving: true, success: false, error: null));
    try {
      await addExpenseUC.call(Expense(
        category: e.category,
        amountOriginal: e.amount,
        currencyCode: e.currencyCode,
        amountUsd: 10,
        date: e.date,
        receiptPath: e.receiptPath,
      ));
      emit(state.copyWith(saving: false, success: true));
    } catch (ex) {
      emit(state.copyWith(saving: false, success: false, error: ex.toString()));
      rethrow;
    }
  }
}
