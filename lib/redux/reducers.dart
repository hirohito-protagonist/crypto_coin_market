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

  static final Map<TimeRange, String> _timeRangeTranslation = {
      TimeRange.OneHour: '1H',
      TimeRange.SixHour: '6H',
      TimeRange.TwelveHour: '12H',
      TimeRange.OneDay: '1D',
      TimeRange.OneWeek: '1W',
      TimeRange.OneMonth: '1M',
      TimeRange.ThreeMonth: '3M',
      TimeRange.SixMonth: '6M',
      TimeRange.OneYear: '1Y'
  };

  final DetailsViewModel details;
  final List<HistogramDataModel> histogramData;
  final Map<TimeRange, String> timeRangeTranslation;
  final List<TimeRange> histogramTimeRange;
  final TimeRange activeHistogramRange;

  DetailsPageState({
      @required this.details,
      @required this.histogramData,
      @required this.timeRangeTranslation,
      @required this.histogramTimeRange,
      @required this.activeHistogramRange,
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
      histogramData = [],
      timeRangeTranslation = Map.of(_timeRangeTranslation),
      histogramTimeRange = Map.of(_timeRangeTranslation).keys.toList(),
      activeHistogramRange = TimeRange.OneDay;
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
        histogramData: histogramReducer(state.detailsPageState.histogramData, action),
        activeHistogramRange: histogramTimeRangeReducer(state.detailsPageState.activeHistogramRange, action),
        histogramTimeRange: state.detailsPageState.histogramTimeRange,
        timeRangeTranslation: state.detailsPageState.timeRangeTranslation,
    ),
  );
}

TimeRange histogramTimeRangeReducer(TimeRange state, action) {

  if (action is  DetailsHistogramTimeRange) {
    return action.timeRange;
  }
  return state;
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
  if (action is DetailsUpdate) {

    return action.details;
  }
  return state;
}


String currencyReducer(String state, action) {

  if (action is MarketsChangeCurrencyAction || action is DetailsChangeCurrencyAction) {
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
    final histData = await HistogramService.OHLCV(store.state.detailsPageState.activeHistogramRange, store.state.currency, store.state.detailsPageState.details.coinInformation.name);
    store.dispatch(DetailsResponseHistogramDataAction(data: histData));
  }

  if (
    action is MarketsRequestDataAction ||
    action is MarketsChangePageAction ||
    action is MarketsChangeCurrencyAction ||
    action is DetailsChangeCurrencyAction
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

  if (action is DetailsChangeCurrencyAction) {
    final currency = store.state.currency;
    final coinName = store.state.detailsPageState.details.coinInformation.name;
    final prices = await PriceService(client: http.Client()).multipleSymbolsFullData([coinName], Currency.fromCurrencyCode(currency));

    final displayPriceNode = prices.display.containsKey(coinName) ? prices.display[coinName] : null;
    final rawPriceNode = prices.raw.containsKey(coinName) ? prices.raw[coinName] : null;
    final coinModel = DetailsCoinInformation(
        formattedPriceChange: displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : '',
        priceChange: rawPriceNode != null ? Map.of(rawPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : 0,
        formattedPrice: displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['PRICE'] : '',
        name: store.state.detailsPageState.details.coinInformation.name,
        imageUrl: store.state.detailsPageState.details.coinInformation.imageUrl,
        fullName: store.state.detailsPageState.details.coinInformation.fullName
    );

    store.dispatch(DetailsUpdate(
      details: DetailsViewModel(
        coinInformation: coinModel,
        currency: currency,
      )
    ));
  }
}