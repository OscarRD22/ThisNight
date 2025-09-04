import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Widgets/home_Classic_widgets.dart';

class ScreenClassicHome extends StatelessWidget {
  const ScreenClassicHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pushNamed(context, "HomeScreen"),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Image.asset(
          'assets/images/logo_classic.png', // cambia si tu asset tiene otro nombre
          width: 150,
          height: 100,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, 'landing', (_) => false);
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(156, 31, 29, 29),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(alignment: Alignment.topLeft),
            const SizedBox(height: 10),
            ThisWeekClassicPartys(),
            const SizedBox(height: 10),
            SliderNextClassicPartys(),
          ],
        ),
      ),
    );
  }
}
