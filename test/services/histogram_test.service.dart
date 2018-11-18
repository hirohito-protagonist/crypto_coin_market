import 'package:test/test.dart';
import 'dart:convert';
import 'package:crypto_coin_market/model/currency.model.dart';
import 'package:crypto_coin_market/services/histogram.service.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {

  group('daily', () {

    test('success response should map to model', () async {

      // Given
      final client = MockClient();
      final service = HistogramService(client: client);
      final response = {
        'Data': [
          { 'close': 1, 'high': 1, 'low': 1, 'open': 1, 'time': 1542555162, 'volumefrom': 1, 'volumeto': 1 },
          { 'close': 2, 'high': 2, 'low': 2, 'open': 2, 'time': 1542555162, 'volumefrom': 2, 'volumeto': 2 }
        ]
      };

      // When
      when(client.get('https://min-api.cryptocompare.com/data/histoday?fsym=BTC&tsym=USD&limit=100&aggregate=2'))
          .thenAnswer((_) async => http.Response(json.encode(response), 200));
      final result = await service.daily(Currency.fromCurrencyCode('USD'), 'BTC', 100, 2);

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

      // When
      when(client.get('https://min-api.cryptocompare.com/data/histoday?fsym=BTC&tsym=USD&limit=100&aggregate=2'))
          .thenAnswer((_) async => http.Response('test', 200));
      final result = await service.daily(Currency.fromCurrencyCode('USD'), 'BTC', 100, 2);

      // Then
      expect(result.length, 0);
    });

    test('error response server should return default model', () async {

      // Given
      final client = MockClient();
      final service = HistogramService(client: client);

      // When
      when(client.get('https://min-api.cryptocompare.com/data/histoday?fsym=BTC&tsym=USD&limit=100&aggregate=2'))
          .thenAnswer((_) async => http.Response(json.encode({}), 500));
      final result = await service.daily(Currency.fromCurrencyCode('USD'), 'BTC', 100, 2);

      // Then
      expect(result.length, 0);
    });
  });

  group('hourly', () {

    test('success response should map to model', () async {

      // Given
      final client = MockClient();
      final service = HistogramService(client: client);
      final response = {
        'Data': [
          { 'close': 1, 'high': 1, 'low': 1, 'open': 1, 'time': 1542555162, 'volumefrom': 1, 'volumeto': 1 },
          { 'close': 2, 'high': 2, 'low': 2, 'open': 2, 'time': 1542555162, 'volumefrom': 2, 'volumeto': 2 }
        ]
      };

      // When
      when(client.get('https://min-api.cryptocompare.com/data/histohour?fsym=BTC&tsym=USD&limit=100&aggregate=2'))
          .thenAnswer((_) async => http.Response(json.encode(response), 200));
      final result = await service.hourly(Currency.fromCurrencyCode('USD'), 'BTC', 100, 2);

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

      // When
      when(client.get('https://min-api.cryptocompare.com/data/histohour?fsym=BTC&tsym=USD&limit=100&aggregate=2'))
          .thenAnswer((_) async => http.Response('test', 200));
      final result = await service.hourly(Currency.fromCurrencyCode('USD'), 'BTC', 100, 2);

      // Then
      expect(result.length, 0);
    });

    test('error response server should return default model', () async {

      // Given
      final client = MockClient();
      final service = HistogramService(client: client);

      // When
      when(client.get('https://min-api.cryptocompare.com/data/histohour?fsym=BTC&tsym=USD&limit=100&aggregate=2'))
          .thenAnswer((_) async => http.Response(json.encode({}), 500));
      final result = await service.hourly(Currency.fromCurrencyCode('USD'), 'BTC', 100, 2);

      // Then
      expect(result.length, 0);
    });
  });

  group('minute', () {

    test('success response should map to model', () async {

      // Given
      final client = MockClient();
      final service = HistogramService(client: client);
      final response = {
        'Data': [
          { 'close': 1, 'high': 1, 'low': 1, 'open': 1, 'time': 1542555162, 'volumefrom': 1, 'volumeto': 1 },
          { 'close': 2, 'high': 2, 'low': 2, 'open': 2, 'time': 1542555162, 'volumefrom': 2, 'volumeto': 2 }
        ]
      };

      // When
      when(client.get('https://min-api.cryptocompare.com/data/histominute?fsym=BTC&tsym=USD&limit=100&aggregate=2'))
          .thenAnswer((_) async => http.Response(json.encode(response), 200));
      final result = await service.minute(Currency.fromCurrencyCode('USD'), 'BTC', 100, 2);

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

      // When
      when(client.get('https://min-api.cryptocompare.com/data/histominute?fsym=BTC&tsym=USD&limit=100&aggregate=2'))
          .thenAnswer((_) async => http.Response('test', 200));
      final result = await service.minute(Currency.fromCurrencyCode('USD'), 'BTC', 100, 2);

      // Then
      expect(result.length, 0);
    });

    test('error response server should return default model', () async {

      // Given
      final client = MockClient();
      final service = HistogramService(client: client);

      // When
      when(client.get('https://min-api.cryptocompare.com/data/histominute?fsym=BTC&tsym=USD&limit=100&aggregate=2'))
          .thenAnswer((_) async => http.Response(json.encode({}), 500));
      final result = await service.minute(Currency.fromCurrencyCode('USD'), 'BTC', 100, 2);

      // Then
      expect(result.length, 0);
    });
  });
}