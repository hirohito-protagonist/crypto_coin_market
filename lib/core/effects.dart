import 'package:redux/redux.dart';

import 'package:crypto_coin_market/markets/markets.dart';
import 'package:crypto_coin_market/coin_details/coin_details.dart';

import './actions.dart';
import './store.dart';

List<Middleware<AppState>> appStateMiddleware() {
  return [
    TypedMiddleware<AppState, NavigationChangeToDetailsPageAction>(
        _changeNavigation()),
  ]..addAll(marketsEffects())..addAll(coinDetailsEffects());
}

Middleware<AppState> _changeNavigation() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    await NavigationKeys.navigationState.currentState.pushNamed('/details');
  };
}