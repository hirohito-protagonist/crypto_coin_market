import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_coin_market/model/currency.model.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';
import 'package:crypto_coin_market/model/histogram_data.model.dart';
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
  List<HistogramDataModel> histData = [];
  String activeHistogramRange = '1D';
  _SelectionChartSliderValue _selectionChartSliderValue = _SelectionChartSliderValue(
    close: '',
    date: '',
    low: '',
    high: ''
  );
  bool isRefresh = true;

  Future<Null> updateData() async {
    final currency = widget.data.coinInformation.name;
    final prices = await allPriceMultiFull(http.Client(), [currency], Currency.fromCurrencyCode(widget.data.currency));
    final histOHLCV = await resolveHistOHLCV(activeHistogramRange, widget.data.currency, currency);

    setState(() {
      histData = histOHLCV;
      _selectionChartSliderValue = _SelectionChartSliderValue(
        close: histData[0].close.toString(),
        date: histData[0].time.toString(),
        high: histData[0].high.toString(),
        low: histData[0].low.toString(),
      );
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
        title: Text(data.fullName),
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
                child: _buildCoinInformation()
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: _buildCoinCostCardInformation(),
                    ),
                    _buildCoinVolumeCardInformation(),
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

  Widget _buildCoinCostCardInformation() {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 15.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_selectionChartSliderValue.close == '' ?  '' : 'Close: ${_selectionChartSliderValue.close}'),
                  Text(
                    _selectionChartSliderValue.low == '' ?  '' : ' Low: ${_selectionChartSliderValue.low}',
                    style: TextStyle(
                        color: Colors.red
                    ),
                  ),
                  Text(
                    _selectionChartSliderValue.high == '' ?  '' : ' High: ${_selectionChartSliderValue.high}',
                    style: TextStyle(
                        color: Colors.green
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildCoinCostChart(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 15.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_selectionChartSliderValue.date == '' ? '' : '${_selectionChartSliderValue.date}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinVolumeCardInformation() {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Text('Volume'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: _buildCoinVolumeChart(),
          ),
        ],
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
      child: Padding(
        padding: EdgeInsets.all(8.0),
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
      ),
    );
  }

  Widget _buildCoinInformation() {
    final data = widget.data.coinInformation;
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
              placeholder: CircularProgressIndicator(),
              imageUrl: data.imageUrl,
              height: 30.0,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '1 ${data.name} = ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                  Text(
                    '${data.formattedPrice}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                ],
              ),
            ),
            PriceChange(
              change: data.priceChange,
              price: data.formattedPriceChange,
            ),
          ],
        ),
      ),
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
              _selectionChartSliderValue = _SelectionChartSliderValue(
                date: domain.toString(),
                close: d.close.toString(),
                high: d.high.toString(),
                low: d.low.toString(),
              );
            });
          }
        });
      }

      SchedulerBinding.instance.addPostFrameCallback(rebuild);
    }
  }

  static List<charts.Series<LinearTime, DateTime>> _createHistCostData(List<HistogramDataModel> histData)  {
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

  static List<charts.Series<LinearTime, DateTime>> _createHistVolumeData(List<HistogramDataModel> histData)  {

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


class _SelectionChartSliderValue {
  final String date;
  final String close;
  final String high;
  final String low;

  _SelectionChartSliderValue({this.date, this.close, this.high, this.low});
}