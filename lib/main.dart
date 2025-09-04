import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Screens/screens.dart';
import 'auth/auth_gate.dart';
import 'Screens/ScreenCocoaMainLoginRegistro.dart'; //pantalla inicial

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Pantalla inicial
      home: const ScreenCocoaMainLoginRegistro(),

      // Rutas
      routes: {
        // Acceso al flujo de auth desde el botón "Log in / Sign up"
        "auth": (context) => const AuthGate(),
        "landing": (_) => const ScreenCocoaMainLoginRegistro(), // 
        "HomeScreen": (context) => const MainMenu(),
        "cocoaHomePage": (context) => HomeScreenCocoa(),
        "classicHomePage": (context) => HomeScreenClassic(),
        "privatHomePage": (context) => const HomeScreenPrivat(),
        "cocoaImageDetail": (context) => const ScreenCocoaImageDetail(),
        "cocoaImagenes": (context) => ScreenCocoaImage(),
        "cocoaIA": (_) => ScreenCocoaIA(),
        "classicTikets": (_) => const ScreenClassicTickets(),

      },
    );
  }
}
