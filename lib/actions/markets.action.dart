import 'package:flutter/foundation.dart';

import 'package:crypto_coin_market/model/model.dart';

class MarketsChangeCurrencyAction {
  final String currency;
  MarketsChangeCurrencyAction({
    @required this.currency
  });
}

class MarketsChangePageAction {
  final int page;
  MarketsChangePageAction({
    @required this.page
  });
}