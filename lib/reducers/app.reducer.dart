import 'package:flutter/foundation.dart';
import 'package:crypto_coin_market/reducers/markets_page.reducer.dart';
import 'package:crypto_coin_market/reducers/details_page.reducer.dart';
import 'package:crypto_coin_market/actions/markets.action.dart';
import 'package:crypto_coin_market/actions/details.action.dart';
import 'package:redux/redux.dart';

import 'package:crypto_coin_market/model/markets_view.model.dart';

import 'package:crypto_coin_market/services/toplists.service.dart';
import 'package:crypto_coin_market/services/price.service.dart';
import 'package:crypto_coin_market/model/currency.model.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_coin_market/model/total_volume.model.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';

import 'package:crypto_coin_market/services/histogram.service.dart';
import 'package:crypto_coin_market/actions/navigation.action.dart';

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
    marketsPageState: marketsPageReducer(state.marketsPageState, action),
    detailsPageState: detailsPageReducer(state.detailsPageState, action),
  );
}

String currencyReducer(String state, action) {

  if (action is MarketsChangeCurrencyAction || action is DetailsChangeCurrencyAction) {
    return action.currency;
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