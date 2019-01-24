import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

import 'package:crypto_coin_market/services/services.dart';
import 'package:crypto_coin_market/model/model.dart';
import 'package:crypto_coin_market/core/core.dart';

import './actions.dart';

List<Middleware<AppState>> coinDetailsEffects() {
  return [
    TypedMiddleware<AppState, DetailsChangeCurrencyAction>(_loadMarketsData()),
    TypedMiddleware<AppState, HistogramRequestDataAction>(
        _loadHistogramData()),
    TypedMiddleware<AppState, DetailsChangeCurrencyAction>(
        _updateDetailsPageData())
  ];
}

Middleware<AppState> _loadMarketsData() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final currency = Currency.fromCurrencyCode(store.state.currency);
    final volume = await TopListsService(client: http.Client())
        .totalVolume(currency, page: store.state.marketsPageState.page);
    final coins = volume.map((TotalVolume tv) => tv.coinInfo.name).toList();
    final prices = await PriceService(client: http.Client())
        .multipleSymbolsFullData(coins, currency);

    store.dispatch(MarketsResponseDataAction(
      data: MarketsViewModel(
        volume: volume,
        prices: prices,
      ),
    ));
  };
}

Middleware<AppState> _loadHistogramData() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final histData = await HistogramService.OHLCV(
        store.state.detailsPageState.activeHistogramRange,
        store.state.currency,
        store.state.detailsPageState.details.coinInformation.name);
    store.dispatch(HistogramResponseDataAction(data: histData));
  };
}

Middleware<AppState> _updateDetailsPageData() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final currency = store.state.currency;
    final coinName = store.state.detailsPageState.details.coinInformation.name;
    final prices = await PriceService(client: http.Client())
        .multipleSymbolsFullData(
        [coinName], Currency.fromCurrencyCode(currency));

    final displayPriceNode =
    prices.display.containsKey(coinName) ? prices.display[coinName] : null;
    final rawPriceNode =
    prices.raw.containsKey(coinName) ? prices.raw[coinName] : null;
    final coinModel = DetailsCoinInformation(
        formattedPriceChange: displayPriceNode != null
            ? Map.of(displayPriceNode).values.toList()[0]['CHANGEPCT24HOUR']
            : '',
        priceChange: rawPriceNode != null
            ? Map.of(rawPriceNode).values.toList()[0]['CHANGEPCT24HOUR']
            : 0,
        formattedPrice: displayPriceNode != null
            ? Map.of(displayPriceNode).values.toList()[0]['PRICE']
            : '',
        name: store.state.detailsPageState.details.coinInformation.name,
        imageUrl: store.state.detailsPageState.details.coinInformation.imageUrl,
        fullName:
        store.state.detailsPageState.details.coinInformation.fullName);

    store.dispatch(DetailsUpdate(
        details: DetailsViewModel(
          coinInformation: coinModel,
          currency: currency,
        )));
  };
}