import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import './../model/model.dart';

import './util.dart';
import './uri.dart';

class TopListsService {

  final UriService uriService = UriService();
  final http.Client client;

  TopListsService({
    @required this.client
  });

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

  Future<List<TotalVolume>> volume(Currency currency, { int page = 0 }) async {

    final queryParameters = {
      'limit': '100',
      'tsym': currency.currencyCode(),
      'page': page.toString()
    };

    final response = await client.get(uriService.totalVolume(queryParameters));

    return json.decode(response.body)['Data']
        .map<TotalVolume>((item) => TotalVolume.fromJson(item))
        .toList();
  }
}