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
    TypedMiddleware<AppState, MarketsRefresh>(marketEffect),
  ];
}

class _MarketsEffect implements MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    final currency = Currency.fromCurrencyCode(store.state.currency);

    store.dispatch(VolumeWithPricesAction(
      page: store.state.marketsPageState.page,
      currency: currency,
    ));
  }
}