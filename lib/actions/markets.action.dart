import 'package:crypto_coin_market/model/markets_view.model.dart';

class MarketsRequestDataAction {}
class MarketsResponseDataAction {
  final MarketsViewModel data;

  MarketsResponseDataAction({this.data});
}


class MarketsChangeCurrencyAction {
  final String currency;
  MarketsChangeCurrencyAction({this.currency});
}

class MarketsChangePageAction {
  final int page;
  MarketsChangePageAction({this.page});
}