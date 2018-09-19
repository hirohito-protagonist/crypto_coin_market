import 'package:flutter/material.dart';

class PriceChange extends StatelessWidget {

  final num change;
  final String price;


  const PriceChange({ Key key, this.change, this.price }): super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Row(
        children: <Widget>[
          Text(
            price == '' ? '' : '${price}%',
            style: TextStyle(
              color: change == 0 ? Colors.black : change > 0 ? Colors.green : Colors.red,
            ),
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.arrow_drop_up,
                color: change == 0 ? Colors.black : change > 0 ? Colors.green : Colors.black,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: change == 0 ? Colors.black : change > 0 ? Colors.black : Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

}