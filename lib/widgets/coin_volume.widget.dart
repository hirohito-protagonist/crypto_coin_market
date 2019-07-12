import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:crypto_coin_market/data_source/data_source.dart';

class CoinVolumeWidget extends StatefulWidget {

  List<HistogramDataModel> histData = [];

  CoinVolumeWidget({Key key, this.histData,}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CoinVolumeState(
      histData: histData,
    );
  }

}

class CoinVolumeState extends State<CoinVolumeWidget> {
  List<HistogramDataModel> histData = [];
  bool isRefresh;

  CoinVolumeState({this.histData, this.isRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: _buildCoinVolumeChart(),
          ),
        ],
      )
    );
  }

  Widget _buildCoinVolumeChart() {
    return Container(
      height: 100.0,
      alignment: Alignment.center,
      child:
      charts.TimeSeriesChart(
        _createHistVolumeData(histData),
        animate: true,
        domainAxis: charts.DateTimeAxisSpec(
          usingBarRenderer: true,
          showAxisLine: true,
          renderSpec: charts.SmallTickRendererSpec(
            minimumPaddingBetweenLabelsPx: 0,
            labelStyle: charts.TextStyleSpec(
              color: charts.Color.fromHex(code: '#848eaf'),
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.Color.fromHex(code: '#343c5c'),
            ),
          ),
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
            tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
            showAxisLine: true,
            renderSpec: charts.GridlineRendererSpec(
              tickLengthPx: 2,
              labelStyle: charts.TextStyleSpec(
                color: charts.Color.fromHex(code: '#848eaf'),
              ),
              lineStyle: charts.LineStyleSpec(
                color: charts.Color.fromHex(code: '#343c5c'),
              ),
            )
        ),
        defaultRenderer: charts.BarRendererConfig<DateTime>(),
      ),
    );
  }

  void update(histData, isRefresh) {
    setState(() {
      this.histData = histData;
      this.isRefresh = isRefresh;
    });
  }

  static List<charts.Series<LinearTime, DateTime>> _createHistVolumeData(List<HistogramDataModel> histData)  {

    final data = histData.map((d) => LinearTime(d.close, d.time, d.high, 0, d.volumeTo)).toList();

    return [
      charts.Series<LinearTime, DateTime>(
        id: 'TimeSeriesOfVolume',
        colorFn: (_, __) => charts.Color.fromHex(code: '#b15ace'),
        fillColorFn: (_, __) => charts.Color.fromHex(code: '#b15ace'),
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