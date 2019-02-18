import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:async/async.dart';

import 'package:crypto_coin_market/data_source/data_source.dart';
import 'package:crypto_coin_market/core/core.dart';

import './actions.dart';
import './model.dart';

List<Middleware<AppState>> coinDetailsEffects() {
  return [
    TypedMiddleware<AppState, HistogramRequestDataAction>(
        _HistogramDataEffect()),
    TypedMiddleware<AppState, DetailsRefresh>(
        _HistogramDataEffect()),
    TypedMiddleware<AppState, ChangeCurrencyAction>(_DetailsEffect()),
    TypedMiddleware<AppState, DetailsRefresh>(_DetailsEffect()),
  ];
}

class _HistogramDataEffect implements MiddlewareClass<AppState> {
  CancelableOperation<dynamic> _operation;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    _operation?.cancel();

    store.dispatch(HistogramLoadingDataAction());
    _operation = CancelableOperation.fromFuture(
      HistogramService.OHLCV(
        store.state.detailsPageState.activeHistogramRange,
        store.state.currency,
        store.state.detailsPageState.details.coinInformation.name
      )
      .then((histData) {
        store.dispatch(HistogramSuccessDataAction());
        store.dispatch(HistogramResponseDataAction(data: histData));
      })
      .catchError((e) => store.dispatch(HistogramErrorDataAction()))
    );

  }
}

class _DetailsEffect implements MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final currency = store.state.currency;
    final coinName = store.state.detailsPageState.details.coinInformation.name;
    final prices = await PriceService(client: http.Client())
        .multipleSymbolsFullData(
            [coinName], Currency.fromCurrencyCode(currency));

    final coinModel = this._createCoinInformation(
      prices: prices,
      coinName: coinName,
      fullName: store.state.detailsPageState.details.coinInformation.fullName,
      imageUrl: store.state.detailsPageState.details.coinInformation.imageUrl,
      name: store.state.detailsPageState.details.coinInformation.name,
    );

    store.dispatch(DetailsUpdate(
        details: DetailsModel(
      coinInformation: coinModel,
    )));
  }

  CoinInformation _createCoinInformation(
      {@required String coinName,
      @required MultipleSymbols prices,
      @required String name,
      @required String imageUrl,
      @required String fullName}) {
    final displayPriceNode =
        prices.display.containsKey(coinName) ? prices.display[coinName] : null;
    final rawPriceNode =
        prices.raw.containsKey(coinName) ? prices.raw[coinName] : null;
    final displayPrice = Map.of(displayPriceNode).values.toList().elementAt(0);
    final rawPrice = Map.of(rawPriceNode).values.toList().elementAt(0);
    return CoinInformation(
        formattedPriceChange:
            displayPriceNode != null ? displayPrice['CHANGEPCT24HOUR'] : '',
        priceChange: rawPriceNode != null ? rawPrice['CHANGEPCT24HOUR'] : 0,
        formattedPrice: displayPriceNode != null ? displayPrice['PRICE'] : '',
        name: name,
        imageUrl: imageUrl,
        fullName: fullName);
  }
}
