import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

import 'package:crypto_coin_market/services/services.dart';
import 'package:crypto_coin_market/model/model.dart';
import 'package:crypto_coin_market/actions/actions.dart';
import 'package:crypto_coin_market/reducers/reducers.dart';

import './actions.dart';

List<Middleware<AppState>> marketsEffects() {
  return [
    TypedMiddleware<AppState, MarketsRequestDataAction>(_loadMarketsData()),
    TypedMiddleware<AppState, MarketsChangePageAction>(_loadMarketsData()),
    TypedMiddleware<AppState, MarketsChangeCurrencyAction>(_loadMarketsData()),
  ];
}

Middleware<AppState> _loadMarketsData() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final currency = Currency.fromCurrencyCode(store.state.currency);
    final volume = await TopListsService(client: http.Client())
        .totalVolume(currency, page: store.state.marketsPageState.page);
    final coins = volume.map((TotalVolume tv) => tv.coinInfo.name).toList();
    final prices = await PriceService(client: http.Client())
        .multipleSymbolsFullData(coins, currency);

    store.dispatch(MarketsResponseDataAction(
      data: MarketsViewModel(
        volume: volume,
        prices: prices,
      ),
    ));
  };
}