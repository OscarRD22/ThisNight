import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_downloader/image_downloader.dart';

class ScreenCocoaImageDetail extends StatelessWidget {
  const ScreenCocoaImageDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final img = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String id = img['id'] as String;
    final String url = (img['url'] as String).trim();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "GALLERY",
          textAlign: TextAlign.center,
          style: GoogleFonts.leagueGothic(
            fontSize: 35, color: Colors.white, letterSpacing: .8, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: const Color.fromARGB(156, 31, 29, 29),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.only(top: 120),
          child: Column(children: <Widget>[
            Hero(
              tag: id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(url, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const <Widget>[
                Icon(Icons.favorite, color: Colors.white, size: 30.0),
                Icon(Icons.turned_in_rounded, color: Colors.white, size: 25.0),
                Icon(Icons.send, color: Colors.white, size: 25.0),
              ],
            ),
            const Spacer(),
            FloatingActionButton.extended(
              onPressed: () async {
                try {
                  await ImageDownloader.downloadImage(url);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("DESCARGA COMPLETADA CON ÉXITO")),
                  );
                } catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error al descargar")),
                  );
                }
              },
              icon: const Icon(Icons.download),
              label: const Text('            Download Image            '),
              backgroundColor: Colors.pink,
            ),
          ]),
        ),
      ),
    );
  }
}
