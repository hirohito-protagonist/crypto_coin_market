import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:crypto_coin_market/model/multiple_sybmols.model.dart';
import 'package:crypto_coin_market/model/currency.model.dart';

class PriceService {

  final String endpoint = 'https://min-api.cryptocompare.com/';
  final http.Client client;

  PriceService({this.client});

  Future<MultipleSymbols> _priceMultiFull(List<dynamic> coins, Currency currency) async {

    final response = await client.get('${endpoint}data/pricemultifull?fsyms=${coins.join(',')}&tsyms=${currency.currencyCode()}');
    final defaultModel = {
      'RAW': {},
      'DISPLAY': {}
    };

    return MultipleSymbols.fromJson(response.statusCode != 200 ? defaultModel :
    parsedOrDefault(response.body, defaultModel));
  }

  Future<MultipleSymbols> multipleSymbolsFullData(List<dynamic> coins, Currency currency) async {

    final coinsPartition = partition(coins, 65);

    return Future.wait(coinsPartition.map((c) => _priceMultiFull(c, currency)))
        .then((List<MultipleSymbols> responses) {
      final model = MultipleSymbols.fromJson({
        'RAW': {},
        'DISPLAY': {}
      });

      responses.forEach((MultipleSymbols response) {

        model.raw.addAll(response.raw);
        model.display.addAll(response.display);
      });

      return model;
    })
        .catchError((e) {

      return MultipleSymbols.fromJson({
        'RAW': {},
        'DISPLAY': {}
      });
    });
  }

  dynamic parsedOrDefault(String input, dynamic defaultValue) {
    dynamic output = defaultValue;
    try {
      output = json.decode(input);
    } catch(e) {
      output = defaultValue;
    }
    return output;
  }

  List<dynamic> partition(List<dynamic> arr, int maxSize) {

    final out = [];
    var innerArr = [];

    for (int i = 0; i < arr.length; i++) {
      innerArr.add(arr[i]);
      if (innerArr.length == maxSize) {
        out.add(innerArr);
        innerArr = [];
      }
      if (i == arr.length - 1 && innerArr.length > 0) {
        out.add(innerArr);
      }
    }
    return out;
  }
}