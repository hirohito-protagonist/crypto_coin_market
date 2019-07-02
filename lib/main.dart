import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:crypto_coin_market/core/core.dart';

import 'package:crypto_coin_market/markets/markets.dart';
import 'package:crypto_coin_market/coin_details/coin_details.dart';

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
        theme: ThemeData(
          brightness:Brightness.dark,
          primarySwatch: Colors.blue,
          primaryColor: const Color.fromARGB(255, 43, 51, 83),
          accentColor: const Color(0xFF64ffda),
          canvasColor: const Color.fromARGB(255, 43, 51, 83),
          backgroundColor: const Color.fromARGB(255, 43, 51, 83),
          bottomAppBarColor: const Color.fromARGB(255, 43, 51, 83),
          cardColor: const Color.fromARGB(255, 68, 79, 123),
          textTheme: TextTheme(
            body1: TextStyle(
              color: const Color.fromARGB(255, 175, 181, 208),
            ),
            body2: TextStyle(
              color: const Color.fromARGB(255, 175, 181, 208),
            ),
            title: TextStyle(
              color: const Color.fromARGB(255, 175, 181, 208),
            ),
            button: TextStyle(
              color: const Color.fromARGB(255, 175, 181, 208),
            ),
            caption: TextStyle(
              color: const Color.fromARGB(255, 175, 181, 208),
            ),
            headline: TextStyle(
              color: const Color.fromARGB(255, 175, 181, 208),
            ),
            subhead: TextStyle(
              color: const Color.fromARGB(255, 175, 181, 208),
            ),
            subtitle: TextStyle(
              color: const Color.fromARGB(255, 175, 181, 208),
            ),
            overline: TextStyle(
              color: const Color.fromARGB(255, 175, 181, 208),
            ),
            display1: TextStyle(
              color: const Color.fromARGB(255, 175, 181, 208),
            ),
            display2: TextStyle(
              color: const Color.fromARGB(255, 175, 181, 208),
            ),
            display3: TextStyle(
              color: const Color.fromARGB(255, 175, 181, 208),
            ),
            display4: TextStyle(
              color: const Color.fromARGB(255, 175, 181, 208),
            ),
          )
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
