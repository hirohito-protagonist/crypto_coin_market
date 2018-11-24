

class UriService {

  static final String authority = 'min-api.cryptocompare.com';

  Uri totalVolume(Map<String, String> queryParameters) {
    return Uri.https(authority, 'data/top/totalvol', queryParameters);
  }

  Uri priceMultiFull(Map<String, String> queryParameters) {
    return Uri.https(authority, 'data/pricemultifull', queryParameters);
  }
}