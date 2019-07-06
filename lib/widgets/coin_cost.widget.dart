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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(67, 78, 122, 1),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color.fromRGBO(67, 76, 112, 1),
          width: 2.0,
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 35.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_selectionChartSliderValue.close == '' ?  '' : 'Close: '),
                    Text(
                      _selectionChartSliderValue.close == '' ?  '' : '${_selectionChartSliderValue.close}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _selectionChartSliderValue.low == '' ?  '' : ' Low: ',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      _selectionChartSliderValue.low == '' ?  '' : '${_selectionChartSliderValue.low}',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      _selectionChartSliderValue.high == '' ?  '' : ' High: ',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      _selectionChartSliderValue.high == '' ?  '' : ' ${_selectionChartSliderValue.high}',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildCoinCostChart(),
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
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
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
        child: Container(
          padding: const EdgeInsets.all(0.0),
          alignment: Alignment.center,
          child:
          charts.TimeSeriesChart(
            _createHistCostData(histData),
            animate: true,
            domainAxis: charts.DateTimeAxisSpec(
              showAxisLine: true,
              renderSpec: charts.SmallTickRendererSpec(
                minimumPaddingBetweenLabelsPx: 0,
                labelStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.white,
                ),
                lineStyle: charts.LineStyleSpec(
                  color: charts.MaterialPalette.white,
                ),
              ),
            ),
            primaryMeasureAxis: charts.NumericAxisSpec(
              tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
              showAxisLine: true,
              renderSpec: charts.GridlineRendererSpec(
                tickLengthPx: 2,
                labelStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.white,
                ),
                lineStyle: charts.LineStyleSpec(
                  color: charts.MaterialPalette.white,
                ),
              )
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
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        strokeWidthPxFn: (_, __) => 3,
        domainFn: (LinearTime f, _) => f.time,
        measureFn: (LinearTime f, _) => f.close,
        data: data,
      )
    ];
  }

  _onSliderChange(point, dynamic domain, charts.SliderListenerDragState dragState) {

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