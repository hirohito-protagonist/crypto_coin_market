import 'package:flutter/material.dart';

import 'package:crypto_coin_market/model/model.dart';

class NavigationKeys {
  static final navigationState = new GlobalKey<NavigatorState>();
}

class NavigationChangeToDetailsPageAction {
  final DetailsViewModel data;
  NavigationChangeToDetailsPageAction({this.data});
}