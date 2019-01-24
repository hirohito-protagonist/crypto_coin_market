import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:crypto_coin_market/core/core.dart';
import 'package:crypto_coin_market/services/services.dart';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_coin_market/widgets/price_change.widget.dart';
import 'package:crypto_coin_market/widgets/coin_cost.widget.dart';
import 'package:crypto_coin_market/widgets/coin_volume.widget.dart';
import 'package:crypto_coin_market/widgets/loading.widget.dart';

import './page_model.dart';

class DetailsPage extends StatelessWidget {
  final Store<AppState> store;

  DetailsPage({this.store}) {
    final model = PageModel.create(this.store);
    model.onRequestHistogramData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StoreConnector<AppState, PageModel>(
            converter: (Store<AppState> store) => PageModel.create(store),
            builder: (BuildContext context, PageModel model) =>
                Text(model.details.coinInformation.fullName)),
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
              child: _CoinInformationWidget(),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: _HistogramCostWidget(),
                  ),
                ],
              ),
            ),
            _HistogramVolumeWidget(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _HistogramTimeRangDropDownWidget(),
            Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
            _CurrencyDropDownWidget(),
            Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
          ],
        ),
      ),
    );
  }
}

class _HistogramCostWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PageModel>(
      converter: (Store<AppState> store) => PageModel.create(store),
      builder: (BuildContext context, PageModel model) {
        return model.histogramData.length > 0
            ? CoinCostWidget(
          histData: model.histogramData,
        )
            : Loading();
      },
    );
  }
}

class _HistogramVolumeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PageModel>(
      converter: (Store<AppState> store) => PageModel.create(store),
      builder: (BuildContext context, PageModel model) {
        return model.histogramData.length > 0
            ? CoinVolumeWidget(
          histData: model.histogramData,
        )
            : Loading();
      },
    );
  }
}

class _HistogramTimeRangDropDownWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PageModel>(
        converter: (Store<AppState> store) => PageModel.create(store),
        builder: (BuildContext context, PageModel model) {
          return DropdownButton(
            value: model.activeHistogramRange,
            items: model.histogramTimeRange.map((TimeRange value) {
              return DropdownMenuItem<TimeRange>(
                value: value,
                child: Text(model.timeRangeTranslation[value]),
              );
            }).toList(),
            onChanged: (TimeRange value) {
              model.onHistogramTimeRangeChange(value);
              model.onRequestHistogramData();
            },
          );
        });
  }
}

class _CurrencyDropDownWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PageModel>(
        converter: (Store<AppState> store) => PageModel.create(store),
        builder: (BuildContext context, PageModel model) {
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
        });
  }
}

class _CoinInformationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PageModel>(
      converter: (Store<AppState> store) => PageModel.create(store),
      builder: (BuildContext context, PageModel model) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                CachedNetworkImage(
                  placeholder: CircularProgressIndicator(),
                  imageUrl: model.details.coinInformation.imageUrl,
                  height: 30.0,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${model.details.coinInformation.formattedPrice}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
                PriceChange(
                  change: model.details.coinInformation.priceChange,
                  price: model.details.coinInformation.formattedPriceChange,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
