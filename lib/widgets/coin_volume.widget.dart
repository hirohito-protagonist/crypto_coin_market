import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:crypto_coin_market/data_source/data_source.dart';
import 'package:intl/intl.dart';

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
  _SelectionChartSliderValue _selectionChartSliderValue = _SelectionChartSliderValue(
    price: -1,
    date: null,
  );

  CoinVolumeState({this.histData});

  @override
  void initState() {
    super.initState();
    if (histData.length > 0) {
      final index = (histData.length / 2).floor();
      _selectionChartSliderValue = _SelectionChartSliderValue(
        price: histData[index].volumeTo,
        date: histData[index].time,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
          child: Column(
            children: <Widget>[
              _buildCoinVolumeChart(),
            ],
          ),
        ),
        Positioned(
          child:  _buildSliderInformation(
            children: <Widget>[
              Text(
                _selectionChartSliderValue.date == null ? '' :
                '${DateFormat('yyyy.MM.dd').format(_selectionChartSliderValue.date)}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0
                ),
              ),
              Text(
                _selectionChartSliderValue.date == null ? '' :
                '  ${DateFormat('HH:mm:ss').format(_selectionChartSliderValue.date)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          right: 10.0,
          top: 10.0,
        ),
        Positioned(
          child:  _buildSliderInformation(
            children: <Widget>[
              Text(
                _selectionChartSliderValue.price == -1 ?  '' : '${_selectionChartSliderValue.price}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          right: 10.0,
          top: 50.0,
        ),
      ],
    );
  }

  Widget _buildSliderInformation({List<Widget> children}) {
    return Container(
      child: Row(
        children: children,
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(70, 82, 130, 0.8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(10.0),
    );
  }

  Widget _buildCoinVolumeChart() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
        child: Container(
          padding: const EdgeInsets.all(0.0),
          alignment: Alignment.center,
          child: histData.length == 0 ? Icon(Icons.error) :
          charts.TimeSeriesChart(
            _createHistVolumeData(histData),
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
                initialDomainValue: _selectionChartSliderValue.date,
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

  _onSliderChange(point, dynamic domain, charts.SliderListenerDragState dragState) {

    void rebuild(_) {
      if (dragState == charts.SliderListenerDragState.end) {
        final histogramModel = histData.where((d) => d.time.isAtSameMomentAs(domain)).single;
        if (histogramModel != null) {
          setState(() {
            _selectionChartSliderValue = _SelectionChartSliderValue(
              date: domain,
              price: histogramModel.volumeTo,
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
  final DateTime date;
  final num price;

  _SelectionChartSliderValue({this.date, this.price});
}