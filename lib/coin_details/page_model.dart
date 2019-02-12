import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import 'package:crypto_coin_market/data_source/data_source.dart';
import 'package:crypto_coin_market/core/core.dart';

import './actions.dart';
import './model.dart';

class PageModel {
  final String activeCurrency;
  final List<String> availableCurrencies;
  final DetailsModel details;
  final Map<TimeRange, String> timeRangeTranslation;
  final List<TimeRange> histogramTimeRange;
  final TimeRange activeHistogramRange;
  final List<HistogramDataModel> histogramData;
  final ServiceDataState histogramDataState;
  final Function() onRequestHistogramData;
  final Function(String) onChangeCurrency;
  final Function(TimeRange) onHistogramTimeRangeChange;
  final Function() onRefresh;

  PageModel({
    @required this.details,
    @required this.activeCurrency,
    @required this.availableCurrencies,
    @required this.histogramData,
    @required this.histogramTimeRange,
    @required this.timeRangeTranslation,
    @required this.activeHistogramRange,
    @required this.onRequestHistogramData,
    @required this.onChangeCurrency,
    @required this.onHistogramTimeRangeChange,
    @required this.onRefresh,
    @required this.histogramDataState,
  });

  factory PageModel.create(Store<AppState> store) {
    return PageModel(
      activeCurrency: store.state.currency,
      availableCurrencies: store.state.marketsPageState.availableCurrencies,
      details: store.state.detailsPageState.details,
      histogramData: store.state.detailsPageState.histogramData,
      activeHistogramRange: store.state.detailsPageState.activeHistogramRange,
      histogramTimeRange: store.state.detailsPageState.histogramTimeRange,
      timeRangeTranslation: store.state.detailsPageState.timeRangeTranslation,
      histogramDataState: store.state.detailsPageState.histogramDataState,
      onRequestHistogramData: () =>
          store.dispatch(HistogramRequestDataAction()),
      onChangeCurrency: (String currency) =>
          store.dispatch(DetailsChangeCurrencyAction(currency: currency)),
      onHistogramTimeRangeChange: (TimeRange timeRange) =>
          store.dispatch(DetailsHistogramTimeRange(timeRange: timeRange)),
      onRefresh: () => store.dispatch(DetailsRefresh()),
    );
  }
}