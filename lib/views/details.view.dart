import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_coin_market/model/currency.model.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';
import 'package:crypto_coin_market/model/histogram_data.model.dart';
import 'package:crypto_coin_market/model/multiple_sybmols.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_coin_market/widgets/price_change.widget.dart';
import 'package:crypto_coin_market/services/histogram.service.dart';
import 'package:crypto_coin_market/services/price.service.dart';
import 'package:crypto_coin_market/views/histogram.view.dart';


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
  final GlobalKey<HistogramViewState> _histogramViewStateKey = GlobalKey<HistogramViewState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<_CoinInformationState> _coinInformationStateKey = GlobalKey<_CoinInformationState>();
  List<HistogramDataModel> histData = [];
  TimeRange activeHistogramRange = TimeRange.OneDay;
  bool isRefresh = true;

  Future<Null> updateData() async {
    final currency = widget.data.coinInformation.name;
    final prices = await PriceService(client: http.Client())
        .multipleSymbolsFullData([currency], Currency.fromCurrencyCode(activeCurrency));
    _histogramViewStateKey.currentState.update(activeHistogramRange, activeCurrency, currency);

    setState(() {
      widget.data = viewModel(prices, currency);
      isRefresh = false;
      _coinInformationStateKey.currentState.update(widget.data.coinInformation);
    });
    return null;
  }

  DetailsViewModel viewModel(MultipleSymbols prices, String currency) {

    final displayPriceNode = prices.display.containsKey(currency) ? prices.display[currency] : null;
    final rawPriceNode = prices.raw.containsKey(currency) ? prices.raw[currency] : null;
    final coinModel = DetailsCoinInformation(
        formattedPriceChange: displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : '',
        priceChange: rawPriceNode != null ? Map.of(rawPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : 0,
        formattedPrice: displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['PRICE'] : '',
        name: widget.data.coinInformation.name,
        imageUrl: widget.data.coinInformation.imageUrl,
        fullName: widget.data.coinInformation.fullName
    );

    return DetailsViewModel(
      coinInformation: coinModel,
      currency: activeCurrency,
    );
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
                child: _CoinInformation(
                  key: _coinInformationStateKey,
                  information: data,
                ),
              ),
              Expanded(
                child: HistogramView(
                  key: _histogramViewStateKey,
                ),
              ),
            ],
          ),
        ),
        onRefresh: () async {
          setState(() {
            isRefresh = true;
          });
          await updateData();
        },
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


class _CoinInformation extends StatefulWidget {

  final DetailsCoinInformation information;

  _CoinInformation({Key key, this.information}):super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CoinInformationState(information: information);
  }

}

class _CoinInformationState extends State<_CoinInformation> {

  DetailsCoinInformation information;

  _CoinInformationState({this.information});

  update(DetailsCoinInformation information) {
    setState(() {
      this.information = information;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
              placeholder: CircularProgressIndicator(),
              imageUrl: information.imageUrl,
              height: 30.0,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${information.formattedPrice}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            PriceChange(
              change: information.priceChange,
              price: information.formattedPriceChange,
            ),
          ],
        ),
      ),
    );
  }
}
