import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:crypto_coin_market/redux/reducers.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';
import 'package:crypto_coin_market/model/histogram_data.model.dart';
import 'package:crypto_coin_market/actions/details.action.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_coin_market/widgets/price_change.widget.dart';
import 'package:crypto_coin_market/widgets/coin_cost.widget.dart';
import 'package:crypto_coin_market/widgets/coin_volume.widget.dart';


class DetailsPage extends StatelessWidget {

  final Store<AppState> store;

  DetailsPage({ this.store }) {
    final model = _ViewModel.create(this.store);
    model.onRequestHistogramData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StoreConnector<AppState, _ViewModel>(
            converter: (Store<AppState> store) => _ViewModel.create(store),
            builder: (BuildContext context, _ViewModel model) => Text(model.details.coinInformation.fullName)
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
              child: StoreConnector<AppState, _ViewModel>(
                converter: (Store<AppState> store) => _ViewModel.create(store),
                builder: (BuildContext context, _ViewModel model) {
                  return _CoinInformationWidget(
                    imageUrl: model.details.coinInformation.imageUrl,
                    priceChange: model.details.coinInformation.priceChange,
                    formattedPriceChange: model.details.coinInformation.formattedPriceChange,
                    formattedPrice: model.details.coinInformation.formattedPrice,
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
                    child: StoreConnector<AppState, _ViewModel>(
                      converter: (Store<AppState> store) => _ViewModel.create(store),
                      builder: (BuildContext context, _ViewModel model) {
                        return model.histogramData.length > 0 ? CoinCostWidget(
                          histData: model.histogramData,
                          isRefresh: false,
                        ) : _Loading();
                      },
                    ),
                  ),
                ],
              ),
            ),
            StoreConnector<AppState, _ViewModel>(
              converter: (Store<AppState> store) => _ViewModel.create(store),
              builder: (BuildContext context, _ViewModel model) {
                return model.histogramData.length > 0 ? CoinVolumeWidget(
                  histData: model.histogramData,
                  isRefresh: false,
                ): _Loading();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
            StoreConnector<AppState, _ViewModel>(
                converter: (Store<AppState> store) => _ViewModel.create(store),
                builder: (BuildContext context, _ViewModel model) {
                  return DropdownButton(
                    value: model.activeCurrency,
                    items: model.availableCurrencies.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (String currency) {
                      model.onRequestHistogramData();
                      model.onChangeCurrency(currency);
                    },
                  );
                }
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
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

class _Loading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

}

class _ViewModel {
  final String activeCurrency;
  final List<String> availableCurrencies;
  final DetailsViewModel details;
  final List<HistogramDataModel> histogramData;
  final Function() onRequestHistogramData;
  final Function(String) onChangeCurrency;

  _ViewModel({
    this.details,
    this.activeCurrency,
    this.availableCurrencies,
    this.histogramData,
    this.onRequestHistogramData,
    this.onChangeCurrency,
  });

  factory _ViewModel.create(Store<AppState> store) {

    return _ViewModel(
      activeCurrency: store.state.currency,
      availableCurrencies: store.state.marketsPageState.availableCurrencies,
      details: store.state.detailsPageState.details,
      histogramData: store.state.detailsPageState.histogramData,
      onRequestHistogramData: () => store.dispatch(DetailsRequestHistogramDataAction()),
      onChangeCurrency: (String currency) => store.dispatch(DetailsChangeCurrencyAction(currency: currency)),
    );
  }
}