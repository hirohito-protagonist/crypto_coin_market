import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crypto_coin_market/widgets/coin_list_tile.widget.dart';

void main() {
  testWidgets('Should render content with defualt data',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(
          children: <Widget>[CoinListTile()],
        ),
      ),
    ));

    expect(find.text(''), findsNWidgets(4));
    expect(find.text('%'), findsNothing);
  });

  testWidgets('Should render content with provided data',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(
          children: <Widget>[
            CoinListTile(
              name: 'BTC',
              fullName: 'Bitcoin',
              formattedPrice: '\$ 7000',
              formattedPriceChange: '5.98%',
              priceChange: 1.2,
            ),
          ],
        ),
      ),
    ));

    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('\$ 7000'), findsOneWidget);
    expect(find.text('5.98%'), findsOneWidget);
  });

  testWidgets(
      'Should render price change as black when it was not change in the price',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(
          children: <Widget>[
            CoinListTile(
              priceChange: 0,
            ),
          ],
        ),
      ),
    ));

    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.style ==
                  TextStyle(
                    color: const Color(0xFFa2aed0),
                    fontWeight: FontWeight.bold,
                  ),
          description: 'Black text for unchanged price change',
        ),
        findsOneWidget);
  });

  testWidgets('Should render price change as red when the price go down',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(
          children: <Widget>[
            CoinListTile(
              priceChange: -2.5,
            ),
          ],
        ),
      ),
    ));

    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.style ==
                  TextStyle(
                    color: const Color(0xFFff66b9),
                    fontWeight: FontWeight.bold,
                  ),
          description: 'Red text for price change going down',
        ),
        findsOneWidget);
  });

  testWidgets('Should render price change as green when the price go up',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(
          children: <Widget>[
            CoinListTile(
              priceChange: 3,
            ),
          ],
        ),
      ),
    ));

    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.style ==
                  TextStyle(
                    color: const Color(0xFFa2ea76),
                    fontWeight: FontWeight.bold,
                  ),
          description: 'Green text for price change going up',
        ),
        findsOneWidget);
  });
}
