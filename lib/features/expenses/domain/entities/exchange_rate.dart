import 'package:equatable/equatable.dart';

class ExchangeRate extends Equatable {
  final String baseCode;
  final double sar;
  final double egp;
  final double eur;
  final double usd;

  const ExchangeRate({
    required this.baseCode,
    required this.sar,
    required this.egp,
    required this.eur,
    required this.usd,
  });

  @override
  List<Object?> get props => [baseCode, sar, egp, eur, usd];
}
