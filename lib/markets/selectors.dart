import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto_coin_market/core/core.dart';
import 'package:crypto_coin_market/data_source/data_source.dart';

import './actions.dart';


class MarketsSelectors {
  final Store<AppState> store;
  final DataSourceSelectors dataSourceSelectors;
  MarketsSelectors({
    @required this.store,
    @required this.dataSourceSelectors
  }): assert(store != null),
    assert(dataSourceSelectors != null);

  factory MarketsSelectors.create(Store<AppState> store) {
    final dataSourceSelectors = DataSourceSelectors(store: store);
    return MarketsSelectors(
      dataSourceSelectors: dataSourceSelectors,
      store: store,
    );
  }

  String activeCurrency() => this.store.state.currency;
  List<String> availableCurrencies() => this.store.state.marketsPageState.availableCurrencies;
  num activePage() => this.store.state.marketsPageState.page;
  DataSourceSelectors dataSource() => this.dataSourceSelectors;

  onChangeCurrency(String currency) => this.store.dispatch(ChangeCurrencyAction(currency: currency));
  onNavigateToDetails(CoinInformation coinInformation) =>
    this.store.dispatch(NavigationChangeToDetailsPageAction(coinInformation: coinInformation));
  onPageChange(num page) =>
    this.store.dispatch(MarketsChangePageAction(page: page));
  onRequestData() => this.store.dispatch(MarketsRequestDataAction());
  onRefresh() => this.store.dispatch(MarketsRefresh());
}