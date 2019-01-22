import 'package:flutter/foundation.dart';

import 'package:crypto_coin_market/markets/markets.dart';
import 'package:crypto_coin_market/coin_details/coin_details.dart';

class AppState {
  final String currency;
  final MarketsPageState marketsPageState;
  final DetailsPageState detailsPageState;

  AppState({
    @required this.currency,
    @required this.marketsPageState,
    @required this.detailsPageState,
  });

  AppState.initialState()
      : currency = 'USD',
        marketsPageState = MarketsPageState.initialState(),
        detailsPageState = DetailsPageState.initialState();
}

AppState appStateReducer(AppState state, action) {
  return AppState(
    currency: currencyReducer(state.currency, action),
    marketsPageState: marketsPageReducer(state.marketsPageState, action),
    detailsPageState: detailsPageReducer(state.detailsPageState, action),
  );
}

String currencyReducer(String state, action) {
  if (action is MarketsChangeCurrencyAction ||
      action is DetailsChangeCurrencyAction) {
    return action.currency;
  }
  return state;
}
