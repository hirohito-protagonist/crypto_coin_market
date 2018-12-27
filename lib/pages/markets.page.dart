import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:crypto_coin_market/redux/reducers.dart';
import 'package:crypto_coin_market/widgets/coin_list_tile.widget.dart';
import 'package:crypto_coin_market/actions/details.action.dart';
import 'package:crypto_coin_market/actions/markets.action.dart';
import 'package:crypto_coin_market/actions/navigation.action.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';


class MarketsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Markets'),
          actions: <Widget>[
          ],
        ),
        body: StoreConnector<AppState, Store<AppState>>(
          converter: (Store<AppState> store) => store,
          builder: (BuildContext context, Store<AppState> store) {

            return store.state.markets.volume.length == 0 ?
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
              itemCount: store.state.markets.volume.length,
              itemBuilder: (context, i) {

                final item = store.state.markets.volumeItem(i);
                return CoinListTile(
                    imageUrl: item.imageUrl,
                    name: item.name,
                    fullName: item.fullName,
                    formattedPrice: item.price,
                    formattedPriceChange: item.priceChangeDisplay,
                    priceChange: item.priceChange,
                    onSelect: (SelectedCoinTile data) {
                      store.dispatch(NavigationChangeToDetailsPageAction(
                          data: DetailsViewModel(
                            currency: store.state.activeCurrency,
                            coinInformation: DetailsCoinInformation(
                              priceChange: data.priceChange,
                              fullName: data.fullName,
                              imageUrl: data.imageUrl,
                              name: data.name,
                              formattedPriceChange: data.formattedPriceChange,
                              formattedPrice: data.formattedPrice,
                            ),
                          )
                      ));
                      store.dispatch(DetailsRequestHistogramDataAction());
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
              StoreConnector<AppState, Store<AppState>>(
                converter: (Store<AppState> store) => store,
                builder: (BuildContext context, Store<AppState> store) {

                  return DropdownButton(
                    value: store.state.activePage + 1,
                    items: List.generate(26, (i) => i + 1).map((int value) {
                      return new DropdownMenuItem<num>(
                        value: value,
                        child: new Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (page) {
                      store.dispatch(MarketsChangePageAction(page: page - 1,));
                    },
                  );
                },
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
              StoreConnector<AppState, Store<AppState>>(
                  converter: (Store<AppState> store) => store,
                  builder: (BuildContext context, Store<AppState> store) {
                    return DropdownButton(
                      value: store.state.activeCurrency,
                      items: store.state.availableCurrencies.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (String currency) {
                        store.dispatch(MarketsChangeCurrencyAction(currency: currency));
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