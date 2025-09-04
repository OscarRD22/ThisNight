import 'package:flutter/material.dart';

class Product {
  final String image, title, description;
  final int price, size, id;
  final Color color;
  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    required this.size,
    required this.color,
  });
}

List<Product> products = [
  Product(
      id: 1,
      title: "Sudadera blanca 'COCOA MATARÒ'",
      price: 20,
      size: 12,
      description: dummyText,
      image: "assets/shop/sudadera_blanca_cocoa.png",
      color: Color.fromARGB(255, 90, 90, 90)),
  Product(
    id: 2,
    title: "Boli COCOA",
    price: 5,
    size: 12,
    description: dummyText,
    image: "assets/shop/boli_cocoa.png",
    color: Color.fromARGB(255, 90, 90, 90),
  ),
  Product(
      id: 3,
      title: "Semarreta Negra COCOA",
      price: 15,
      size: 10,
      description:
          "Semarreta unisex, elaborada amb un teixit suau de cotó, amb un coll bordat i amb el logo de cocoa estampat en la part frontal.",
      image: "assets/shop/samarreta_negre_cocoa.png",
      color: Color.fromARGB(255, 90, 90, 90)),
  Product(
      id: 4,
      title: "Semarreta Blanca COCOA",
      price: 15,
      size: 11,
      description: dummyText,
      image: "assets/shop/samarreta_blanca_cocoa.png",
      color: Color.fromARGB(255, 90, 90, 90)),
  Product(
      id: 5,
      title: "Polsera negre cocoa",
      price: 2,
      size: 10,
      description: dummyText,
      image: "assets/shop/polsera_cocoa_negre.png",
      color: Color.fromARGB(255, 90, 90, 90)),
  Product(
      id: 6,
      title: "Sudadera COCOA",
      price: 25,
      size: 8,
      description:
          "Sudadera unisex amb caputxa. Elaborada amb un teixit suau de cotó. Coll amb cordons ajusables. Amb el logo estampat de Cocoa en el frontal.",
      image: "assets/shop/sudadera_negre_cocoa.png",
      color: Color.fromARGB(255, 90, 90, 90)),
];

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
