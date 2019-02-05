import 'package:redux/redux.dart';
import 'package:crypto_coin_market/core/core.dart';

import './actions.dart';
import './model.dart';

class PageModel {
  final MarketsModel markets;
  final String activeCurrency;
  final List<String> availableCurrencies;
  final num activePage;
  final MarketsDataState dataState;
  final Function(String) onChangeCurrency;
  final Function(num) onPageChange;
  final Function(CoinInformation) onNavigateToDetails;
  final Function() onRequestData;

  PageModel({
    this.markets,
    this.activeCurrency,
    this.availableCurrencies,
    this.dataState,
    this.activePage,
    this.onChangeCurrency,
    this.onPageChange,
    this.onNavigateToDetails,
    this.onRequestData,
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
    );
  }
}
