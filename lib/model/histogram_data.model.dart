
class HistogramDataModel {

  final DateTime time;
  final num close;
  final num high;
  final num low;
  final num open;
  final num volumeFrom;
  final num volumeTo;

  HistogramDataModel({this.time, this.close, this.high, this.low, this.open,
    this.volumeFrom, this.volumeTo});


  factory HistogramDataModel.fromJson(dynamic json) {
    return HistogramDataModel(
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