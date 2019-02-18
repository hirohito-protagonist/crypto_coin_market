import 'package:flutter/foundation.dart';

import 'package:crypto_coin_market/data_source/data_source.dart';
import './model.dart';

class DetailsUpdate {

  final DetailsModel details;

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

class DetailsRefresh {}