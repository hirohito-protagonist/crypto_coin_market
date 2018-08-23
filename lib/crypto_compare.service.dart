import 'dart:async';

import 'package:http/http.dart' as http;


Future<http.Response> volumeData() {
  return http.get('https://min-api.cryptocompare.com/data/top/totalvol?limit=2000&tsym=USD');
}