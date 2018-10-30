import 'package:flutter/scheduler.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_coin_market/model/histogram_data.model.dart';

class CoinCostWidget extends StatefulWidget {

  List<HistogramDataModel> histData = [];
  bool isRefresh = false;

  CoinCostWidget({Key key, this.histData, this.isRefresh}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CoinCostState(
      isRefresh: isRefresh,
      histData: histData,
    );
  }

}

class CoinCostState extends State<CoinCostWidget> {

  List<HistogramDataModel> histData = [];
  _SelectionChartSliderValue _selectionChartSliderValue = _SelectionChartSliderValue(
      close: '',
      date: '',
      low: '',
      high: ''
  );
  bool isRefresh;

  CoinCostState({this.histData, this.isRefresh});

  @override
  void initState() {
    super.initState();
    if (histData.length > 0) {
      _selectionChartSliderValue = _SelectionChartSliderValue(
        close: histData[0].close.toString(),
        date: histData[0].time.toString(),
        high: histData[0].high.toString(),
        low: histData[0].low.toString(),
      );
    }
  }

  void update(histData, isRefresh) {
    setState(() {
      this.histData = histData;
      this.isRefresh = isRefresh;
      _selectionChartSliderValue = _SelectionChartSliderValue(
        close: histData[0].close.toString(),
        date: histData[0].time.toString(),
        high: histData[0].high.toString(),
        low: histData[0].low.toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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