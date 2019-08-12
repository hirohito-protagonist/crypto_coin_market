import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crypto_coin_market/widgets/price_change.widget.dart';

void main() {


  testWidgets('Should render price change as black when it was not change in the price', (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PriceChange(
          change: 0,
          price: '5.98',
        ),
      ),
    ));

    expect(find.text('5.98%'), findsOneWidget);
    expect(find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.style == TextStyle(color: Colors.black),
      description: 'Black text for unchanged price change',
    ), findsOneWidget);
  });

  testWidgets('Should render price change as red when the price go down', (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PriceChange(
          change: -2.5,
          price: '5.98',
        ),
      ),
    ));

    expect(find.text('5.98%'), findsOneWidget);
    expect(find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.style == TextStyle(color: Colors.red),
      description: 'Red text for price change going down',
    ), findsOneWidget);
  });

  testWidgets('Should render price change as green when the price go up', (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PriceChange(
          change: 3,
          price: '5.98',
        ),
      ),
    ));

    expect(find.text('5.98%'), findsOneWidget);
    expect(find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.style == TextStyle(color: Colors.green),
      description: 'Green text for price change going up',
    ), findsOneWidget);
  });
}