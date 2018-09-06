import './total_volume.model.dart';
import './multiple_sybmols.model.dart';

class MarketsViewModel {

  final List<TotalVolume> volume;
  final MultipleSymbols prices;

  MarketsViewModel({ this.volume, this.prices });
}