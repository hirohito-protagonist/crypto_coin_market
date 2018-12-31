import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:crypto_coin_market/redux/reducers.dart';
import 'package:crypto_coin_market/widgets/coin_list_tile.widget.dart';
import 'package:crypto_coin_market/actions/markets.action.dart';
import 'package:crypto_coin_market/actions/navigation.action.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';
import 'package:crypto_coin_market/model/markets_view.model.dart';


class MarketsPage extends StatelessWidget {
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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ) :
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

  _ViewModel({
    this.markets,
    this.activeCurrency,
    this.availableCurrencies,
    this.activePage,
    this.onChangeCurrency,
    this.onPageChange,
    this.onNavigateToDetails,
  });

  factory _ViewModel.create(Store<AppState> store) {

    return _ViewModel(
      activeCurrency: store.state.activeCurrency,
      markets: store.state.markets,
      availableCurrencies: store.state.availableCurrencies,
      activePage: store.state.activePage,
      onChangeCurrency: (String currency) => store.dispatch(MarketsChangeCurrencyAction(currency: currency)),
      onNavigateToDetails: (DetailsViewModel model) => store.dispatch(NavigationChangeToDetailsPageAction(data: model)),
      onPageChange: (num page) => store.dispatch(MarketsChangePageAction(page: page)),
    );
  }
}