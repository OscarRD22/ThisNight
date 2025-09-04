import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cocoa_app/auth/auth_gate.dart';


class ScreenCocoaMainLoginRegistro extends StatelessWidget {
  const ScreenCocoaMainLoginRegistro({super.key});

  static const Color _pink = Color(0xFFFF2EB1); // Color rosa principal

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleFontSize = size.width * 0.16; 

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B2B2B), Colors.black],
          ),
        ),
        child: SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 99, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey,\nReady\nfor tonight?',
                  style: GoogleFonts.leagueGothic(
                    fontSize: titleFontSize.clamp(48, 96).toDouble(),
                    color: Colors.white,
                    height: 1,
                    letterSpacing: 0.9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                // Botón Log in
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, 'auth'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pink,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
