import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import 'package:crypto_coin_market/core/core.dart';
import 'package:crypto_coin_market/data_source/data_source.dart';

import './actions.dart';

class PageModel {
  final DataSourceSelectors dataSourceSelectors;
  final String activeCurrency;
  final List<String> availableCurrencies;
  final num activePage;
  final Function(String) onChangeCurrency;
  final Function(num) onPageChange;
  final Function(CoinInformation) onNavigateToDetails;
  final Function() onRequestData;
  final Function() onRefresh;

  PageModel({
    @required this.activeCurrency,
    @required this.availableCurrencies,
    @required this.activePage,
    @required this.onChangeCurrency,
    @required this.onPageChange,
    @required this.onNavigateToDetails,
    @required this.onRequestData,
    @required this.onRefresh,
    @required this.dataSourceSelectors,
  }):
    assert(activeCurrency != null),
    assert(availableCurrencies != null),
    assert(activePage != null);

  factory PageModel.create(Store<AppState> store) {
    final dataSourceSelectors = DataSourceSelectors(store: store);
    return PageModel(
      dataSourceSelectors: dataSourceSelectors,
      activeCurrency: store.state.currency,
      availableCurrencies: store.state.marketsPageState.availableCurrencies,
      activePage: store.state.marketsPageState.page,
      onChangeCurrency: (String currency) =>
          store.dispatch(ChangeCurrencyAction(currency: currency)),
      onNavigateToDetails: (CoinInformation coinInformation) =>
          store.dispatch(NavigationChangeToDetailsPageAction(coinInformation: coinInformation)),
      onPageChange: (num page) =>
          store.dispatch(MarketsChangePageAction(page: page)),
      onRequestData: () => store.dispatch(MarketsRequestDataAction()),
      onRefresh: () => store.dispatch(MarketsRefresh()),
    );
  }
}
