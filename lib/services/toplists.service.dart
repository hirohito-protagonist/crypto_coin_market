import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:crypto_coin_market/model/model.dart';

import './util.service.dart';
import './uri.service.dart';

class TopListsService {

  final UriService uriService = UriService();
  final http.Client client;

  TopListsService({this.client});

  Future<List<TotalVolume>> totalVolume(Currency currency, { int page = 0 }) async {

    final queryParameters = {
      'limit': '100',
      'tsym': currency.currencyCode(),
      'page': page.toString()
    };

    final response = await client.get(uriService.totalVolume(queryParameters));

    return response.statusCode != 200 ? [] :
    UtilService.parsedOrDefault(response.body, { 'Data': [] })
    ['Data']
        .map<TotalVolume>((item) => TotalVolume.fromJson(item))
        .toList();
  }
}