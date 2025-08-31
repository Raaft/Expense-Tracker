
import 'package:equatable/equatable.dart';

class SubmitExpense extends Equatable {
  final String category;
  final double amount;
  final String currencyCode;
  final DateTime date;
  final String? receiptPath;

  const SubmitExpense({
    required this.category,
    required this.amount,
    required this.currencyCode,
    required this.date,
    this.receiptPath,
  });

  @override
  List<Object?> get props => [category, amount, currencyCode, date, receiptPath];
}
