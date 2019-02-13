import 'package:flutter/foundation.dart';
import './model/model.dart';

enum ServiceDataState {
  Error, Success, Loading
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
  return state;
}

_ServiceDataState<MultipleSymbols> _pricesReducer(_ServiceDataState<MultipleSymbols> state, action) {
  return state;
}

_ServiceDataState<List<HistogramDataModel>> _histogramReducer(_ServiceDataState<List<HistogramDataModel>> state, action) {
  return state;
}