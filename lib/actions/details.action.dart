import 'package:flutter/foundation.dart';

import 'package:crypto_coin_market/model/model.dart';
import 'package:crypto_coin_market/services/services.dart';

class DetailsRequestHistogramDataAction {}

class DetailsResponseHistogramDataAction {
  List<HistogramDataModel> data;

  DetailsResponseHistogramDataAction({
    @required this.data
  });
}

class DetailsChangeCurrencyAction {
  final String currency;
  DetailsChangeCurrencyAction({
    @required this.currency
  });
}

class DetailsUpdate {

  final DetailsViewModel details;

  DetailsUpdate({
    @required this.details
  });
}

class DetailsHistogramTimeRange {
  final TimeRange timeRange;

  DetailsHistogramTimeRange({
    @required this.timeRange
  });
}