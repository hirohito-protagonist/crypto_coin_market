import 'coin_info.model.dart';

class TotalVolume {
  final CoinInfo coinInfo;

  TotalVolume({ this.coinInfo });

  factory TotalVolume.fromJson(dynamic json) {
    return TotalVolume(
      coinInfo: CoinInfo(
        name: json['CoinInfo']['Name']
      ),
    );
  }
}