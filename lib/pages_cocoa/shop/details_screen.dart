import 'package:flutter/material.dart';
import 'package:cocoa_app/model/Product.dart';
import 'package:cocoa_app/pages_cocoa/shop/constants.dart';
import 'package:cocoa_app/pages_cocoa/shop/body.dart';

class DetailsScreen extends StatelessWidget {
  final Product product;

  const DetailsScreen({required this.product});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // each product have a color
      backgroundColor: product.color,
      appBar: buildAppBar(context),
      body: Body(product: product),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: product.color,
      elevation: 0,
      leading: BackButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.add_shopping_cart_outlined),
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
