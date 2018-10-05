import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_coin_market/model/currency.model.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_coin_market/widgets/price_change.widget.dart';
import 'package:crypto_coin_market/crypto_compare.service.dart';


class DetailsView extends StatefulWidget {
  final String title;
  DetailsViewModel data;

  DetailsView({Key key, @required this.title, @required this.data})
      : super(key: key);

  @override
  _DetailsView createState() => _DetailsView();
}

class _DetailsView extends State<DetailsView> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var histData = [];
  bool refreshData = true;

  Future<Null> updateData() async {
    final currency = widget.data.coinInformation.name;
    final prices = await allPriceMultiFull(http.Client(), [currency], Currency.fromCurrencyCode(widget.data.currency));
    final histOHLCV = await dailyHistoryOHLCV(http.Client(), Currency.fromCurrencyCode(widget.data.currency), currency);

    setState(() {
      histData = List.of(histOHLCV['Data']);
      final displayPriceNode = prices.display.containsKey(currency) ? prices.display[currency] : null;
      final rawPriceNode = prices.raw.containsKey(currency) ? prices.raw[currency] : null;
      final coinModel = new DetailsCoinInformation(
        formattedPriceChange: displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : '',
        priceChange: rawPriceNode != null ? Map.of(rawPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : 0,
        formattedPrice: displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['PRICE'] : '',
        name: widget.data.coinInformation.name,
        imageUrl: widget.data.coinInformation.imageUrl,
        fullName: widget.data.coinInformation.fullName
      );
      widget.data = new DetailsViewModel(
        coinInformation: coinModel,
        currency: widget.data.currency,
      );
      refreshData = false;
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data.coinInformation;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              _refreshKey.currentState.show();
              ;
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        child: Container(
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
                height: 150.0,
                child:               Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        CachedNetworkImage(
                          placeholder: CircularProgressIndicator(),
                          imageUrl: data.imageUrl,
                          height: 100.0,
                        ),
                        Text(data.fullName),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '1 ${data.name} = ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            Text(
                              '${data.formattedPrice}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            PriceChange(
                              change: data.priceChange,
                              price: data.formattedPriceChange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(0.0),
                  alignment: Alignment.center,
                  child: refreshData ?  CircularProgressIndicator() : charts.TimeSeriesChart(_createSampleData(histData), animate: true),
                ),
              ),
            ],
          ),
        ),
        onRefresh: () async {
          setState(() {
            refreshData = true;
          });
          await updateData();
        },
      ),
    );
  }

  static List<charts.Series<LinearFake, DateTime>> _createSampleData(List<dynamic> histData)  {
    final data = histData.map((d) {
      return new LinearFake(d['close'], DateTime.fromMillisecondsSinceEpoch(d['time']), d['high'], d['low']);
    }).toList();

    return [
      new charts.Series<LinearFake, DateTime>(
        id: 'Fake',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (LinearFake f, _) => f.time,
        measureFn: (LinearFake f, _) => f.close,
        measureLowerBoundFn: (LinearFake f, _) => f.low,
        measureUpperBoundFn: (LinearFake f, _) => f.high,
        data: data,
      )
    ];
  }
}

class LinearFake {
  final num close;
  final num high;
  final num low;
  final DateTime time;

  LinearFake(this.close, this.time, this.high, this.low);
}