import 'package:flutter/material.dart';

class HomeScreenPrivat extends StatelessWidget {
  const HomeScreenPrivat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_privat.jpeg',
              scale: 5,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              '         ',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(),
      ),
    );
  }
}
