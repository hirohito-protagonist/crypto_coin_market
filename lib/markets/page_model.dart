import 'package:redux/redux.dart';
import 'package:crypto_coin_market/reducers/reducers.dart';
import 'package:crypto_coin_market/actions/actions.dart';
import 'package:crypto_coin_market/model/model.dart';

import './actions.dart';

class PageModel {
  final MarketsViewModel markets;
  final String activeCurrency;
  final List<String> availableCurrencies;
  final num activePage;
  final Function(String) onChangeCurrency;
  final Function(num) onPageChange;
  final Function(DetailsViewModel) onNavigateToDetails;
  final Function() onRequestData;

  PageModel({
    this.markets,
    this.activeCurrency,
    this.availableCurrencies,
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
      activePage: store.state.marketsPageState.page,
      onChangeCurrency: (String currency) =>
          store.dispatch(MarketsChangeCurrencyAction(currency: currency)),
      onNavigateToDetails: (DetailsViewModel model) =>
          store.dispatch(NavigationChangeToDetailsPageAction(data: model)),
      onPageChange: (num page) =>
          store.dispatch(MarketsChangePageAction(page: page)),
      onRequestData: () => store.dispatch(MarketsRequestDataAction()),
    );
  }
}
