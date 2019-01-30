import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:crypto_coin_market/data_source/data_source.dart';

class NavigationKeys {
  static final navigationState = new GlobalKey<NavigatorState>();
}

class NavigationChangeToDetailsPageAction {
  final DetailsViewModel data;
  NavigationChangeToDetailsPageAction({
    @required this.data
  });
}

class MarketsRequestDataAction {}
class MarketsResponseDataAction {
  final List<TotalVolume> volume;
  final MultipleSymbols prices;

  MarketsResponseDataAction({
    @required this.volume,
    @required this.prices,
  });
}

class HistogramRequestDataAction {}
class HistogramResponseDataAction {
  List<HistogramDataModel> data;

  HistogramResponseDataAction({
    @required this.data
  });
}