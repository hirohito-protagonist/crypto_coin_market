import 'package:flutter/foundation.dart';

import 'package:crypto_coin_market/data_source/data_source.dart';


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