import 'package:crypto_coin_market/model/histogram_data.model.dart';

class DetailsRequestHistogramDataAction {}

class DetailsResponseHistogramDataAction {
  List<HistogramDataModel> data;

  DetailsResponseHistogramDataAction({this.data});
}

class DetailsChangeCurrencyAction {
  final String currency;
  DetailsChangeCurrencyAction({this.currency});
}