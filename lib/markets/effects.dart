import 'dart:async';
import 'package:async/async.dart';
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
  CancelableOperation<dynamic> _operation;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    _operation?.cancel();

    final currency = Currency.fromCurrencyCode(store.state.currency);
    store.dispatch(MarketsLoadingDataAction());
    _operation = CancelableOperation.fromFuture(
        TopListsService(client: http.Client())
            .volume(currency, page: store.state.marketsPageState.page)
            .then((volume) {
      final coins = volume.map((TotalVolume tv) => tv.coinInfo.name).toList();

      return PriceService(client: http.Client())
          .multipleSymbolsFullData(coins, currency)
          .then((prices) {
        return store.dispatch(MarketsResponseDataAction(
          volume: volume,
          prices: prices,
        ));
      });
    }).catchError((e) => store.dispatch(MarketsErrorDataAction())));
  }
}
