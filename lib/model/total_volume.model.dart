import 'coin_info.model.dart';

class TotalVolume {
  final CoinInfo coinInfo;

  TotalVolume({ this.coinInfo });

  factory TotalVolume.fromJson(dynamic json) {

    final coinInfo = json['CoinInfo'];

    return TotalVolume(
      coinInfo: CoinInfo(
        name: coinInfo['Name'],
        imageUrl: 'https://www.cryptocompare.com${coinInfo['ImageUrl']}',
      ),
    );
  }
}