import 'package:equatable/equatable.dart';

class AddExpenseState extends Equatable {
  final bool loading;
  final bool saving;
  final bool success;
  final String error;
  final List<String> categories;
  final String selectedCategory;
  final double amount;
  final String selectedCurrency;
  final DateTime? selectedDate;
  final String? receiptPath;
  final String notes;

  const AddExpenseState({
    this.loading = false,
    this.saving = false,
    this.success = false,
    this.error = '',
    this.categories = const [],
    this.selectedCategory = '',
    this.amount = 0.0,
    this.selectedCurrency = 'USD',
    this.selectedDate,
    this.receiptPath,
    this.notes = '',
  });

  AddExpenseState copyWith({
    bool? loading,
    bool? saving,
    bool? success,
    String? error,
    List<String>? categories,
    String? selectedCategory,
    double? amount,
    String? selectedCurrency,
    DateTime? selectedDate,
    String? receiptPath,
    String? notes,
  }) {
    return AddExpenseState(
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      success: success ?? this.success,
      error: error ?? this.error,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      amount: amount ?? this.amount,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      selectedDate: selectedDate ?? this.selectedDate,
      receiptPath: receiptPath ?? this.receiptPath,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        saving,
        success,
        error,
        categories,
        selectedCategory,
        amount,
        selectedCurrency,
        selectedDate,
        receiptPath,
        notes,
      ];
}
