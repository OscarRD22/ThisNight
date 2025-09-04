// ignore_for_file: dead_code

import 'package:cocoa_app/Screens/screens.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:cocoa_app/pages_classic/ScreenClassicImage.dart';

class HomeScreenClassic extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<HomeScreenClassic> {
  int pageIndex = 2;

  // Rutas
  final ScreenClassicShop _classicShop = ScreenClassicShop();
  final ScreenClassicHome _classicHome = ScreenClassicHome();
  final ScreenClassicImage _classicImage = ScreenClassicImage();
  final ScreenClassicPersonal _classicPersonal = ScreenClassicPersonal();
  final ScreenClassicTickets _classicTickets = ScreenClassicTickets();

  Widget _showPage = ScreenClassicHome();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _classicPersonal;
      case 1:
        return _classicShop;
      case 2:
        return _classicHome;
      case 3:
        return _classicImage;
      case 4:
        return _classicTickets;
      default:
        return Center(
          child: Text("No Page Found", style: TextStyle(fontSize: 30)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: pageIndex,
        items: const [
          CurvedNavigationBarItem(child: Icon(Icons.perm_identity), label: 'Personal'),
          CurvedNavigationBarItem(child: Icon(Icons.shopping_bag_outlined), label: 'Store'),
          CurvedNavigationBarItem(child: Icon(Icons.home_outlined), label: 'Home'),
          CurvedNavigationBarItem(child: Icon(Icons.image_outlined), label: 'Image'),
          CurvedNavigationBarItem(child: Icon(Icons.local_activity_outlined), label: 'Tickets'),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Color.fromARGB(223, 4, 4, 4),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int tappedIndex) {
          setState(() {
            _showPage = _pageChooser(tappedIndex);
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Container(
        color: Color.fromARGB(223, 4, 4, 4),
        child: _showPage,
      ),
    );
  }
}
