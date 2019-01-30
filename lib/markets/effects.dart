import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

import 'package:crypto_coin_market/data_source/data_source.dart';
import 'package:crypto_coin_market/core/core.dart';

import './actions.dart';

List<Middleware<AppState>> marketsEffects() {
  var marketEffect = _MarketsEffect();
  return [
    TypedMiddleware<AppState, MarketsRequestDataAction>(marketEffect),
    TypedMiddleware<AppState, MarketsChangePageAction>(marketEffect),
    TypedMiddleware<AppState, MarketsChangeCurrencyAction>(marketEffect),
  ];
}

class _MarketsEffect implements MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final currency = Currency.fromCurrencyCode(store.state.currency);
    final volume = await TopListsService(client: http.Client())
        .totalVolume(currency, page: store.state.marketsPageState.page);
    final coins = volume.map((TotalVolume tv) => tv.coinInfo.name).toList();
    final prices = await PriceService(client: http.Client())
        .multipleSymbolsFullData(coins, currency);

    store.dispatch(MarketsResponseDataAction(
      volume: volume,
      prices: prices,
    ));
  }

}