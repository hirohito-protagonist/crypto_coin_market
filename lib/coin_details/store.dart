import 'package:flutter/foundation.dart';

import 'package:crypto_coin_market/data_source/data_source.dart';
import 'package:crypto_coin_market/core/core.dart';

import './actions.dart';
import './model.dart';

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

  final DetailsModel details;
  final List<HistogramDataModel> histogramData;
  final Map<TimeRange, String> timeRangeTranslation;
  final List<TimeRange> histogramTimeRange;
  final TimeRange activeHistogramRange;
  final ServiceDataState histogramDataState;

  DetailsPageState({
    @required this.details,
    @required this.histogramData,
    @required this.timeRangeTranslation,
    @required this.histogramTimeRange,
    @required this.activeHistogramRange,
    @required this.histogramDataState,
  });

  DetailsPageState.initialState():
        details = DetailsModel(
            coinInformation: CoinInformation(
                formattedPriceChange: '',
                priceChange: 0,
                formattedPrice: '',
                name: '',
                imageUrl: '',
                fullName: ''
            ),
        ),
        histogramData = [],
        histogramDataState = ServiceDataState.Success,
        timeRangeTranslation = Map.of(_timeRangeTranslation),
        histogramTimeRange = Map.of(_timeRangeTranslation).keys.toList(),
        activeHistogramRange = TimeRange.OneDay;
}


DetailsPageState detailsPageReducer(DetailsPageState state, action) {
  return DetailsPageState(
    details: _detailsReducer(state.details, action),
    histogramData: _histogramReducer(state.histogramData, action),
    activeHistogramRange: _histogramTimeRangeReducer(state.activeHistogramRange, action),
    histogramDataState: _histogramDataStateReduce(state.histogramDataState, action),
    histogramTimeRange: state.histogramTimeRange,
    timeRangeTranslation: state.timeRangeTranslation,
  );
}


TimeRange _histogramTimeRangeReducer(TimeRange state, action) {

  if (action is  DetailsHistogramTimeRange) {
    return action.timeRange;
  }
  return state;
}



List<HistogramDataModel> _histogramReducer(List<HistogramDataModel> state, action) {

  if (action is HistogramRequestDataAction) {
    return List.unmodifiable([]);
  }

  if (action is HistogramResponseDataAction) {
    return List.unmodifiable(action.data);
  }
  return state;
}

DetailsModel _detailsReducer(DetailsModel state, action) {

  if (action is NavigationChangeToDetailsPageAction) {

    return DetailsModel(
      coinInformation: action.coinInformation,
    );
  }
  if (action is DetailsUpdate) {

    return action.details;
  }
  return state;
}

ServiceDataState _histogramDataStateReduce(ServiceDataState state, action) {

  if (action is HistogramLoadingDataAction ||
    action is HistogramErrorDataAction ||
    action is HistogramSuccessDataAction
  ) {
    return action.dataState;
  }
  return state;
}