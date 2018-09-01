import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model/total_volume.model.dart';

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

Future<List<TotalVolume>> volumeData(http.Client client) async {

  final response = await client.get('${ENDPOINT}data/top/totalvol?limit=2000&tsym=USD');

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

Future<dynamic> priceMultiFull(http.Client client, List<String> coins) async {

  final response = await client.get('${ENDPOINT}data/pricemultifull?fsyms=BTC,ETH&tsyms=USD');

  return parsedOrDefault(response.body, {
    'RAW': {},
    'DISPLAY': {}
  });
}