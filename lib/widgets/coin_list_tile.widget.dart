import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_coin_market/widgets/price_change.widget.dart';

typedef void SelectedCoinTileCallback(SelectedCoinTile selectedCoinTile);

class CoinListTile extends StatelessWidget {

  final String imageUrl;
  final String name;
  final String fullName;
  final String formattedPrice;
  final num priceChange;
  final String formattedPriceChange;
  final SelectedCoinTileCallback onSelect;

  const CoinListTile({
    Key key,
    this.imageUrl = '',
    this.name = '',
    this.fullName = '',
    this.formattedPrice = '',
    this.priceChange = 0,
    this.formattedPriceChange = '',
    this.onSelect
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromRGBO(62, 71, 115, 1),
            const Color.fromRGBO(54, 62, 100, 1),
          ],
        ),
      ),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: 30.0,
            ),
            onTap: () {
              this.onSelect(new SelectedCoinTile(
                fullName: fullName,
                imageUrl: imageUrl,
                name: name,
                formattedPrice: formattedPrice,
                priceChange: priceChange,
                formattedPriceChange: formattedPriceChange,
              ));
            },
            title: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${fullName}',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                        Text(
                          '${name}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      PriceChange(
                        change: priceChange,
                        price: formattedPriceChange,
                      ),
                      Text('${formattedPrice}'),
                    ],
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }

}


class SelectedCoinTile {
  final String imageUrl;
  final String name;
  final String fullName;
  final String formattedPrice;
  final num priceChange;
  final String formattedPriceChange;

  SelectedCoinTile({this.imageUrl, this.name, this.fullName, this.formattedPrice,
      this.priceChange, this.formattedPriceChange});

}