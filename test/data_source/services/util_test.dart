import 'package:flutter_test/flutter_test.dart';

import 'package:crypto_coin_market/data_source/services/util.dart';

void main() {

  group('parsedOrDefault', () {

    test('should return default model in case of json parse error', () {
      // Given
      String json = 'test message';
      Map<String, String> defaultValue = { 'test': 'deafult' };

      // When
      var result = UtilService.parsedOrDefault(json, defaultValue);

      // Then
      expect(result, defaultValue);
    });

    test('should return map in case of json parse success', () {
      // Given
      String json = '{"test": "parsed success"}';
      Map<String, String> defaultValue = { 'test': 'deafult' };
      Map<String, String> successValue = { 'test': 'parsed success' };

      // When
      var result = UtilService.parsedOrDefault(json, defaultValue);

      // Then
      expect(result, successValue);
    });
  });

  group('partition', () {

    test('split array to equal chunks', () {

      // Given
      List<int> input = [1,2,3,4,5,6];
      int maxSize = 2;
      List<List<int>> partitionResult = [[1,2],[3,4],[5,6]];

      // When
      var result = UtilService.partition(input, maxSize);

      // Then
      expect(result, partitionResult);
    });

    test('split array to not equal chunks', () {

      // Given
      List<int> input = [1,2,3,4,5];
      int maxSize = 4;
      List<List<int>> partitionResult = [[1,2,3,4],[5]];

      // When
      var result = UtilService.partition(input, maxSize);

      // Then
      expect(result, partitionResult);
    });
  });
}