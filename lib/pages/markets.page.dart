import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:crypto_coin_market/reducers/app.reducer.dart';
import 'package:crypto_coin_market/widgets/coin_list_tile.widget.dart';
import 'package:crypto_coin_market/widgets/loading.widget.dart';
import 'package:crypto_coin_market/actions/markets.action.dart';
import 'package:crypto_coin_market/actions/navigation.action.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';
import 'package:crypto_coin_market/model/markets_view.model.dart';


class MarketsPage extends StatelessWidget {

  final Store<AppState> store;

  MarketsPage({ this.store }) {
    final model = _ViewModel.create(this.store);
    model.onRequestData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Markets'),
          actions: <Widget>[
          ],
        ),
        body: StoreConnector<AppState, _ViewModel>(
          converter: (Store<AppState> store) => _ViewModel.create(store),
          builder: (BuildContext context, _ViewModel model) {

            return model.markets.volume.length == 0 ?
            Loading() :
            ListView.builder(
              itemCount: model.markets.volume.length,
              itemBuilder: (context, i) {

                final item = model.markets.volumeItem(i);
                return CoinListTile(
                    imageUrl: item.imageUrl,
                    name: item.name,
                    fullName: item.fullName,
                    formattedPrice: item.price,
                    formattedPriceChange: item.priceChangeDisplay,
                    priceChange: item.priceChange,
                    onSelect: (SelectedCoinTile data) {
                      model.onNavigateToDetails(DetailsViewModel(
                        currency: model.activeCurrency,
                        coinInformation: DetailsCoinInformation(
                          priceChange: data.priceChange,
                          fullName: data.fullName,
                          imageUrl: data.imageUrl,
                          name: data.name,
                          formattedPriceChange: data.formattedPriceChange,
                          formattedPrice: data.formattedPrice,
                        ),
                      ));
                    }
                );
              },
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              StoreConnector<AppState, _ViewModel>(
                converter: (Store<AppState> store) => _ViewModel.create(store),
                builder: (BuildContext context, _ViewModel model) {

                  return DropdownButton(
                    value: model.activePage + 1,
                    items: List.generate(26, (i) => i + 1).map((int value) {
                      return new DropdownMenuItem<num>(
                        value: value,
                        child: new Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (page) {
                      model.onPageChange(page - 1);
                    },
                  );
                },
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
              StoreConnector<AppState, _ViewModel>(
                  converter: (Store<AppState> store) => _ViewModel.create(store),
                  builder: (BuildContext context, _ViewModel model) {
                    return DropdownButton(
                      value: model.activeCurrency,
                      items: model.availableCurrencies.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (String currency) {
                        model.onChangeCurrency(currency);
                      },
                    );
                  }
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
            ],
          ),
        )
    );
  }
}

class _ViewModel {
  final MarketsViewModel markets;
  final String activeCurrency;
  final List<String> availableCurrencies;
  final num activePage;
  final Function(String) onChangeCurrency;
  final Function(num) onPageChange;
  final Function(DetailsViewModel) onNavigateToDetails;
  final Function() onRequestData;

  _ViewModel({
    this.markets,
    this.activeCurrency,
    this.availableCurrencies,
    this.activePage,
    this.onChangeCurrency,
    this.onPageChange,
    this.onNavigateToDetails,
    this.onRequestData,
  });

  factory _ViewModel.create(Store<AppState> store) {

    return _ViewModel(
      activeCurrency: store.state.currency,
      markets: store.state.marketsPageState.markets,
      availableCurrencies: store.state.marketsPageState.availableCurrencies,
      activePage: store.state.marketsPageState.page,
      onChangeCurrency: (String currency) => store.dispatch(MarketsChangeCurrencyAction(currency: currency)),
      onNavigateToDetails: (DetailsViewModel model) => store.dispatch(NavigationChangeToDetailsPageAction(data: model)),
      onPageChange: (num page) => store.dispatch(MarketsChangePageAction(page: page)),
      onRequestData: () => store.dispatch(MarketsRequestDataAction()),
    );
  }
}