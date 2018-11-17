import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_coin_market/model/currency.model.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';
import 'package:crypto_coin_market/model/histogram_data.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_coin_market/widgets/price_change.widget.dart';
import 'package:crypto_coin_market/widgets/coin_cost.widget.dart';
import 'package:crypto_coin_market/widgets/coin_volume.widget.dart';
import 'package:crypto_coin_market/services/histogram.service.dart';
import 'package:crypto_coin_market/services/price.service.dart';


class DetailsView extends StatefulWidget {
  final String title;
  DetailsViewModel data;

  DetailsView({Key key, @required this.title, @required this.data})
      : super(key: key);

  @override
  _DetailsView createState() => _DetailsView();
}

class _DetailsView extends State<DetailsView> {

  static final Map<TimeRange, String> timeRangeTranslation = {
    TimeRange.OneHour: '1H',
    TimeRange.SixHour: '6H',
    TimeRange.TwelveHour: '12H',
    TimeRange.OneDay: '1D',
    TimeRange.OneWeek: '1W',
    TimeRange.OneMonth: '1M',
    TimeRange.ThreeMonth: '3M',
    TimeRange.SixMonth: '6M',
    TimeRange.OneYear: '1Y'
  };
  static final List<TimeRange> histogramTimeRange = timeRangeTranslation.keys.toList();
  static final List<String> availableCurrencyCodes = Currency.availableCurrencies();

  String activeCurrency = Currency.defaultSymbol;
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<CoinCostState> _coinCostStateKey = GlobalKey<CoinCostState>();
  final GlobalKey<CoinVolumeState> _coinVolumeStateKey = GlobalKey<CoinVolumeState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<HistogramDataModel> histData = [];
  TimeRange activeHistogramRange = TimeRange.OneDay;
  bool isRefresh = true;

  Future<Null> updateData() async {
    final currency = widget.data.coinInformation.name;
    final prices = await PriceService(client: http.Client())
        .multipleSymbolsFullData([currency], Currency.fromCurrencyCode(activeCurrency));
    final histOHLCV = await HistogramService.OHLCV(activeHistogramRange, activeCurrency, currency);

    setState(() {
      histData = histOHLCV;
      final displayPriceNode = prices.display.containsKey(currency) ? prices.display[currency] : null;
      final rawPriceNode = prices.raw.containsKey(currency) ? prices.raw[currency] : null;
      final coinModel = new DetailsCoinInformation(
        formattedPriceChange: displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : '',
        priceChange: rawPriceNode != null ? Map.of(rawPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : 0,
        formattedPrice: displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['PRICE'] : '',
        name: widget.data.coinInformation.name,
        imageUrl: widget.data.coinInformation.imageUrl,
        fullName: widget.data.coinInformation.fullName
      );
      widget.data = new DetailsViewModel(
        coinInformation: coinModel,
        currency: activeCurrency,
      );
      isRefresh = false;
      _coinCostStateKey.currentState.update(histData, isRefresh);
      _coinVolumeStateKey.currentState.update(histData, isRefresh);
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    activeCurrency = widget.data.currency;
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data.coinInformation;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(data.fullName),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              _refreshKey.currentState.show();
              ;
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        child: Container(
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
                child: _buildCoinInformation()
              ),
              Expanded(
                child: Column(
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
                ),
              ),
            ],
          ),
        ),
        onRefresh: () async {
          setState(() {
            isRefresh = true;
            _coinCostStateKey.currentState.update(histData, isRefresh);
            _coinVolumeStateKey.currentState.update(histData, isRefresh);
          });
          await updateData();
        },
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }


  Widget _buildCoinInformation() {
    final data = widget.data.coinInformation;
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
              placeholder: CircularProgressIndicator(),
              imageUrl: data.imageUrl,
              height: 30.0,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '1 ${data.name} = ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                  Text(
                    '${data.formattedPrice}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                ],
              ),
            ),
            PriceChange(
              change: data.priceChange,
              price: data.formattedPriceChange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          DropdownButton(
            value: activeHistogramRange,
            items: histogramTimeRange.map((TimeRange value) {
              return DropdownMenuItem<TimeRange>(
                value: value,
                child: Text(timeRangeTranslation[value]),
              );
            }).toList(),
            onChanged: (TimeRange value) {
              activeHistogramRange = value;
              setState(() {
                _refreshKey.currentState.show();
              });
            },
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
          DropdownButton(
            value: activeCurrency,
            items: availableCurrencyCodes.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
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




