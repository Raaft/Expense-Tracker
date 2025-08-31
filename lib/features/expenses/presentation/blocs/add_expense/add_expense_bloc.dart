import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_expense_event.dart';
import 'add_expense_state.dart';
import '../../../domain/usecases/add_expense_uc.dart';
import '../../../domain/usecases/convert_currency_uc.dart';
import '../../../domain/usecases/get_categories_uc.dart';
import '../../../domain/entities/expense.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final AddExpenseUC addExpenseUC;
  final ConvertCurrencyUC convertCurrencyUC;
  final GetCategoriesUC getCategoriesUC;

  AddExpenseBloc({
    required this.addExpenseUC,
    required this.convertCurrencyUC,
    required this.getCategoriesUC,
  }) : super(const AddExpenseState()) {
    on<LoadCategories>(_onLoadCategories);
    on<CategorySelected>(_onCategorySelected);
    on<AmountChanged>(_onAmountChanged);
    on<CurrencyChanged>(_onCurrencyChanged);
    on<DateChanged>(_onDateChanged);
    on<ReceiptSelected>(_onReceiptSelected);
    on<NotesChanged>(_onNotesChanged);
    on<SaveExpense>(_onSaveExpense);
    on<ResetForm>(_onResetForm);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<AddExpenseState> emit) async {
    try {
      emit(state.copyWith(loading: true));
      final categories = await getCategoriesUC.call();
      emit(state.copyWith(
        loading: false,
        categories: categories,
      ));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: e.toString(),
      ));
    }
  }

  void _onCategorySelected(
      CategorySelected event, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(selectedCategory: event.category));
  }

  void _onAmountChanged(AmountChanged event, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(amount: event.amount));
  }

  void _onCurrencyChanged(
      CurrencyChanged event, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(selectedCurrency: event.currency));
  }

  void _onDateChanged(DateChanged event, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onReceiptSelected(
      ReceiptSelected event, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(receiptPath: event.receiptPath));
  }

  void _onNotesChanged(NotesChanged event, Emitter<AddExpenseState> emit) {
    emit(state.copyWith(notes: event.notes));
  }

  Future<void> _onSaveExpense(
      SaveExpense event, Emitter<AddExpenseState> emit) async {
    try {
      emit(state.copyWith(saving: true, error: null));

      // Validate form
      if (state.selectedCategory.isEmpty) {
        emit(state.copyWith(
          saving: false,
          error: 'Please select a category',
        ));
        return;
      }

      if (state.amount <= 0) {
        emit(state.copyWith(
          saving: false,
          error: 'Please enter a valid amount',
        ));
        return;
      }

      // Convert currency to USD
      double amountUsd = state.amount;
      if (state.selectedCurrency != 'USD') {
        amountUsd = await convertCurrencyUC.call(
          amount: state.amount,
          fromCurrency: state.selectedCurrency,
          toCurrency: 'USD',
        );
      }

      // Create expense
      final expense = Expense(
        category: state.selectedCategory,
        amountOriginal: state.amount,
        currencyCode: state.selectedCurrency,
        amountUsd: amountUsd,
        date: state.selectedDate ?? DateTime.now(),
        receiptPath: state.receiptPath,
        notes: state.notes,
      );

      await addExpenseUC.call(expense);

      emit(state.copyWith(
        saving: false,
        success: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        saving: false,
        error: e.toString(),
      ));
    }
  }

  void _onResetForm(ResetForm event, Emitter<AddExpenseState> emit) {
    emit(const AddExpenseState());
  }
}
