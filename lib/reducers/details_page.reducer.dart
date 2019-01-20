import 'package:flutter/foundation.dart';

import 'package:crypto_coin_market/model/model.dart';
import 'package:crypto_coin_market/actions/actions.dart';
import 'package:crypto_coin_market/services/services.dart';

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


DetailsPageState detailsPageReducer(DetailsPageState state, action) {
  return DetailsPageState(
    details: _detailsReducer(state.details, action),
    histogramData: _histogramReducer(state.histogramData, action),
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



List<HistogramDataModel> _histogramReducer(List<HistogramDataModel> state, action) {

  if (action is HistogramRequestDataAction) {
    return List.unmodifiable([]);
  }

  if (action is HistogramResponseDataAction) {
    return List.unmodifiable(action.data);
  }
  return state;
}

DetailsViewModel _detailsReducer(DetailsViewModel state, action) {

  if (action is NavigationChangeToDetailsPageAction) {

    return action.data;
  }
  if (action is DetailsUpdate) {

    return action.details;
  }
  return state;
}