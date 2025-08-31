import 'package:dio/dio.dart';

import '../models/exchange_rate_mode.dart';

abstract class ExchangeRateRemoteDataSource {
  Future<double> getExchangeRates(String countryCode);
}

class ExchangeRateRemoteDataSourceImpl implements ExchangeRateRemoteDataSource {
  final Dio dio;

  ExchangeRateRemoteDataSourceImpl(this.dio);

  @override
  Future<double> getExchangeRates(String countryCode) async {
    try {
      Response response = await dio.get(
        'https://open.er-api.com/v6/latest/USD',
      );

      if (response.statusCode == 200) {
        print('data =>  ${response.data}');
        ExchangeRateModel model = ExchangeRateModel.fromJson(response.data);

        switch (countryCode.toUpperCase()) {
          case "SAR":
            return model.sar;
          case "EGP":
            return model.egp;
          case "EUR":
            return model.eur;
          case "USD":
            return model.usd;
          default:
            throw Exception('Country code $countryCode not supported');
        }
      } else {
        throw Exception('Failed to fetch exchange rates');
      }
    } catch (e) {
      // throw Exception('Error fetching exchange rates: $e');
      rethrow;
    }
  }
}
