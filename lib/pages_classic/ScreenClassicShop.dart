import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenClassicShop extends StatelessWidget {
  const ScreenClassicShop({super.key});

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFF2EB1);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "STORE",
          style: GoogleFonts.leagueGothic(
            fontSize: 35,
            color: Colors.white,
            letterSpacing: .8,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(156, 31, 29, 29),
      body: Container(
        // Fondo degradado para mantener look&feel
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF2B2B2B), Colors.black],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 56, color: Colors.white70),
                  const SizedBox(height: 12),
                  Text(
                    'COMING SOON',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.leagueGothic(
                      fontSize: 56,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PRÓXIMAMENTE',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.leagueGothic(
                      fontSize: 28,
                      color: Colors.white70,
                      letterSpacing: .8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Estamos preparando el merchandising de Classic Mataró.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(.85)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Vuelve pronto para ser el primero en pillarlo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(.7)),
                  ),
                  const SizedBox(height: 20),
                  // Botón deshabilitado a modo informativo
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: null, // deshabilitado
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: pink.withOpacity(.35),
                        disabledForegroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      child: const Text('Abrirá pronto'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
