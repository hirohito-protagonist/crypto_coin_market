import 'package:flutter/foundation.dart';

import 'package:crypto_coin_market/core/core.dart';
import 'package:crypto_coin_market/data_source/data_source.dart';

import './actions.dart';
import './model.dart';


class MarketsPageState {
  final List<String> availableCurrencies;
  final int page;
  final MarketsModel markets;

  MarketsPageState({
    @required this.availableCurrencies,
    @required this.page,
    @required this.markets,
  });

  MarketsPageState.initialState():
        markets = MarketsModel(
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

MarketsModel _marketsReducer(MarketsModel state, action) {

  if (action is MarketsResponseDataAction) {

    return MarketsModel(
      prices: action.prices,
      volume: action.volume,
    );
  }
  return state;
}