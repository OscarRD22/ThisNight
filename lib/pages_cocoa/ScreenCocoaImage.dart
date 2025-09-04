import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import 'ScreenCocoaDayImages.dart';

final FirebaseFirestore db =
    FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'bbddappcocoa');

class ScreenCocoaImage extends StatelessWidget {
  const ScreenCocoaImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "GALLERY",
          style: GoogleFonts.leagueGothic(
              fontSize: 35, color: Colors.white, letterSpacing: .8, fontWeight: FontWeight.w500),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.collections_rounded))],
      ),
      backgroundColor: const Color.fromARGB(156, 31, 29, 29),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: db.collection('gallery_events').orderBy('order').snapshots(),
        builder: (context, snap) {
          if (snap.hasError) {
            return const Center(child: Text('Error cargando', style: TextStyle(color: Colors.white70)));
          }
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('Sin eventos', style: TextStyle(color: Colors.white70)));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, index) {
              final doc = docs[index];
              final data = doc.data();
              final flyerUrl =
                  ((data['flyerUrl'] as String?) ?? '').trim().replaceAll(RegExp(r'^"|"$'), '');
              final name = ((data['name'] as String?) ?? '').trim();
              final theme = ((data['theme'] as String?) ?? '').trim();
              // Define la carpeta en Storage en el campo imagesPath (ej: flyers/Halloween COCOA)
              final imagesPath = (((data['imagesPath'] as String?) ?? '')
                          .trim()
                          .replaceAll(RegExp(r'^/+|/+$'), '')
                          .replaceAll(RegExp(r'^"|"$'), ''))
                      .isNotEmpty
                  ? ((data['imagesPath'] as String).trim())
                  : 'gallery_events/${doc.id}/images';

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScreenCocoaDayImages(
                        eventName: name,
                        eventTheme: theme,
                        imagesPath: imagesPath,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Container(
                    height: 140.0,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      image: flyerUrl.isEmpty
                          ? null
                          : DecorationImage(image: NetworkImage(flyerUrl), fit: BoxFit.cover),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(name,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.leagueGothic(
                                  fontSize: 20, color: Colors.white, letterSpacing: .8, fontWeight: FontWeight.w500)),
                          Text(theme,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.leagueGothic(
                                  fontSize: 40, color: Colors.white, letterSpacing: .8, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
