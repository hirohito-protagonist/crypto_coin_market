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

enum MarketsDataState {
  Error, Success, Loading
}

class MarketsLoadingDataAction {
  final MarketsDataState dataState = MarketsDataState.Loading;
}

class MarketsRequestDataAction {
}

class MarketsErrorDataAction {
  final MarketsDataState dataState = MarketsDataState.Error;
}

class MarketsResponseDataAction {
  final List<TotalVolume> volume;
  final MultipleSymbols prices;
  final MarketsDataState dataState = MarketsDataState.Success;

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