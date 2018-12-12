import 'package:flutter/foundation.dart';
import 'package:crypto_coin_market/model/markets_view.model.dart';
import 'package:crypto_coin_market/model/multiple_sybmols.model.dart';

class AppState {
  final String activeCurrency;
  final MarketsViewModel markets;

  AppState({
    @required this.activeCurrency,
    @required this.markets
  });

  AppState.initialState():
        activeCurrency = 'USD',
        markets = MarketsViewModel(
          prices: MultipleSymbols(display: {},raw: {}),
          volume: List.unmodifiable([]),
        );
}

AppState appStateReducer(AppState state, action) {
  return AppState(
    activeCurrency: 'USD',
    markets: marketsReducer(state.markets, action),
  );
}

MarketsViewModel marketsReducer(MarketsViewModel state, action) {

  return state;
}