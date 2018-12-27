import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:crypto_coin_market/redux/reducers.dart';

import 'package:crypto_coin_market/actions/markets.action.dart';
import 'package:crypto_coin_market/actions/navigation.action.dart';

import 'package:crypto_coin_market/pages/markets.page.dart';
import 'package:crypto_coin_market/pages/details.page.dart';

void main() => runApp(CoinMarketApp());
//void main() => runApp(MarketsPage());

//class MarketsPage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Crypto Coin Market',
//      theme: new ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: new MarketsView(
//          title: 'Crypto Coin Market',
//          onSelect: (context, DetailsViewModel data) {
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => DetailsView(
//                title: 'Detail information',
//                data: data,
//              )),
//            );
//          }
//      ),
//    );
//  }
//}


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
        navigatorKey: NavigationKeys.navigationState,
        home: StoreBuilder<AppState>(
          onInit: (store) => store.dispatch(MarketsRequestDataAction()),
          builder: (BuildContext context, Store<AppState> store) => MarketsPage(),
        ),
        routes: <String, WidgetBuilder>{
          '/details': (BuildContext context) => DetailsPage()
        },
      )
    );
  }
}
