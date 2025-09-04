import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cocoa_app/model/Product.dart';
import 'package:cocoa_app/pages_cocoa/shop/item_card.dart';
import 'package:cocoa_app/pages_cocoa/shop/categorries.dart';
import 'package:cocoa_app/pages_cocoa/shop/details_screen.dart';

class ScreenCocoaShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "STORE",
          textAlign: TextAlign.center,
          style: GoogleFonts.leagueGothic(
            fontSize: 35,
            color: Colors.white,
            letterSpacing: .8,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_shopping_cart_outlined),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(156, 31, 29, 29),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          //Categories(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) => ItemCard(
                        product: products[index],
                        press: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                product: products[index],
                              ),
                            )),
                      )),
            ),
          ),
        ],
      ),
    );
  }
}
