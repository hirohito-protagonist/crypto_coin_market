
class Currency {

  static List<String> _codes = [
    'USD', 'USDT', 'EUR', 'GBP', 'CNY'
  ];

  static List<String> availableCurrencies() {
    return List.from(Currency._codes);
  }

  String _currencyCode;

  Currency(String currencyCode) {
    this._currencyCode = currencyCode.toUpperCase();
  }

  String currencyCode() {
    return _currencyCode;
  }

  factory Currency.fromCurrencyCode(String currencyCode) {

    return Currency._codes.contains(currencyCode.toUpperCase()) ?
    Currency(currencyCode) : Currency('USD');
  }
}