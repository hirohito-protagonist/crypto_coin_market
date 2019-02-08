import 'package:flutter/foundation.dart';

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

class MarketsRefresh {}