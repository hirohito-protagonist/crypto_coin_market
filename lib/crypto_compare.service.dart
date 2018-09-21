import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model/total_volume.model.dart';
import 'model/multiple_sybmols.model.dart';
import 'model/currency.model.dart';

const ENDPOINT = 'https://min-api.cryptocompare.com/';

dynamic parsedOrDefault(String input, dynamic defaultValue) {
  dynamic output = defaultValue;
  try {
    output = json.decode(input);
  } catch(e) {
    output = defaultValue;
  }
  return output;
}

Future<List<TotalVolume>> volumeData(http.Client client, Currency currency) async {

  final response = await client.get('${ENDPOINT}data/top/totalvol?limit=2000&tsym=${currency.currencyCode()}');

  return response.statusCode != 200 ? [] :
    parsedOrDefault(response.body, { 'Data': [] })
      ['Data']
      .map<TotalVolume>((item) => TotalVolume.fromJson(item))
      .toList();
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

Future<MultipleSymbols> priceMultiFull(http.Client client, List<dynamic> coins, Currency currency) async {

  final response = await client.get('${ENDPOINT}data/pricemultifull?fsyms=${coins.join(',')}&tsyms=${currency.currencyCode()}');
  final defaultModel = {
    'RAW': {},
    'DISPLAY': {}
  };

  return MultipleSymbols.fromJson(response.statusCode != 200 ? defaultModel :
    parsedOrDefault(response.body, defaultModel));
}

Future<MultipleSymbols> allPriceMultiFull(http.Client client, List<dynamic> coins, Currency currency) async {

  final coinsPartition = partition(coins, 70);

  return Future.wait(coinsPartition.map((c) => priceMultiFull(client, c, currency)))
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