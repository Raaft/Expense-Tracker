import '../../domain/entities/exchange_rate.dart';

class ExchangeRateModel extends ExchangeRate {
  const ExchangeRateModel({
    required super.baseCode,
    required super.sar,
    required super.egp,
    required super.eur,
    required super.usd,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {

    final Map<String, dynamic> rates =
    Map<String, dynamic>.from(json['rates'] ?? {});

    return ExchangeRateModel(
      baseCode: json['base_code'] ?? '',
      sar: (rates['SAR'] as num?)?.toDouble() ?? 0.0,
      egp: (rates['EGP'] as num?)?.toDouble() ?? 0.0,
      eur: (rates['EUR'] as num?)?.toDouble() ?? 0.0,
      usd: (rates['USD'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
