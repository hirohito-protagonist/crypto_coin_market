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
  final Map<TimeRange, String> timeRangeTranslation;
  final List<TimeRange> histogramTimeRange;
  final TimeRange activeHistogramRange;

  DetailsPageState({
    @required this.details,
    @required this.timeRangeTranslation,
    @required this.histogramTimeRange,
    @required this.activeHistogramRange,
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
        timeRangeTranslation = Map.of(_timeRangeTranslation),
        histogramTimeRange = Map.of(_timeRangeTranslation).keys.toList(),
        activeHistogramRange = TimeRange.OneDay;
}


DetailsPageState detailsPageReducer(DetailsPageState state, action) {
  return DetailsPageState(
    details: _detailsReducer(state.details, action),
    activeHistogramRange: _histogramTimeRangeReducer(state.activeHistogramRange, action),
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
