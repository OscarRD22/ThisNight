

import 'package:cocoa_app/Screens/screens.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';


class HomeScreenCocoa extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<HomeScreenCocoa> {
  int pageIndex = 2;

  //Creacion de todas las rutas.
  final ScreenCocoaShop _cocoaShop = ScreenCocoaShop();
  final ScreenCocoaHome _cocoaHome = ScreenCocoaHome();
  final ScreenCocoaImage _cocoaImage = ScreenCocoaImage();
  final ScreenCocoaPersonal _cocoaPersonal = ScreenCocoaPersonal();
  final ScreenCocoaTikets _cocoaTikets = ScreenCocoaTikets();

  Widget _showPage = new ScreenCocoaHome();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _cocoaPersonal;
        break;
      case 1:
        return _cocoaShop;
        break;
      case 2:
        return _cocoaHome;
        break;
      case 3:
        return _cocoaImage;
        break;
      case 4:
        return _cocoaTikets;
        break;
      default:
        return Container(
          child: const Center(
              child: Text(
            "No Page Found",
            style: TextStyle(fontSize: 30),
          )),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: pageIndex,
        items: [
          const CurvedNavigationBarItem(
              child: Icon(Icons.perm_identity), label: 'Personal'),
          CurvedNavigationBarItem(
            child: const Icon(Icons.shopping_bag_outlined),
            label: 'Store',
          ),
          CurvedNavigationBarItem(
            child: const Icon(Icons.home_outlined),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.image_outlined),
            label: 'Image',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.local_activity_outlined),
            label: 'Tickets',
          ),
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
