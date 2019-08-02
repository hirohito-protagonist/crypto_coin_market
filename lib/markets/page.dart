import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:crypto_coin_market/core/core.dart';
import 'package:crypto_coin_market/data_source/data_source.dart';
import 'package:crypto_coin_market/widgets/coin_list_tile.widget.dart';
import 'package:crypto_coin_market/widgets/loading.widget.dart';
import 'package:crypto_coin_market/widgets/error.widget.dart';

import './selectors.dart';

class MarketsPage extends StatelessWidget {
  final Store<AppState> store;

  MarketsPage({this.store}) {
    final model = MarketsSelectors.create(this.store);
    model.onRequestData();
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
              'MARKETS',
              style: TextStyle(
                letterSpacing: 4.0,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            textTheme: TextTheme(
              title: Theme.of(context).textTheme.title,
            ),
            actions: <Widget>[
              StoreConnector<AppState, MarketsSelectors>(
                  converter: (Store<AppState> store) => MarketsSelectors.create(store),
                  builder: (BuildContext context, MarketsSelectors model) {
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
          body: _VolumeListWidget(),
          bottomNavigationBar: BottomAppBar(
            elevation: 0.0,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _VolumePageDropDownWidget(),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                _CurrencyDropDownWidget(),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
              ],
            ),
          )
        )
      ],
    );
  }
}

class _VolumeListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MarketsSelectors>(
      converter: (Store<AppState> store) => MarketsSelectors.create(store),
      builder: (BuildContext context, MarketsSelectors model) {
        final data = model.data();
        return model.dataState() == ServiceDataState.Loading
            ? Loading()
            : model.dataState() == ServiceDataState.Error
            ? ErrorMessageWidget(message: 'Upps we can load data')
            : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
          itemCount: data.length,
          itemBuilder: (context, i) {
            final item = data[i];
            return CoinListTile(
                imageUrl: item.imageUrl,
                name: item.name,
                fullName: item.fullName,
                formattedPrice: item.price,
                formattedPriceChange: item.priceChangeDisplay,
                priceChange: item.priceChange,
                onSelect: (SelectedCoinTile data) {
                  model.onNavigateToDetails(CoinInformation(
                    priceChange: data.priceChange,
                    fullName: data.fullName,
                    imageUrl: data.imageUrl,
                    name: data.name,
                    formattedPriceChange: data.formattedPriceChange,
                    formattedPrice: data.formattedPrice,
                  ));
                });
          },
        );
      },
    );
  }
}

class _CurrencyDropDownWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MarketsSelectors>(
        converter: (Store<AppState> store) => MarketsSelectors.create(store),
        builder: (BuildContext context, MarketsSelectors model) {
          return DropdownButton(
            value: model.activeCurrency(),
            items: model.availableCurrencies().map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String currency) {
              model.onChangeCurrency(currency);
            },
          );
        });
  }
}

class _VolumePageDropDownWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MarketsSelectors>(
      converter: (Store<AppState> store) => MarketsSelectors.create(store),
      builder: (BuildContext context, MarketsSelectors model) {
        return DropdownButton(
          value: model.activePage() + 1,
          items: List.generate(26, (i) => i + 1).map((int value) {
            return DropdownMenuItem<num>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
          onChanged: (page) {
            model.onPageChange(page - 1);
          },
        );
      },
    );
  }
}

