import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:crypto_coin_market/reducers/reducers.dart';
import 'package:crypto_coin_market/model/model.dart';

import 'package:crypto_coin_market/widgets/coin_list_tile.widget.dart';
import 'package:crypto_coin_market/widgets/loading.widget.dart';

import './page_model.dart';

class MarketsPage extends StatelessWidget {
  final Store<AppState> store;

  MarketsPage({this.store}) {
    final model = PageModel.create(this.store);
    model.onRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Markets'),
          actions: <Widget>[],
        ),
        body: _VolumeListWidget(),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _VolumePageDropDownWidget(),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
              _CurrencyDropDownWidget(),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
            ],
          ),
        ));
  }
}

class _VolumeListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PageModel>(
      converter: (Store<AppState> store) => PageModel.create(store),
      builder: (BuildContext context, PageModel model) {
        return model.markets.volume.length == 0
            ? Loading()
            : ListView.builder(
          itemCount: model.markets.volume.length,
          itemBuilder: (context, i) {
            final item = model.markets.volumeItem(i);
            return CoinListTile(
                imageUrl: item.imageUrl,
                name: item.name,
                fullName: item.fullName,
                formattedPrice: item.price,
                formattedPriceChange: item.priceChangeDisplay,
                priceChange: item.priceChange,
                onSelect: (SelectedCoinTile data) {
                  model.onNavigateToDetails(DetailsViewModel(
                    currency: model.activeCurrency,
                    coinInformation: DetailsCoinInformation(
                      priceChange: data.priceChange,
                      fullName: data.fullName,
                      imageUrl: data.imageUrl,
                      name: data.name,
                      formattedPriceChange: data.formattedPriceChange,
                      formattedPrice: data.formattedPrice,
                    ),
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
              model.onChangeCurrency(currency);
            },
          );
        });
  }
}

class _VolumePageDropDownWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PageModel>(
      converter: (Store<AppState> store) => PageModel.create(store),
      builder: (BuildContext context, PageModel model) {
        return DropdownButton(
          value: model.activePage + 1,
          items: List.generate(26, (i) => i + 1).map((int value) {
            return new DropdownMenuItem<num>(
              value: value,
              child: new Text(value.toString()),
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

