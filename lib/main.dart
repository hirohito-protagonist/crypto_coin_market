import 'package:flutter/material.dart';
import 'package:crypto_coin_market/views/markets.view.dart';
import 'package:crypto_coin_market/views/details.view.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:crypto_coin_market/redux/reducers.dart';
import 'package:crypto_coin_market/model/markets_view.model.dart';
import 'package:crypto_coin_market/widgets/coin_list_tile.widget.dart';

//void main() => runApp(CoinMarketApp());
void main() => runApp(MarketsPage());

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
        home: StoreBuilder<AppState>(
          onInit: (store) => store.dispatch(MarketsDataAction()),
          builder: (BuildContext context, Store<AppState> store) =>
              MarketsViewPage(),
        ),
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
      body: StoreConnector<AppState, MarketsViewModel>(
        converter: (Store<AppState> store) => store.state.markets,
        builder: (BuildContext context, MarketsViewModel markets) {

          return markets.volume.length == 0 ?
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
              itemCount: markets.volume.length,
              itemBuilder: (context, i) {

                final item = markets.volumeItem(i);
                return CoinListTile(
                  imageUrl: item.imageUrl,
                  name: item.name,
                  fullName: item.fullName,
                  formattedPrice: item.price,
                  formattedPriceChange: item.priceChangeDisplay,
                  priceChange: item.priceChange,
                  onSelect: (SelectedCoinTile data) {}
                );
            },
          );
        },
      ),
    );
  }
}