

class MultipleSymbols {

  final Map<dynamic, dynamic> raw;
  final Map<dynamic, dynamic> display;

  MultipleSymbols({ this.raw, this.display });

  factory MultipleSymbols.fromJson(dynamic json) {

    final raw = Map.of(json['RAW']);
    final display = Map.of(json['DISPLAY']);

    return MultipleSymbols(
      display: display,
      raw: raw,
    );
  }
}