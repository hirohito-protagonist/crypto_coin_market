import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_coin_market/data_source/data_source.dart';

class CoinCostWidget extends StatefulWidget {

  List<HistogramDataModel> histData = [];

  CoinCostWidget({Key key, this.histData,}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CoinCostState(
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

  CoinCostState({this.histData,});

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
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
          child: Column(
            children: <Widget>[
              _buildCoinCostChart(),
            ],
          ),
        ),
        Positioned(
          child:  Container(
            child: Text(
              _selectionChartSliderValue.date == '' ? '' : '${_selectionChartSliderValue.date}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10.0
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(70, 82, 130, 0.8),
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.all(10.0),
          ),
          right: 10.0,
          top: 10.0,
        ),
        Positioned(
          child:  Container(
            child: Text(
              _selectionChartSliderValue.close == '' ?  '' : '${_selectionChartSliderValue.close}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(70, 82, 130, 0.8),
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.all(10.0),
          ),
          right: 10.0,
          top: 50.0,
        ),
      ],
    );
  }

  Widget _buildCoinCostChart() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
        child: Container(
          padding: const EdgeInsets.all(0.0),
          alignment: Alignment.center,
          child: histData.length == 0 ? Icon(Icons.error) :
          charts.TimeSeriesChart(
            _createHistCostData(histData),
            animate: true,
            defaultInteractions: false,
            domainAxis: charts.DateTimeAxisSpec(
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
            behaviors: [
              charts.Slider(
                initialDomainValue: histData[(histData.length / 2).floor()].time,
                onChangeCallback: _onSliderChange,
                style: charts.SliderStyle(
                  fillColor: charts.Color(a: 100, r: 122, g: 132, b: 166),
                  handleSize: Rectangle(0, 0, 40, 100),
                  strokeWidthPx: 0.0,
                ),
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
        colorFn: (_, __) => charts.Color.fromHex(code: '#b15ace'),
        fillColorFn: (_, __) => charts.Color.fromHex(code: '#b15ace'),
        strokeWidthPxFn: (_, __) => 3,
        domainFn: (LinearTime f, _) => f.time,
        measureFn: (LinearTime f, _) => f.close,
        data: data,
      )
    ];
  }

  _onSliderChange(point, dynamic domain, charts.SliderListenerDragState dragState) {

      void rebuild(_) {
        if (dragState == charts.SliderListenerDragState.end) {
          final histogramModel = histData.where((d) => d.time.isAtSameMomentAs(domain)).single;
          if (histogramModel != null) {
            setState(() {
              _selectionChartSliderValue = _SelectionChartSliderValue(
                date: domain.toString(),
                close: histogramModel.close.toString(),
                high: histogramModel.high.toString(),
                low: histogramModel.low.toString(),
              );
            });
          }
        }
      }

      SchedulerBinding.instance.addPostFrameCallback(rebuild);
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