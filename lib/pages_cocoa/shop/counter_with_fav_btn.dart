import 'package:flutter/material.dart';
import 'package:cocoa_app/pages_cocoa/shop/cart_counter.dart';

class CounterWithFavBtn extends StatelessWidget {
  const CounterWithFavBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CartCounter(),
        /*Container(
            padding: EdgeInsets.all(8),
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: Color(0xFFFF6464),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.heart_broken,
              ),
            ))*/
      ],
    );
  }
}
