import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:crypto_coin_market/data_source/data_source.dart';
import 'package:crypto_coin_market/data_source/services/uri.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {

  final priceMultiUri = UriService().priceMultiFull({
    'fsyms': 'BTC,ETC',
    'tsyms': 'USD'
  });

  group('multipleSymbolsFullData', () {

    var response;
    var client;

    setUp(() {
      client = MockClient();
      response = {
        'RAW': {
          'BTC': {
            'PRICE': 1000
          },
          'ETC': {
            'PRICE': 2000
          }
        },
        'DISPLAY': {
          'BTC': {
            'PRICE': '\$ 1000'
          },
          'ETC': {
            'PRICE': '\$ 2000'
          }
        }
      };
    });

    test('success response should map to model', () async {

      // Given
      final service = PriceService(client: client);

      // When
      when(client.get(priceMultiUri))
          .thenAnswer((_) async => http.Response(json.encode(response), 200));

      final data = await service.multipleSymbolsFullData(['BTC', 'ETC'], Currency.fromCurrencyCode('USD'));

      // Then
      expect(data.raw, response['RAW']);
      expect(data.display, response['DISPLAY']);
    });

    test('exception of deserialization json should return default model', () async {

      // Given
      final service = PriceService(client: client);

      // When
      when(client.get(priceMultiUri))
          .thenAnswer((_) async => http.Response('test', 200));

      final data = await service.multipleSymbolsFullData(['BTC', 'ETC'], Currency.fromCurrencyCode('usd'));

      // Then
      expect(data.raw, {});
      expect(data.display, {});
    });

    test('error response server should return default model', () async {

      // Given
      final service = PriceService(client: client);

      // When
      when(client.get(priceMultiUri))
          .thenAnswer((_) async => http.Response(json.encode(response), 500));

      final data = await service.multipleSymbolsFullData(['BTC', 'ETC'], Currency.fromCurrencyCode('USD'));

      // Then
      expect(data.raw, {});
      expect(data.display, {});
    });
  });
}