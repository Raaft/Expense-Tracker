
import 'package:equatable/equatable.dart';

abstract class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends AddExpenseEvent {}

class CategorySelected extends AddExpenseEvent {
  final String category;

  const CategorySelected(this.category);

  @override
  List<Object?> get props => [category];
}

class AmountChanged extends AddExpenseEvent {
  final double amount;

  const AmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

class CurrencyChanged extends AddExpenseEvent {
  final String currency;

  const CurrencyChanged(this.currency);

  @override
  List<Object?> get props => [currency];
}

class DateChanged extends AddExpenseEvent {
  final DateTime date;

  const DateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

class ReceiptSelected extends AddExpenseEvent {
  final String receiptPath;

  const ReceiptSelected(this.receiptPath);

  @override
  List<Object?> get props => [receiptPath];
}

class NotesChanged extends AddExpenseEvent {
  final String notes;

  const NotesChanged(this.notes);

  @override
  List<Object?> get props => [notes];
}

class SaveExpense extends AddExpenseEvent {}

class ResetForm extends AddExpenseEvent {}
