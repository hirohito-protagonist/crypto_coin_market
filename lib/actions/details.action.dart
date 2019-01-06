import 'package:crypto_coin_market/model/histogram_data.model.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';
import 'package:crypto_coin_market/services/histogram.service.dart';

class DetailsRequestHistogramDataAction {}

class DetailsResponseHistogramDataAction {
  List<HistogramDataModel> data;

  DetailsResponseHistogramDataAction({this.data});
}

class DetailsChangeCurrencyAction {
  final String currency;
  DetailsChangeCurrencyAction({this.currency});
}

class DetailsUpdate {

  final DetailsViewModel details;

  DetailsUpdate({ this.details });
}

class DetailsHistogramTimeRange {
  final TimeRange timeRange;

  DetailsHistogramTimeRange({ this.timeRange });
}