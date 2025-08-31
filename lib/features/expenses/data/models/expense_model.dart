
import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    int? id,
    required String category,
    required double amountOriginal,
    required String currencyCode,
    required double amountUsd,
    required DateTime date,
    String? receiptPath,
  }) : super(
    id: id,
    category: category,
    amountOriginal: amountOriginal,
    currencyCode: currencyCode,
    amountUsd: amountUsd,
    date: date,
    receiptPath: receiptPath,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'category': category,
    'amount_original': amountOriginal,
    'currency_code': currencyCode,
    'amount_usd': amountUsd,
    'date_iso': date.toIso8601String(),
    'receipt_path': receiptPath,
  };

  factory ExpenseModel.fromMap(Map<String, Object?> m) => ExpenseModel(
    id: m['id'] as int?,
    category: m['category'] as String,
    amountOriginal: (m['amount_original'] as num).toDouble(),
    currencyCode: m['currency_code'] as String,
    amountUsd: (m['amount_usd'] as num).toDouble(),
    date: DateTime.parse(m['date_iso'] as String),
    receiptPath: m['receipt_path'] as String?,
  );
}
