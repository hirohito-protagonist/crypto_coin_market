
class Currency {

  static List<String> _codes = [
    'USD', 'USDT', 'EUR', 'GBP', 'CNY', 'JPY', 'RUB', 'AUD', 'CAD', 'PLN',
    'SGD', 'CHF', 'HKD', 'INR', 'ZAR', 'LTC', 'KRW', 'NZD', 'BRL', 'SEK',
    'BITUSD', 'UAH', 'ILS', 'THB', 'VND', 'ETH', 'BITCNY', 'RUR', 'DKK', 'MXN',
    'CZK', 'CLP', 'TRY', 'NGN', 'IDR', 'MYR', 'PHP', 'ARS', 'IRR', 'MUR', 'DASH',
    'UGX', 'BHD', 'XRP', 'COP', 'HRK', 'TZS', 'RON', 'CNH', 'PEN', 'BGN', 'PKR',
    'NOK', 'HUF', 'GHS', 'DOGE', 'TUSD', 'DAI', 'QC', 'VEF', 'KHR', 'AED', 'CRC',
    'KES', 'UZS', 'JOD', 'LKR', 'VES', 'BWP', 'ISK'
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