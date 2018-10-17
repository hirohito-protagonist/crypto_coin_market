import 'dart:async';
import 'package:flutter/scheduler.dart';
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
  List<_HistogramDataModel> histData = [];
  String activeHistogramRange = '1D';
  _SliderValueModel sliderModel = _SliderValueModel(close: '', date: '');
  bool isRefresh = true;

  Future<Null> updateData() async {
    final currency = widget.data.coinInformation.name;
    final prices = await allPriceMultiFull(http.Client(), [currency], Currency.fromCurrencyCode(widget.data.currency));
    final histOHLCV = await resolveHistOHLCV(activeHistogramRange, widget.data.currency, currency);

    setState(() {
      histData = List.of(histOHLCV['Data']).map((raw) => _HistogramDataModel.fromJson(raw)).toList();
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
                child: _buildCoinInformation()
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                      child: Row(
                        children: <Widget>[
                          Text(sliderModel.date == '' ? '' : 'Date: ${sliderModel.date}'),
                          Text(sliderModel.close == '' ?  '' : ' Close: ${sliderModel.close}'),
                        ],
                      ),
                    ),
                    _buildCoinCostChart(),
                    _buildCoinVolumeChart(),
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            DropdownButton(
              value: activeHistogramRange,
              items: ['1H', '1D', '1W', '1M'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                activeHistogramRange = value;
                setState(() {
                  _refreshKey.currentState.show();
                });
              },
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinVolumeChart() {
    return Container(
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
    );
  }

  Widget _buildCoinCostChart() {
    return Expanded(
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
              initialDomainValue: histData[0].time,
              onChangeCallback: _onSliderChange,
              snapToDatum: true,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCoinInformation() {
    final data = widget.data.coinInformation;
    return Row(
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
    );
  }

  resolveHistOHLCV(String range, String currency, String cryptoCoin) async {
    var method = range == '1H' || range == '1D' ? minuteHistoryOHLCV : hourlyHistoryOHLCV;
    var limit = range == '1H' ? 60 : range == '1D' ? 144 : range == '1W' ? 168 : 120;
    var aggregate = range == '1H' ? 1 : range == '1D' ? 10 : range == '1W' ? 1 : 6;
    return await method(http.Client(), Currency.fromCurrencyCode(currency), cryptoCoin, limit, aggregate);
  }

  _onSliderChange(point, dynamic domain, charts.SliderListenerDragState dragState) {
    if (dragState == charts.SliderListenerDragState.end) {
      void rebuild(_) {

        histData.forEach((d) {
          final date = d.time;

          if (date.isAtSameMomentAs(domain)) {
            setState(() {
              sliderModel = _SliderValueModel(date: domain.toString(), close: d.close.toString());
            });
          }
        });
      }

      SchedulerBinding.instance.addPostFrameCallback(rebuild);
    }
  }

  static List<charts.Series<LinearTime, DateTime>> _createHistCostData(List<_HistogramDataModel> histData)  {
    final data = histData.map((d) => LinearTime(d.close, d.time, d.high, 0, d.volumeTo)).toList();

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

  static List<charts.Series<LinearTime, DateTime>> _createHistVolumeData(List<_HistogramDataModel> histData)  {

    final data = histData.map((d) => LinearTime(d.close, d.time, d.high, 0, d.volumeTo)).toList();

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

class _HistogramDataModel {

  final DateTime time;
  final num close;
  final num high;
  final num low;
  final num open;
  final num volumeFrom;
  final num volumeTo;

  _HistogramDataModel({this.time, this.close, this.high, this.low, this.open,
      this.volumeFrom, this.volumeTo});


  factory _HistogramDataModel.fromJson(dynamic json) {
    return _HistogramDataModel(
      close: json['close'],
      high: json['high'],
      low: json['low'],
      open: json['open'],
      time: DateTime.fromMillisecondsSinceEpoch(json['time'] * 1000),
      volumeFrom: json['volumefrom'],
      volumeTo: json['volumeto'],
    );
  }
}

class _SliderValueModel {
  final String date;
  final String close;

  _SliderValueModel({this.date, this.close});
}