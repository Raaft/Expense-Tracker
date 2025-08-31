import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/expense.dart';

part 'expense_model.g.dart';

@JsonSerializable()
class ExpenseModel {
  final int? id;
  final String category;
  final double amountOriginal;
  final String currencyCode;
  final double amountUsd;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime date;
  final String? receiptPath;
  final String? notes;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime updatedAt;

  ExpenseModel({
    this.id,
    required this.category,
    required this.amountOriginal,
    required this.currencyCode,
    required this.amountUsd,
    required this.date,
    this.receiptPath,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      category: expense.category,
      amountOriginal: expense.amountOriginal,
      currencyCode: expense.currencyCode,
      amountUsd: expense.amountUsd,
      date: expense.date,
      receiptPath: expense.receiptPath,
      notes: expense.notes,
      createdAt: expense.createdAt,
      updatedAt: expense.updatedAt,
    );
  }

  Expense toEntity() {
    return Expense(
      id: id,
      category: category,
      amountOriginal: amountOriginal,
      currencyCode: currencyCode,
      amountUsd: amountUsd,
      date: date,
      receiptPath: receiptPath,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static DateTime _dateFromJson(String date) => DateTime.parse(date);
  static String _dateToJson(DateTime date) => date.toIso8601String();
}
