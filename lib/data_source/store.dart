import 'dart:async';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

import 'package:flutter/foundation.dart';
import './model/model.dart';
import './services/services.dart';
import 'package:crypto_coin_market/core/core.dart';


enum ServicesType {
  Volume, Prices, Histogram
}

enum ServiceDataState {
  Error, Success, Loading
}

class VolumeWithPricesAction {
  final num page;
  final Currency currency;

  VolumeWithPricesAction({
    @required this.currency,
    @required this.page,
  });
}

class _LoadingAction {
  final ServiceDataState state = ServiceDataState.Loading;
  final ServicesType serviceType;

  _LoadingAction({
    @required this.serviceType,
  });
}

class _ErrorAction {
  final ServiceDataState state = ServiceDataState.Loading;
  final ServicesType serviceType;

  _ErrorAction({
    @required this.serviceType,
  });
}

class _SuccessAction<T> {
  final ServiceDataState state = ServiceDataState.Success;
  final ServicesType serviceType;
  final T response;

  _SuccessAction({
    @required this.serviceType,
    @required this.response,
  });
}

class _ServiceDataState<T> {
  final T response;
  final ServiceDataState state;

  _ServiceDataState({
    @required this.response,
    @required this.state,
  });
}

class DataSourceState {
  final _ServiceDataState<List<TotalVolume>> volume;
  final _ServiceDataState<MultipleSymbols> prices;
  final _ServiceDataState<List<HistogramDataModel>> histogram;

  DataSourceState({
    @required this.volume,
    @required this.prices,
    @required this.histogram,
  });

  DataSourceState.initialState():
    volume = _ServiceDataState<List<TotalVolume>>(
      response: List.unmodifiable([]),
      state: ServiceDataState.Success
    ),
    prices = _ServiceDataState<MultipleSymbols>(
      response: MultipleSymbols(raw: Map.identity(), display: Map.identity()),
      state: ServiceDataState.Success
    ),
    histogram = _ServiceDataState<List<HistogramDataModel>>(
      response: List.unmodifiable([]),
      state: ServiceDataState.Success
    );
}

DataSourceState dataSourceStateReducer(DataSourceState state, action) {
  return DataSourceState(
    prices: _pricesReducer(state.prices, action),
    volume: _volumeReducer(state.volume, action),
    histogram: _histogramReducer(state.histogram, action),
  );
}

_ServiceDataState<List<TotalVolume>> _volumeReducer(_ServiceDataState<List<TotalVolume>> state, action) {

  if (action is _SuccessAction && action.serviceType == ServicesType.Volume) {
    return _ServiceDataState<List<TotalVolume>>(
      state: action.state,
      response: List.unmodifiable(action.response)
    );
  }

  if (
    (action is _ErrorAction && action.serviceType == ServicesType.Volume) ||
    (action is _LoadingAction && action.serviceType == ServicesType.Volume)
  ) {
    return _ServiceDataState<List<TotalVolume>>(
        state: action.state,
        response: List.unmodifiable([])
    );
  }
  return state;
}

_ServiceDataState<MultipleSymbols> _pricesReducer(_ServiceDataState<MultipleSymbols> state, action) {

  if (action is _SuccessAction && action.serviceType == ServicesType.Prices) {
    return _ServiceDataState<MultipleSymbols>(
      state: action.state,
      response: action.response
    );
  }

  if (
    (action is _ErrorAction && action.serviceType == ServicesType.Prices) ||
    (action is _LoadingAction && action.serviceType == ServicesType.Prices)
  ) {
    return _ServiceDataState<MultipleSymbols>(
      state: action.state,
      response: MultipleSymbols(raw: Map.identity(), display: Map.identity())
    );
  }
  return state;
}

_ServiceDataState<List<HistogramDataModel>> _histogramReducer(_ServiceDataState<List<HistogramDataModel>> state, action) {

  if (action is _SuccessAction && action.serviceType == ServicesType.Histogram) {
    return _ServiceDataState<List<HistogramDataModel>>(
      state: action.state,
      response: List.unmodifiable(action.response)
    );
  }

  if (
    (action is _ErrorAction && action.serviceType == ServicesType.Histogram) ||
    (action is _LoadingAction && action.serviceType == ServicesType.Histogram)
  ) {
    return _ServiceDataState<List<HistogramDataModel>>(
      state: action.state,
      response: List.unmodifiable([])
    );
  }
  return state;
}


List<Middleware<AppState>> dataSourceEffects() {
  return [
    TypedMiddleware<AppState, VolumeWithPricesAction>(_VolumeWithPricesEffects())
  ];
}

class _VolumeWithPricesEffects implements MiddlewareClass<AppState> {

  CancelableOperation<dynamic> _dataOperation;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    _dataOperation?.cancel();

    final page = action.page;
    final currency = action.currency;

    store.dispatch(_LoadingAction(serviceType: ServicesType.Volume));
    _dataOperation = CancelableOperation.fromFuture(
      TopListsService(client: http.Client()).volume(currency, page: page)
        .then((volume) {

          store.dispatch(_SuccessAction(serviceType: ServicesType.Volume, response: volume));
          store.dispatch(_LoadingAction(serviceType: ServicesType.Prices));
          final coins = volume.map((TotalVolume tv) => tv.coinInfo.name).toList();
          return PriceService(client: http.Client()).multipleSymbolsFullData(coins, currency)
            .then((prices) {
                store.dispatch(_SuccessAction(
                    serviceType: ServicesType.Prices, response: prices));
            })
            .catchError(() => store.dispatch(_ErrorAction(serviceType: ServicesType.Prices)));
        })
        .catchError(() => store.dispatch(_ErrorAction(serviceType: ServicesType.Volume)))
    );
  }

}

class DataSourceSelectors {
  final Store<AppState> store;

  DataSourceSelectors({
    @required this.store,
  });

  _ServiceDataState<List<TotalVolume>> volume() => this.store.state.dataSourceState.volume;
  _ServiceDataState<MultipleSymbols> prices() => this.store.state.dataSourceState.prices;
}