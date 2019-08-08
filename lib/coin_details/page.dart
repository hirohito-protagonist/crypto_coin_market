import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:crypto_coin_market/core/core.dart';
import 'package:crypto_coin_market/data_source/data_source.dart';


import 'package:crypto_coin_market/widgets/coin_cost.widget.dart';
import 'package:crypto_coin_market/widgets/coin_volume.widget.dart';
import 'package:crypto_coin_market/widgets/coin_list_tile.widget.dart';
import 'package:crypto_coin_market/widgets/loading.widget.dart';
import 'package:crypto_coin_market/widgets/error.widget.dart';

import './page_model.dart';

class DetailsPage extends StatelessWidget {
  final Store<AppState> store;

  DetailsPage({this.store}) {
    final model = PageModel.create(this.store);
    model.onRequestHistogramData();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.0, -0.6),
              radius: 0.7,
              colors: [
                const Color.fromRGBO(56, 64, 104, 1),
                const Color.fromRGBO(42, 49, 81, 1),
              ],
              stops: [0.4, 1.0],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'DETAILS',
              style: TextStyle(
                letterSpacing: 4.0,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              )
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            textTheme: TextTheme(
                title: Theme.of(context).textTheme.title
            ),
            actions: <Widget>[
              StoreConnector<AppState, PageModel>(
                  converter: (Store<AppState> store) => PageModel.create(store),
                  builder: (BuildContext context, PageModel model) {
                    return IconButton(
                      icon: Icon(
                        Icons.refresh,
                      ),
                      onPressed: () => model.onRefresh(),
                    );
                  }
              ),
            ],
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: _CoinInformationWidget(),
                ),
                Expanded(
                  child: Container(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(67, 78, 122, 1),
                              border: Border.all(
                                color: const Color.fromRGBO(67, 76, 112, 1),
                                width: 2.0,
                              ),
                            ),
                            child: TabBar(
                              indicatorColor: const Color.fromRGBO(114, 157, 242, 1),
                              labelStyle: TextStyle(
                                letterSpacing: 4.0,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                              tabs: [
                                Tab(text: 'Price',),
                                Tab(text: 'Volume',),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                _HistogramCostWidget(),
                                _HistogramVolumeWidget(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
        ),
      ],
    );
  }
}

class _HistogramCostWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PageModel>(
      converter: (Store<AppState> store) => PageModel.create(store),
      builder: (BuildContext context, PageModel model) {
        return model.histogramDataState == ServiceDataState.Success
            ? CoinCostWidget(
          histData: model.histogramData,
        ) : model.histogramDataState == ServiceDataState.Error ?
        ErrorMessageWidget(message: 'Upps we can not load data') :
        Loading();
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
        return model.histogramDataState == ServiceDataState.Success
            ? CoinVolumeWidget(
          histData: model.histogramData,
        ) : model.histogramDataState == ServiceDataState.Error ?
        ErrorMessageWidget(message: 'Upps we can not load data') :
        Loading();
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
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String currency) {
              model.onChangeCurrency(currency);
              model.onRequestHistogramData();
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

        return CoinListTile(
          imageUrl: model.details.coinInformation.imageUrl,
          name: model.details.coinInformation.name,
          fullName: model.details.coinInformation.fullName,
          formattedPrice: model.details.coinInformation.formattedPrice,
          formattedPriceChange: model.details.coinInformation.formattedPriceChange,
          priceChange: model.details.coinInformation.priceChange,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        );
      },
    );
  }
}
