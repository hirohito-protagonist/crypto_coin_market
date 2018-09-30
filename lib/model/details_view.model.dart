
class DetailsViewModel {
  final String currency;
  final DetailsCoinInformation coinInformation;

  DetailsViewModel({this.currency, this.coinInformation});

}

class DetailsCoinInformation {
  final String imageUrl;
  final String name;
  final String fullName;
  final String formattedPrice;
  final num priceChange;
  final String formattedPriceChange;

  DetailsCoinInformation({this.imageUrl, this.name, this.fullName, this.formattedPrice,
    this.priceChange, this.formattedPriceChange});
}