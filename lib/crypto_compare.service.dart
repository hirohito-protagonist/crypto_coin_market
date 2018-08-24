import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model/total_volume.model.dart';


Future<List<TotalVolume>> volumeData(http.Client client) async {

  final response = await client.get('https://min-api.cryptocompare.com/data/top/totalvol?limit=2000&tsym=USD');
  if (response.statusCode == 200) {
    final parsedResponse = json.decode(response.body);
    return parsedResponse['Data'].map<TotalVolume>((item) =>
        TotalVolume.fromJson(item)).toList();
  }
  return [];
}