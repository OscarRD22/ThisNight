// ignore_for_file: unused_element

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(156, 31, 29, 29),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logoBG.png',
                    width: 200,
                    height: 120,
                  ),
                ),
                _cocoa(context),
                const SizedBox(
                  height: 20,
                ),
                _classic(context),
                const SizedBox(
                  height: 20,
                ),
                _privat(context),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "DISCOTECAS DE REFERÈNCIA",
                    style: GoogleFonts.leagueGothic(
                      fontSize: 30,
                      color: Colors.white,
                      letterSpacing: .8,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _cocoa(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "cocoaHomePage");
        },
        child: Container(
          height: 160.0,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[850]!.withOpacity(0.29),
                    offset: const Offset(-10, 10),
                    blurRadius: 10,
                    spreadRadius: 10)
              ],
              image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/menu_cocoa.JPG'))),
          child: const Center(
            child: Text(
              '', //Añadir texto AQUI!!!
              style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5),
            ),
          ),
        ),
      ),
    );
  }

  _classic(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "classicHomePage");
          ;
        },
        child: Container(
          height: 160.0,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[850]!.withOpacity(0.29),
                    offset: const Offset(-10, 10),
                    blurRadius: 10,
                    spreadRadius: 10)
              ],
              image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/menu_classic.JPG'))),
          child: const Center(
            child: Text(
              '', //Añadir texto AQUI!!!
              style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5),
            ),
          ),
        ),
      ),
    );
  }

 _privat(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      // bloquea navegación normal y muestra aviso
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PRIVAT: próximamente')),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(32)),
      child: Container(
        height: 160.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[850]!.withOpacity(0.29),
              offset: const Offset(-10, 10),
              blurRadius: 10,
              spreadRadius: 10,
            ),
          ],
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/menu_privat.jpeg'),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // capa oscura con el mismo radio
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: const BorderRadius.all(Radius.circular(32)),
              ),
            ),
            // rótulo
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, color: Colors.white70, size: 36),
                  const SizedBox(height: 8),
                  Text(
                    'COMING SOON',
                    style: GoogleFonts.leagueGothic(
                      fontSize: 44,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'PRÓXIMAMENTE',
                    style: GoogleFonts.leagueGothic(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  _logo(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset(
          'assets/images/GrupCocoaLogo.png',
        ),
      ],
    );
  }
}
