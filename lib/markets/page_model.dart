import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import 'package:crypto_coin_market/core/core.dart';

import './actions.dart';
import './model.dart';

class PageModel {
  final MarketsModel markets;
  final String activeCurrency;
  final List<String> availableCurrencies;
  final num activePage;
  final ServiceDataState dataState;
  final Function(String) onChangeCurrency;
  final Function(num) onPageChange;
  final Function(CoinInformation) onNavigateToDetails;
  final Function() onRequestData;
  final Function() onRefresh;

  PageModel({
    @required this.markets,
    @required this.activeCurrency,
    @required this.availableCurrencies,
    @required this.dataState,
    @required this.activePage,
    @required this.onChangeCurrency,
    @required this.onPageChange,
    @required this.onNavigateToDetails,
    @required this.onRequestData,
    @required this.onRefresh,
  });

  factory PageModel.create(Store<AppState> store) {
    return PageModel(
      activeCurrency: store.state.currency,
      markets: store.state.marketsPageState.markets,
      availableCurrencies: store.state.marketsPageState.availableCurrencies,
      dataState: store.state.marketsPageState.dataState,
      activePage: store.state.marketsPageState.page,
      onChangeCurrency: (String currency) =>
          store.dispatch(MarketsChangeCurrencyAction(currency: currency)),
      onNavigateToDetails: (CoinInformation coinInformation) =>
          store.dispatch(NavigationChangeToDetailsPageAction(coinInformation: coinInformation)),
      onPageChange: (num page) =>
          store.dispatch(MarketsChangePageAction(page: page)),
      onRequestData: () => store.dispatch(MarketsRequestDataAction()),
      onRefresh: () => store.dispatch(MarketsRefresh()),
    );
  }
}
