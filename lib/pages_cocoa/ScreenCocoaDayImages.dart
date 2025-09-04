import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ScreenCocoaDayImages extends StatefulWidget {
  final String eventName;
  final String eventTheme;
  final String imagesPath; // p.ej. flyers/Halloween COCOA

  const ScreenCocoaDayImages({
    super.key,
    required this.eventName,
    required this.eventTheme,
    required this.imagesPath,
  });

  @override
  State<ScreenCocoaDayImages> createState() => _ScreenCocoaDayImagesState();
}

class _ScreenCocoaDayImagesState extends State<ScreenCocoaDayImages> {
  int rows = 2;
  late Future<List<_Img>> _imagesF;

  @override
  void initState() {
    super.initState();
    _imagesF = _loadImages();
  }

  Future<List<_Img>> _loadImages() async {
    final cleanPath = widget.imagesPath.trim().replaceAll(RegExp(r'^/+|/+$'), '');
    final ref = FirebaseStorage.instance.ref(cleanPath);

    final res = await ref.listAll();
    // solo imágenes por extensión
    final items = res.items.where((it) {
      final n = it.name.toLowerCase();
      return n.endsWith('.jpg') || n.endsWith('.jpeg') || n.endsWith('.png') || n.endsWith('.webp');
    }).toList();

    final list = await Future.wait(items.map((it) async {
      final url = await it.getDownloadURL();
      return _Img(id: it.name, url: url);
    }));

    list.sort((a, b) => a.id.compareTo(b.id));
    return list;
  }

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
        actions: [
          IconButton(
            onPressed: () => setState(() { _imagesF = _loadImages(); }),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(156, 31, 29, 29),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Row(children: [_text(context), _iconOnePhoto(context)]),
          ),

          Expanded( 
          child: _galleryImages(context),
          ),
        ],
      ),
    );
  }

  Widget _text(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.10,
        width: 330,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.eventName,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.leagueGothic(
                    fontSize: 18, color: Colors.white, letterSpacing: .8, fontWeight: FontWeight.w500)),
            Text(widget.eventTheme,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.leagueGothic(
                    fontSize: 40, color: Colors.white, letterSpacing: .8, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _galleryImages(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: FutureBuilder<List<_Img>>(
          future: _imagesF,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return const Center(child: Text('Error cargando', style: TextStyle(color: Colors.white70)));
            }
            final imgs = snap.data ?? [];
            if (imgs.isEmpty) {
              return const Center(child: Text('Sin imágenes', style: TextStyle(color: Colors.white70)));
            }

            return MasonryGridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: rows),
              itemCount: imgs.length,
              scrollDirection: Axis.vertical,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              itemBuilder: (context, index) {
                final m = imgs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "cocoaImageDetail", arguments: {'id': m.id, 'url': m.url});
                  },
                  child: Hero(
                    tag: m.id,
                    child: Stack(children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(50.0),
                        child: Center(
                          child: CircularProgressIndicator(color: Color.fromARGB(241, 239, 39, 202)),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: m.url,
                            fit: BoxFit.cover,
                            height: rows == 1 ? 250.0 : 150.0,
                          ),
                        ),
                      ),
                    ]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _iconOnePhoto(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.art_track_outlined),
      color: Colors.white,
      onPressed: () {
        rows = rows == 2 ? 1 : 2;
        setState(() {});
      },
    );
  }
}

class _Img {
  final String id;
  final String url;
  _Img({required this.id, required this.url});
}
