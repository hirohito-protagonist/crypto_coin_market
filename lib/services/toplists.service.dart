import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:crypto_coin_market/model/total_volume.model.dart';
import 'package:crypto_coin_market/model/currency.model.dart';

class TopListsService {

  final String endpoint = 'https://min-api.cryptocompare.com/';
  final http.Client client;

  TopListsService({this.client});

  Future<List<TotalVolume>> totalVolume(Currency currency, { int page = 0 }) async {

    final response = await client.get('${endpoint}data/top/totalvol?limit=100&tsym=${currency.currencyCode()}&page=${page}');
    print(response.body);
    return response.statusCode != 200 ? [] :
    parsedOrDefault(response.body, { 'Data': [] })
    ['Data']
        .map<TotalVolume>((item) => TotalVolume.fromJson(item))
        .toList();
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
}