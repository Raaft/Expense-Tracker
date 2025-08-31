import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final int? id;
  final String category;
  final double amountOriginal;
  final String currencyCode;
  final double amountUsd;
  final DateTime date;
  final String? receiptPath;

  const Expense({
    this.id,
    required this.category,
    required this.amountOriginal,
    required this.currencyCode,
    required this.amountUsd,
    required this.date,
    this.receiptPath,
  });

  @override
  List<Object?> get props => [id, category, amountOriginal, currencyCode, amountUsd, date, receiptPath];
}
