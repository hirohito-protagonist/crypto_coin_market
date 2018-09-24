
class Currency {

  static List<String> _codes = [
    'USD', 'USDT', 'EUR', 'GBP', 'CNY', 'JPY', 'RUB', 'AUD', 'CAD', 'PLN',
    'SGD', 'CHF', 'HKD', 'INR', 'ZAR', 'LTC', 'KRW', 'NZD', 'BRL', 'SEK',
    'BITUSD', 'UAH', 'ILS', 'THB', 'VND', 'ETH', 'BITCNY', 'RUR', 'DKK', 'MXN',
    'CZK', 'CLP', 'TRY', 'NGN', 'IDR', 'MYR', 'PHP', 'ARS', 'IRR', 'MUR', 'DASH',
    'UGX', 'BHD', 'XRP', 'COP', 'HRK', 'TZS', 'RON', 'CNH', 'PEN', 'BGN', 'PKR',
    'NOK', 'HUF', 'GHS', 'DOGE', 'TUSD', 'DAI', 'QC', 'VEF', 'KHR', 'AED', 'CRC',
    'KES', 'UZS', 'JOD', 'LKR', 'VES', 'BWP', 'ISK', 'LSL', 'GOLD', 'MMK', 'SAR',
    'LKK', 'BITGOLD', 'GEL', 'XAF', 'ZMW', 'CNET', 'ALL', 'VUV', 'AGRS', 'RSD',
    'BITEUR', 'GTQ', 'ETB', 'NZDT', 'TWD', 'BCH', 'B2X', 'BDT', 'BYN', 'NPR', 'NAD',
    'BNB', 'QAR', 'MZN', 'JMD', 'PAI*', 'BYR', 'CDF', 'EURS', 'MAD', 'RWF',
    'XOF', 'SZL', 'AMP', 'CUC', 'BOB', 'PAB', 'KCS', 'WTRY', 'LKK1Y', 'XAG',
    'DZD', 'WAVES', 'BND', 'DKKT', 'AIC*', 'KZT', 'GGP', 'AMD', 'WEUR', 'BAM',
    'OMR', 'KGS', 'EOS', 'BTS', 'BIF', 'PYG', 'MDL', 'AOA', 'CKUSD', 'AZN', 'LBP',
    'PGK', 'TTD', 'MWK', 'BLOCKPAY', 'XJP', 'HIKEN', 'TND', 'UYU', 'KWD', 'EGP',
    'IQD', 'BCY', 'XMR', 'AFN', 'ARDR', 'XAR', 'KNC', 'XAU', 'GIP', 'ATB', 'HNL',
    'MOP', 'WUSD', 'ZEC', 'DOP', 'MGA'
  ];

  static List<String> availableCurrencies() {
    final symbols = List.from<String>(Currency._codes);
    symbols.sort((a, b) => a.compareTo(b));
    return symbols;
  }

  static String defaultSymbol = 'USD';

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