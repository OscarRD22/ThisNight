import 'package:flutter/material.dart';
import 'package:cocoa_app/model/Product.dart';
import 'package:cocoa_app/pages_cocoa/shop/constants.dart';

class ItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback press;
  const ItemCard({
    required this.product,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kDefaultPaddin),
              
              decoration: BoxDecoration(
                color: product.color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Hero(
                tag: "${product.id}",
                child: Image.asset(product.image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              
              product.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Text(
            "${product.price}\€",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }
}
