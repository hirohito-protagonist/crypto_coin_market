import 'package:flutter/foundation.dart';

import 'package:crypto_coin_market/model/model.dart';

class MarketsRequestDataAction {}
class MarketsResponseDataAction {
  final MarketsViewModel data;

  MarketsResponseDataAction({
    @required this.data
  });
}

class HistogramRequestDataAction {}
class HistogramResponseDataAction {
  List<HistogramDataModel> data;

  HistogramResponseDataAction({
    @required this.data
  });
}