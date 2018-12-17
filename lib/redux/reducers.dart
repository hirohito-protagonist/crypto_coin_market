import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto_coin_market/model/markets_view.model.dart';
import 'package:crypto_coin_market/model/multiple_sybmols.model.dart';

import 'package:crypto_coin_market/services/toplists.service.dart';
import 'package:crypto_coin_market/services/price.service.dart';
import 'package:crypto_coin_market/model/currency.model.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_coin_market/model/total_volume.model.dart';

class MarketsDataAction {}
class LoadMarketsDataAction {
  final MarketsViewModel data;

  LoadMarketsDataAction({this.data});
}

class ChangePageAction {
  final int page;
  ChangePageAction({this.page});
}

class ChangeCurrencyAction {
  final String currency;
  ChangeCurrencyAction({this.currency});
}

class AppState {
  final String activeCurrency;
  final List<String> availableCurrencies;
  final int activePage;
  final MarketsViewModel markets;

  AppState({
    @required this.activeCurrency,
    @required this.markets,
    @required this.activePage,
    @required this.availableCurrencies
  });

  AppState.initialState():
        activeCurrency = 'USD',
        markets = MarketsViewModel(
          prices: MultipleSymbols(display: {},raw: {}),
          volume: List.unmodifiable([]),
        ),
        activePage = 0,
        availableCurrencies = Currency.availableCurrencies();
}

AppState appStateReducer(AppState state, action) {
  return AppState(
    activeCurrency: currencyReducer(state.activeCurrency, action),
    availableCurrencies: Currency.availableCurrencies(),
    markets: marketsReducer(state.markets, action),
    activePage: pageReducer(state.activePage, action)
  );
}

MarketsViewModel marketsReducer(MarketsViewModel state, action) {

  if (action is LoadMarketsDataAction) {

    return action.data;
  }
  return state;
}


String currencyReducer(String state, action) {

  if (action is ChangeCurrencyAction) {
    return action.currency;
  }
  return state;
}

int pageReducer(int state, action) {

  if (action is ChangePageAction) {
    return action.page;
  }
  return state;
}


void appStateMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  if (
    action is MarketsDataAction ||
    action is ChangePageAction ||
    action is ChangeCurrencyAction
  ) {
    final currency = Currency.fromCurrencyCode(store.state.activeCurrency);
    final volume =  await TopListsService(client: http.Client()).totalVolume(currency, page: store.state.activePage);
    final coins = volume.map((TotalVolume tv) => tv.coinInfo.name).toList();
    final prices = await PriceService(client: http.Client()).multipleSymbolsFullData(coins, currency);

    store.dispatch(LoadMarketsDataAction(
        data: MarketsViewModel(
          volume: volume,
          prices: prices,
        ),
    ));
  }
}