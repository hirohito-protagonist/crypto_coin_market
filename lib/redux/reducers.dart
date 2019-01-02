import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_coin_market/model/markets_view.model.dart';
import 'package:crypto_coin_market/model/multiple_sybmols.model.dart';

import 'package:crypto_coin_market/services/toplists.service.dart';
import 'package:crypto_coin_market/services/price.service.dart';
import 'package:crypto_coin_market/model/currency.model.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_coin_market/model/total_volume.model.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';
import 'package:crypto_coin_market/model/histogram_data.model.dart';
import 'package:crypto_coin_market/services/histogram.service.dart';

import 'package:crypto_coin_market/actions/markets.action.dart';
import 'package:crypto_coin_market/actions/details.action.dart';
import 'package:crypto_coin_market/actions/navigation.action.dart';

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

class DetailsPageState {
  final DetailsViewModel details;
  final List<HistogramDataModel> histogramData;

  DetailsPageState({
      @required this.details,
      @required this.histogramData,
  });

  DetailsPageState.initialState():
      details = DetailsViewModel(
          coinInformation: DetailsCoinInformation(
              formattedPriceChange: '',
              priceChange: 0,
              formattedPrice: '',
              name: '',
              imageUrl: '',
              fullName: ''
          ),
          currency: 'USD'
      ),
      histogramData = [];
}

class AppState {
  final String currency;
  final MarketsPageState marketsPageState;
  final DetailsPageState detailsPageState;

  AppState({
    @required this.currency,
    @required this.marketsPageState,
    @required this.detailsPageState,
  });

  AppState.initialState():
    currency = 'USD',
    marketsPageState = MarketsPageState.initialState(),
    detailsPageState = DetailsPageState.initialState();
}

AppState appStateReducer(AppState state, action) {
  return AppState(
    currency: currencyReducer(state.currency, action),
    marketsPageState: MarketsPageState(
      availableCurrencies: Currency.availableCurrencies(),
      page: pageReducer(state.marketsPageState.page, action),
      markets: marketsReducer(state.marketsPageState.markets, action),
    ),
    detailsPageState: DetailsPageState(
        details: detailsReducer(state.detailsPageState.details, action),
        histogramData: histogramReducer(state.detailsPageState.histogramData, action)
    ),
  );
}

MarketsViewModel marketsReducer(MarketsViewModel state, action) {

  if (action is MarketsResponseDataAction) {

    return action.data;
  }
  return state;
}

List<HistogramDataModel> histogramReducer(List<HistogramDataModel> state, action) {

  if (action is DetailsRequestHistogramDataAction) {
    return List.unmodifiable([]);
  }

  if (action is DetailsResponseHistogramDataAction) {
    return List.unmodifiable(action.data);
  }
  return state;
}

DetailsViewModel detailsReducer(DetailsViewModel state, action) {

  if (action is NavigationChangeToDetailsPageAction) {

    return action.data;
  }
  return state;
}


String currencyReducer(String state, action) {

  if (action is MarketsChangeCurrencyAction) {
    return action.currency;
  }
  return state;
}

int pageReducer(int state, action) {

  if (action is MarketsChangePageAction) {
    return action.page;
  }
  return state;
}


void appStateMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  if (action is NavigationChangeToDetailsPageAction) {
    await NavigationKeys.navigationState.currentState.pushNamed('/details');
  }

  if (action is DetailsRequestHistogramDataAction) {
    final histData = await HistogramService.OHLCV(TimeRange.OneDay, store.state.currency, store.state.detailsPageState.details.coinInformation.name);
    store.dispatch(DetailsResponseHistogramDataAction(data: histData));
  }

  if (
    action is MarketsRequestDataAction ||
    action is MarketsChangePageAction ||
    action is MarketsChangeCurrencyAction
  ) {
    final currency = Currency.fromCurrencyCode(store.state.currency);
    final volume =  await TopListsService(client: http.Client()).totalVolume(currency, page: store.state.marketsPageState.page);
    final coins = volume.map((TotalVolume tv) => tv.coinInfo.name).toList();
    final prices = await PriceService(client: http.Client()).multipleSymbolsFullData(coins, currency);

    store.dispatch(MarketsResponseDataAction(
        data: MarketsViewModel(
          volume: volume,
          prices: prices,
        ),
    ));
  }
}