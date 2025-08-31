import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final int? id;
  final String category;
  final double amountOriginal;
  final String currencyCode;
  final double amountUsd;
  final DateTime date;
  final String? receiptPath;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Expense({
    this.id,
    required this.category,
    required this.amountOriginal,
    required this.currencyCode,
    required this.amountUsd,
    required this.date,
    this.receiptPath,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();

  @override
  List<Object?> get props => [
    id, 
    category, 
    amountOriginal, 
    currencyCode, 
    amountUsd, 
    date, 
    receiptPath, 
    notes,
    createdAt,
    updatedAt
  ];

  Expense copyWith({
    int? id,
    String? category,
    double? amountOriginal,
    String? currencyCode,
    double? amountUsd,
    DateTime? date,
    String? receiptPath,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      category: category ?? this.category,
      amountOriginal: amountOriginal ?? this.amountOriginal,
      currencyCode: currencyCode ?? this.currencyCode,
      amountUsd: amountUsd ?? this.amountUsd,
      date: date ?? this.date,
      receiptPath: receiptPath ?? this.receiptPath,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
