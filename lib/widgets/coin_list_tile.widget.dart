import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CoinListTile extends StatelessWidget {

  final String imageUrl;
  final String name;
  final String fullName;
  final String formattedPrice;
  final num priceChange;
  final String formattedPriceChange;

  const CoinListTile({
    Key key,
    this.imageUrl,
    this.name,
    this.fullName,
    this.formattedPrice,
    this.priceChange,
    this.formattedPriceChange
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: CachedNetworkImage(
              placeholder: CircularProgressIndicator(),
              imageUrl: imageUrl,
              height: 30.0,
            ),
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
                      Text(
                        '${formattedPriceChange}%',
                        style: TextStyle(
                          color: priceChange == 0 ? Colors.black : priceChange > 0 ? Colors.green : Colors.red,
                        ),
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