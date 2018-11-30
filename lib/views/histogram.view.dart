import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_coin_market/services/histogram.service.dart';
import 'package:crypto_coin_market/model/histogram_data.model.dart';
import 'package:crypto_coin_market/widgets/coin_cost.widget.dart';
import 'package:crypto_coin_market/widgets/coin_volume.widget.dart';

class HistogramView extends StatefulWidget {

  HistogramView({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HistogramViewState();
  }

}

class HistogramViewState extends State<HistogramView> {

  final GlobalKey<CoinCostState> _coinCostStateKey = GlobalKey<CoinCostState>();
  final GlobalKey<CoinVolumeState> _coinVolumeStateKey = GlobalKey<CoinVolumeState>();
  List<HistogramDataModel> histData = [];
  bool isRefresh = true;


  update(TimeRange range, String currency, String cryptoCoin) async {

    final histOHLCV = await HistogramService.OHLCV(range, currency, cryptoCoin);
    setState(() {
      histData = histOHLCV;
      isRefresh = false;
      _coinCostStateKey.currentState.update(histData, isRefresh);
      _coinVolumeStateKey.currentState.update(histData, isRefresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: CoinCostWidget(
            key: _coinCostStateKey,
            histData: histData,
            isRefresh: isRefresh,
          ),
        ),
        CoinVolumeWidget(
          key: _coinVolumeStateKey,
          histData: histData,
          isRefresh: isRefresh,
        ),
      ],
    );
  }

}