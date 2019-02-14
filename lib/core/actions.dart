import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:crypto_coin_market/data_source/data_source.dart';

import './model.dart';

class NavigationKeys {
  static final navigationState = new GlobalKey<NavigatorState>();
}

class NavigationChangeToDetailsPageAction {
  final CoinInformation coinInformation;
  NavigationChangeToDetailsPageAction({
    @required this.coinInformation
  });
}


class MarketsLoadingDataAction {
  final ServiceDataState dataState = ServiceDataState.Loading;
}

class MarketsErrorDataAction {
  final ServiceDataState dataState = ServiceDataState.Error;
}

class MarketsSuccessDataAction {
  final ServiceDataState dataState = ServiceDataState.Success;
}


class HistogramLoadingDataAction {
  final ServiceDataState dataState = ServiceDataState.Loading;
}

class HistogramErrorDataAction {
  final ServiceDataState dataState = ServiceDataState.Error;
}

class HistogramSuccessDataAction {
  final ServiceDataState dataState = ServiceDataState.Success;
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