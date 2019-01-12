import 'package:crypto_coin_market/model/model.dart';
import 'package:crypto_coin_market/services/services.dart';

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