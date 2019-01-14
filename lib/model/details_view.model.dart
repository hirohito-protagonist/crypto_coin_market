import 'package:flutter/foundation.dart';

class DetailsViewModel {
  final String currency;
  final DetailsCoinInformation coinInformation;

  DetailsViewModel({
    @required this.currency,
    @required this.coinInformation
  });

}

class DetailsCoinInformation {
  final String imageUrl;
  final String name;
  final String fullName;
  final String formattedPrice;
  final num priceChange;
  final String formattedPriceChange;

  DetailsCoinInformation({
    @required this.imageUrl,
    @required this.name,
    @required this.fullName,
    @required this.formattedPrice,
    @required this.priceChange,
    @required this.formattedPriceChange
  });
}