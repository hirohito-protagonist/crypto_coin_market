import 'package:test/test.dart';
import 'dart:convert';
import 'package:crypto_coin_market/crypto_compare.service.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {

  group('volumeData', () {

    test('success response should be map to TotalVolume collection model', () async {

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


      when(client.get('https://min-api.cryptocompare.com/data/top/totalvol?limit=2000&tsym=USD'))
        .thenAnswer((_) async => http.Response(json.encode(response), 200));

      final data = await volumeData(client);
      expect(data.length, 1);
      expect(data[0].coinInfo.name, 'BTC');
      expect(data[0].coinInfo.imageUrl, 'https://www.cryptocompare.com/btc.png');
    });

    test('error response should return empty collection', () async {

      final client = MockClient();
      when(client.get('https://min-api.cryptocompare.com/data/top/totalvol?limit=2000&tsym=USD'))
          .thenAnswer((_) async => http.Response('', 500));

      final data = await volumeData(client);
      expect(data.length, 0);
    });

    test('parse error resposne should return empty collection', () async {

      final client = MockClient();
      when(client.get('https://min-api.cryptocompare.com/data/top/totalvol?limit=2000&tsym=USD'))
          .thenAnswer((_) async => http.Response('', 200));

      final data = await volumeData(client);
      expect(data.length, 0);
    });
  });
}