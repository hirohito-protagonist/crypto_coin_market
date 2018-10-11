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
  bool isRefresh = true;

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
      isRefresh = false;
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
                child: Row(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(0.0),
                        alignment: Alignment.center,
                        child: isRefresh ?
                        CircularProgressIndicator() :
                        charts.TimeSeriesChart(
                          _createHistCostData(histData),
                          animate: true,
                          primaryMeasureAxis: charts.NumericAxisSpec(
                            tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
                          ),
                          behaviors: [
                            charts.Slider(
                              initialDomainValue: DateTime.fromMillisecondsSinceEpoch(histData[0]['time'] * 1000),
                              onChangeCallback: _onSliderChange,
                              snapToDatum: true,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 100.0,
                      alignment: Alignment.center,
                      child: isRefresh ?
                        CircularProgressIndicator() :
                        charts.TimeSeriesChart(
                          _createHistVolumeData(histData),
                          animate: true,
                          domainAxis: charts.DateTimeAxisSpec(usingBarRenderer: true),
                          defaultRenderer: charts.BarRendererConfig<DateTime>(),
                        ),
                    ),
                  ],
                ),


              ),
            ],
          ),
        ),
        onRefresh: () async {
          setState(() {
            isRefresh = true;
          });
          await updateData();
        },
      ),
    );
  }

  _onSliderChange(point, dynamic domain, charts.SliderListenerDragState dragState) {
    if (dragState == charts.SliderListenerDragState.end) {
      print(point);
      print(domain);
      histData.forEach((d) {
//      print(DateTime.fromMillisecondsSinceEpoch(d['time'] * 1000));
        if (DateTime.fromMillisecondsSinceEpoch(d['time'] * 1000)
            .isAtSameMomentAs(domain)) {
          print(d);
        }
      });

      print(dragState.toString());
    }
  }

  static List<charts.Series<LinearTime, DateTime>> _createHistCostData(List<dynamic> histData)  {
    final data = histData.map((d) =>
      LinearTime(
        d['close'],
        DateTime.fromMillisecondsSinceEpoch(d['time'] * 1000),
        d['high'],
        0,
        d['volumeto']
      )
    ).toList();

    return [
      charts.Series<LinearTime, DateTime>(
        id: 'TimeSeriesOfClosePrice',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (LinearTime f, _) => f.time,
        measureFn: (LinearTime f, _) => f.close,
        data: data,
      )
    ];
  }

  static List<charts.Series<LinearTime, DateTime>> _createHistVolumeData(List<dynamic> histData)  {
    final data = histData.map((d) =>
      LinearTime(
        d['close'],
        DateTime.fromMillisecondsSinceEpoch(d['time'] * 1000),
        d['high'],
        0,
        d['volumeto']
      )
    ).toList();

    return [
      charts.Series<LinearTime, DateTime>(
        id: 'TimeSeriesOfVolume',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (LinearTime f, _) => f.time,
        measureFn: (LinearTime f, _) => f.volumeTo,
        data: data,
      )
    ];
  }
}

class LinearTime {
  final num close;
  final num high;
  final num low;
  final DateTime time;
  final num volumeTo;

  LinearTime(this.close, this.time, this.high, this.low, this.volumeTo);
}