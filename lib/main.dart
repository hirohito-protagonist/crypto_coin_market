import 'package:flutter/material.dart';
import 'package:crypto_coin_market/views/markets.view.dart';
import 'package:crypto_coin_market/views/details.view.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:crypto_coin_market/redux/reducers.dart';
import 'package:crypto_coin_market/widgets/coin_list_tile.widget.dart';

void main() => runApp(CoinMarketApp());
//void main() => runApp(MarketsPage());

class MarketsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Crypto Coin Market',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MarketsView(
          title: 'Crypto Coin Market',
          onSelect: (context, DetailsViewModel data) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailsView(
                title: 'Detail information',
                data: data,
              )),
            );
          }
      ),
    );
  }
}


class CoinMarketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Store<AppState> store = Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: [appStateMiddleware],
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Crypto Coin Market',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: Keys.navKey,
        home: StoreBuilder<AppState>(
          onInit: (store) => store.dispatch(MarketsDataAction()),
          builder: (BuildContext context, Store<AppState> store) =>
              MarketsViewPage(),
        ),
        routes: <String, WidgetBuilder>{
          '/details': (BuildContext context) => DetailsViewPage()
        },
      )
    );
  }
}


class MarketsViewPage extends StatelessWidget {
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
                    store.dispatch(DetailsChangePageAction(
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
                    store.dispatch(ChangePageAction(page: page - 1,));
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
                    store.dispatch(ChangeCurrencyAction(currency: currency));
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


class DetailsViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StoreConnector<AppState, Store<AppState>>(
          converter: (Store<AppState> store) => store,
          builder: (BuildContext context, Store<AppState> store) => Text(store.state.details.coinInformation.fullName)
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(0.0),
              alignment: Alignment.center,
              width: 1.7976931348623157e+308,
              child: Text('Coin Information here'),
            ),
          ],
        ),
      ),
    );
  }

}