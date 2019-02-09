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
  final Function() onRequestHistogramData;
  final Function(String) onChangeCurrency;
  final Function(TimeRange) onHistogramTimeRangeChange;
  final Function() onRefresh;

  PageModel({
    this.details,
    this.activeCurrency,
    this.availableCurrencies,
    this.histogramData,
    this.histogramTimeRange,
    this.timeRangeTranslation,
    this.activeHistogramRange,
    this.onRequestHistogramData,
    this.onChangeCurrency,
    this.onHistogramTimeRangeChange,
    this.onRefresh,
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