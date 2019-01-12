import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:crypto_coin_market/reducers/reducers.dart';
import 'package:crypto_coin_market/actions/actions.dart';
import 'package:crypto_coin_market/pages/pages.dart';

void main() => runApp(CoinMarketApp());


class CoinMarketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Store<AppState> store = Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: appStateMiddleware(),
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Crypto Coin Market',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: NavigationKeys.navigationState,
        home: MarketsPage(
          store: store,
        ),
        routes: <String, WidgetBuilder>{
          '/details': (BuildContext context) => DetailsPage(store: store,)
        },
      )
    );
  }
}
