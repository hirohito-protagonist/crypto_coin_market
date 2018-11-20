import 'package:test/test.dart';
import 'dart:convert';
import 'package:crypto_coin_market/model/currency.model.dart';
import 'package:crypto_coin_market/services/histogram.service.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class HistogramServiceTestData {

  final String name;
  final String url;

  HistogramServiceTestData({this.name, this.url});

  resolveMethod(HistogramService service) {
    final methods = {
      'daily': service.daily,
      'hourly': service.hourly,
      'minute': service.minute
    };
    return methods[name];
  }
}

void main() {

  final testData = [
    HistogramServiceTestData(
      name: 'daily',
      url: 'https://min-api.cryptocompare.com/data/histoday?fsym=BTC&tsym=USD&limit=100&aggregate=2'
    ),
    HistogramServiceTestData(
      name: 'hourly',
      url: 'https://min-api.cryptocompare.com/data/histohour?fsym=BTC&tsym=USD&limit=100&aggregate=2'
    ),
    HistogramServiceTestData(
      name: 'minute',
      url: 'https://min-api.cryptocompare.com/data/histominute?fsym=BTC&tsym=USD&limit=100&aggregate=2'
    )
  ];

  testData.forEach((tData) {

    group(tData.name, () {

      test('success response should map to model', () async {

        // Given
        final client = MockClient();
        final service = HistogramService(client: client);
        final serviceMethod = tData.resolveMethod(service);
        final response = {
          'Data': [
            { 'close': 1, 'high': 1, 'low': 1, 'open': 1, 'time': 1542555162, 'volumefrom': 1, 'volumeto': 1 },
            { 'close': 2, 'high': 2, 'low': 2, 'open': 2, 'time': 1542555162, 'volumefrom': 2, 'volumeto': 2 }
          ]
        };

        // When
        when(client.get(tData.url))
            .thenAnswer((_) async => http.Response(json.encode(response), 200));
        final result = await serviceMethod(Currency.fromCurrencyCode('USD'), 'BTC', 100, 2);

        // Then
        expect(result.length, 2);
        expect(result[1].time.toIso8601String(), '2018-11-18T16:32:42.000');
        expect(result[1].close, 2);
        expect(result[1].volumeFrom, 2);
        expect(result[1].volumeTo, 2);
        expect(result[1].high, 2);
        expect(result[1].low, 2);
        expect(result[1].open, 2);
      });

      test('exception of deserialization json should return default model', () async {

        // Given
        final client = MockClient();
        final service = HistogramService(client: client);
        final serviceMethod = tData.resolveMethod(service);
        // When
        when(client.get(tData.url))
            .thenAnswer((_) async => http.Response('test', 200));
        final result = await serviceMethod(Currency.fromCurrencyCode('USD'), 'BTC', 100, 2);

        // Then
        expect(result.length, 0);
      });

      test('error response server should return default model', () async {

        // Given
        final client = MockClient();
        final service = HistogramService(client: client);
        final serviceMethod = tData.resolveMethod(service);

        // When
        when(client.get(tData.url))
            .thenAnswer((_) async => http.Response(json.encode({}), 500));
        final result = await serviceMethod(Currency.fromCurrencyCode('USD'), 'BTC', 100, 2);

        // Then
        expect(result.length, 0);
      });
    });
  });
}