import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:crypto_coin_market/redux/reducers.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_coin_market/widgets/price_change.widget.dart';
import 'package:crypto_coin_market/widgets/coin_cost.widget.dart';
import 'package:crypto_coin_market/widgets/coin_volume.widget.dart';


class DetailsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StoreConnector<AppState, Store<AppState>>(
            converter: (Store<AppState> store) => store,
            builder: (BuildContext context, Store<AppState> store) => Text(store.state.details.coinInformation.fullName)
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(0.0),
              alignment: Alignment.center,
              width: 1.7976931348623157e+308,
              child: StoreConnector<AppState, Store<AppState>>(
                converter: (Store<AppState> store) => store,
                builder: (BuildContext context, Store<AppState> store) {
                  return _CoinInformationWidget(
                    imageUrl: store.state.details.coinInformation.imageUrl,
                    priceChange: store.state.details.coinInformation.priceChange,
                    formattedPriceChange: store.state.details.coinInformation.formattedPriceChange,
                    formattedPrice: store.state.details.coinInformation.formattedPrice,
                  );
                },
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: StoreConnector<AppState, Store<AppState>>(
                      converter: (Store<AppState> store) => store,
                      builder: (BuildContext context, Store<AppState> store) {
                        return store.state.histogramData.length > 0 ? CoinCostWidget(
                          histData: store.state.histogramData,
                          isRefresh: false,
                        ) : Text('Loading');
                      },
                    ),
                  ),
                ],
              ),
            ),
            StoreConnector<AppState, Store<AppState>>(
              converter: (Store<AppState> store) => store,
              builder: (BuildContext context, Store<AppState> store) {
                return store.state.histogramData.length > 0 ?             CoinVolumeWidget(
                  histData: store.state.histogramData,
                  isRefresh: false,
                ): Text('Loading');
              },
            ),
          ],
        ),
      ),
    );
  }

}

class _CoinInformationWidget extends StatelessWidget {

  final String imageUrl;
  final String formattedPrice;
  final num priceChange;
  final String formattedPriceChange;


  _CoinInformationWidget({this.imageUrl, this.formattedPrice, this.priceChange,
    this.formattedPriceChange});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
              placeholder: CircularProgressIndicator(),
              imageUrl: imageUrl,
              height: 30.0,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${formattedPrice}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            PriceChange(
              change: priceChange,
              price: formattedPriceChange,
            ),
          ],
        ),
      ),
    );
  }

}