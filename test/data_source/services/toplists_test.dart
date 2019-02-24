import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto_coin_market/data_source/data_source.dart';
import 'package:crypto_coin_market/data_source/services/uri.dart';
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

void main() {

  final topListUrl = UriService().totalVolume({
    'limit': '100',
    'tsym': 'USD',
    'page': '0'
  });

  group('totalVolume', () {

    test('success response should be map to TotalVolume collection model', () async {

      // Given
      final client = MockClient();
      final response = {
        'Data': [
          {
            'CoinInfo': {
              'Name': 'BTC',
              'ImageUrl': '/btc.png'
            }
          }
        ]
      };
      final service = TopListsService(client: client);

      // When
      when(client.get(topListUrl))
          .thenAnswer((_) async => http.Response(json.encode(response), 200));

      final data = await service.totalVolume(Currency.fromCurrencyCode('USD'));

      // Then
      expect(data.length, 1);
      expect(data[0].coinInfo.name, 'BTC');
      expect(data[0].coinInfo.imageUrl, 'https://www.cryptocompare.com/btc.png');
    });

    test('error response should return empty collection', () async {

      // Given
      final client = MockClient();
      final service = TopListsService(client: client);

      // When
      when(client.get(topListUrl))
          .thenAnswer((_) async => http.Response('', 500));

      final data = await service.totalVolume(Currency.fromCurrencyCode('USD'));

      // Then
      expect(data.length, 0);
    });

    test('parse error resposne should return empty collection', () async {

      // Given
      final client = MockClient();
      final service = TopListsService(client: client);

      // When
      when(client.get(topListUrl))
          .thenAnswer((_) async => http.Response('', 200));
      final data = await service.totalVolume(Currency.fromCurrencyCode('USD'));

      // Then
      expect(data.length, 0);
    });
  });

}