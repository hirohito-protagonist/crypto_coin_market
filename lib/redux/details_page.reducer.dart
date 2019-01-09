import 'package:flutter/foundation.dart';
import 'package:crypto_coin_market/model/histogram_data.model.dart';
import 'package:crypto_coin_market/services/histogram.service.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';
import 'package:crypto_coin_market/actions/markets.action.dart';
import 'package:crypto_coin_market/actions/details.action.dart';
import 'package:crypto_coin_market/actions/navigation.action.dart';

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
    details: detailsReducer_(state.details, action),
    histogramData: histogramReducer_(state.histogramData, action),
    activeHistogramRange: histogramTimeRangeReducer_(state.activeHistogramRange, action),
    histogramTimeRange: state.histogramTimeRange,
    timeRangeTranslation: state.timeRangeTranslation,
  );
}


TimeRange histogramTimeRangeReducer_(TimeRange state, action) {

  if (action is  DetailsHistogramTimeRange) {
    return action.timeRange;
  }
  return state;
}



List<HistogramDataModel> histogramReducer_(List<HistogramDataModel> state, action) {

  if (action is DetailsRequestHistogramDataAction) {
    return List.unmodifiable([]);
  }

  if (action is DetailsResponseHistogramDataAction) {
    return List.unmodifiable(action.data);
  }
  return state;
}

DetailsViewModel detailsReducer_(DetailsViewModel state, action) {

  if (action is NavigationChangeToDetailsPageAction) {

    return action.data;
  }
  if (action is DetailsUpdate) {

    return action.details;
  }
  return state;
}