import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:crypto_coin_market/model/histogram_data.model.dart';

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
    return Card(
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