import './total_volume.model.dart';
import './multiple_sybmols.model.dart';

class MarketsViewModel {

  final List<TotalVolume> volume;
  final MultipleSymbols prices;

  MarketsViewModel({ this.volume, this.prices });

  _VolumeItemModel volumeItem(int index) {

    final currency = volume[index]?.coinInfo?.name;
    final displayPriceNode = prices.display.containsKey(currency) ? prices.display[currency] : null;
    final rawPriceNode = prices.raw.containsKey(currency) ? prices.raw[currency] : null;
    final price = displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['PRICE'] : '';
    final priceChangeDisplay = displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : '';
    final priceChange = rawPriceNode != null ? Map.of(rawPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : 0;

    return _VolumeItemModel(
      name: currency,
      imageUrl: volume[index]?.coinInfo?.imageUrl,
      fullName: volume[index]?.coinInfo?.fullName,
      price: price,
      priceChange: priceChange,
      priceChangeDisplay: priceChangeDisplay,
    );
  }
}

class _VolumeItemModel {

  final String name;
  final String imageUrl;
  final String fullName;
  final String price;
  final String priceChangeDisplay;
  final num priceChange;

  _VolumeItemModel({ this.name, this.imageUrl, this.fullName, this.price,
      this.priceChangeDisplay, this.priceChange });
}