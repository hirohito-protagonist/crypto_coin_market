import 'package:flutter/foundation.dart';

import 'package:crypto_coin_market/model/model.dart';
import 'package:crypto_coin_market/actions/actions.dart';


class MarketsPageState {
  final List<String> availableCurrencies;
  final int page;
  final MarketsViewModel markets;

  MarketsPageState({
    @required this.availableCurrencies,
    @required this.page,
    @required this.markets,
  });

  MarketsPageState.initialState():
        markets = MarketsViewModel(
          prices: MultipleSymbols(display: {},raw: {}),
          volume: List.unmodifiable([]),
        ),
        page = 0,
        availableCurrencies = Currency.availableCurrencies();
}

MarketsPageState marketsPageReducer(MarketsPageState state, action) {
  return MarketsPageState(
    availableCurrencies: Currency.availableCurrencies(),
    page: _pageReducer(state.page, action),
    markets: _marketsReducer(state.markets, action),
  );
}

int _pageReducer(int state, action) {

  if (action is MarketsChangePageAction) {
    return action.page;
  }
  return state;
}

MarketsViewModel _marketsReducer(MarketsViewModel state, action) {

  if (action is MarketsResponseDataAction) {

    return action.data;
  }
  return state;
}