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
  ServiceDataState dataState() => this.dataSourceSelectors.volume().state;
  List<_VolumeItemModel> data() {
    final prices = this.dataSourceSelectors.prices().response;
    return this.dataSourceSelectors.volume().response.length == 0 ? List.unmodifiable([]) :
    this.dataSourceSelectors.volume().response.map((volume) =>
        _aggregateVolumeAndPrice(volume, prices)).toList();

  }
  onChangeCurrency(String currency) => this.store.dispatch(ChangeCurrencyAction(currency: currency));
  onNavigateToDetails(CoinInformation coinInformation) =>
    this.store.dispatch(NavigationChangeToDetailsPageAction(coinInformation: coinInformation));
  onPageChange(num page) =>
    this.store.dispatch(MarketsChangePageAction(page: page));
  onRequestData() => this.store.dispatch(MarketsRequestDataAction());
  onRefresh() => this.store.dispatch(MarketsRefresh());
}

_VolumeItemModel _aggregateVolumeAndPrice(TotalVolume volume, MultipleSymbols prices) {
  final currency = volume?.coinInfo?.name;
  final displayPriceNode = prices.display.containsKey(currency) ? prices.display[currency] : null;
  final rawPriceNode = prices.raw.containsKey(currency) ? prices.raw[currency] : null;
  final price = displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['PRICE'] : '';
  final priceChangeDisplay = displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : '';
  final priceChange = rawPriceNode != null ? Map.of(rawPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : 0;
  return _VolumeItemModel(
    name: currency,
    imageUrl: volume?.coinInfo?.imageUrl,
    fullName: volume?.coinInfo?.fullName,
    price: price,
    priceChange: priceChange,
    priceChangeDisplay: priceChangeDisplay,
  );
}

class _VolumeItemModel {

  final String name;
  final String imageUrl;
  final String fullName;
  final String price;
  final String priceChangeDisplay;
  final num priceChange;

  _VolumeItemModel({
    @required this.name,
    @required this.imageUrl,
    @required this.fullName,
    @required this.price,
    @required this.priceChangeDisplay,
    @required this.priceChange,
  });
}