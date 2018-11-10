import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_coin_market/model/total_volume.model.dart';
import 'package:crypto_coin_market/model/markets_view.model.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';
import 'package:crypto_coin_market/model/multiple_sybmols.model.dart';
import 'package:crypto_coin_market/model/currency.model.dart';
import 'package:crypto_coin_market/widgets/coin_list_tile.widget.dart';
import 'package:crypto_coin_market/services/toplists.service.dart';
import 'package:crypto_coin_market/services/price.service.dart';

Future<MarketsViewModel> marketData(Currency currency, num page) async {

  final volume =  await TopListsService(client: http.Client()).totalVolume(currency, page: page);
  final coins = volume.map((TotalVolume tv) => tv.coinInfo.name).toList();
  final prices = await PriceService(client: http.Client()).multipleSymbolsFullData(coins, currency);

  return MarketsViewModel(
    prices: prices,
    volume: volume,
  );
}

class MarketsView extends StatefulWidget {
  MarketsView({Key key, this.title, this.onSelect}) : super(key: key);

  final String title;
  final dynamic onSelect;

  @override
  _MarketsViewState createState() => new _MarketsViewState(
    onSelect: this.onSelect
  );
}

typedef void SelectedCoin(dynamic context, DetailsViewModel detailsModel);

class _MarketsViewState extends State<MarketsView> {

  String activeCurrency = Currency.defaultSymbol;
  List<String> availableCurrencyCodes = Currency.availableCurrencies();
  num activePage = 1;

  MarketsViewModel data = new MarketsViewModel(
    volume: [],
    prices: new MultipleSymbols(raw: {}, display: {}),
  );
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final SelectedCoin onSelect;

  _MarketsViewState({this.onSelect}): super();

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  Future<Null> refreshList() async {
    MarketsViewModel market = await marketData(Currency.fromCurrencyCode(activeCurrency), activePage - 1);
    _scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: const Text('Refresh complete'),
      action: SnackBarAction(
        label: 'RETRY',
        onPressed: () {
          _refreshKey.currentState.show();
        },
      ),
    ));
    setState(() {
      data = market;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              _refreshKey.currentState.show();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        child: ListView.builder(
          itemCount: data.volume.length,
          itemBuilder: (context, i) {

            final currency = data.volume[i]?.coinInfo?.name;
            final displayPriceNode = data.prices.display.containsKey(currency) ? data.prices.display[currency] : null;
            final rawPriceNode = data.prices.raw.containsKey(currency) ? data.prices.raw[currency] : null;
            final price = displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['PRICE'] : '';
            final priceChangeDisplay = displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : '';
            final priceChange = rawPriceNode != null ? Map.of(rawPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : 0;

            return new CoinListTile(
              key: Key("coin-list-tile-${i}"),
              imageUrl: data.volume[i]?.coinInfo?.imageUrl,
              name: currency,
              fullName: data.volume[i]?.coinInfo?.fullName,
              formattedPrice: price,
              formattedPriceChange: priceChangeDisplay,
              priceChange: priceChange,
              onSelect: (SelectedCoinTile data) {

                this.onSelect(context, new DetailsViewModel(
                  currency: activeCurrency,
                  coinInformation: new DetailsCoinInformation(
                    fullName: data.fullName,
                    imageUrl: data.imageUrl,
                    name: data.name,
                    formattedPrice: data.formattedPrice,
                    priceChange: data.priceChange,
                    formattedPriceChange: data.formattedPriceChange,
                  ),
                ));
              }

            );
          },
        ),
        onRefresh: refreshList,
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildNavigationBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          DropdownButton(
            value: activePage,
            items: List.generate(26, (i) => i + 1).map((num value) {
              return new DropdownMenuItem<num>(
                value: value,
                child: new Text(value.toString()),
              );
            }).toList(),
            onChanged: (page) {
              activePage = page;
              setState(()  {
                _refreshKey.currentState.show();
              });
            },
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
          DropdownButton(
            value: activeCurrency,
            items: availableCurrencyCodes.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (String currency) {
              activeCurrency = currency;
              setState(()  {
                _refreshKey.currentState.show();
              });
            },
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
        ],
      ),
    );
  }
}