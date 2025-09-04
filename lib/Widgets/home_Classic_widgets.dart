import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

// DB no-default
final FirebaseFirestore db =
    FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'bbddappcocoa');

// Helper: abrir enlaces dentro de la app
Future<void> _openInApp(String url) async {
  if (url.isEmpty) return;
  final uri = Uri.parse(url);
  final ok = await launchUrl(
    uri,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
  );
  if (!ok) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class ThisWeekClassicPartys extends StatelessWidget {
  const ThisWeekClassicPartys({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "ESTA SEMANA",
              style: GoogleFonts.leagueGothic(
                fontSize: 30,
                color: Colors.white,
                letterSpacing: .8,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: db.collection('flyers_week_classic').orderBy('order').snapshots(),
              builder: (context, snap) {
                if (snap.hasError) {
                  return const Center(
                      child: Text('Error cargando',
                          style: TextStyle(color: Colors.white70)));
                }
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Sin flyers',
                          style: TextStyle(color: Colors.white70)));
                }

                final docs = snap.data!.docs;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final data = docs[i].data();
                    final rawImg = data['imageUrl'] as String? ?? '';
                    final rawBuy = data['entradasUrl'] as String? ?? '';
                    final imgUrl =
                        rawImg.trim().replaceAll(RegExp(r'^"|"$'), '');
                    final buyUrl =
                        rawBuy.trim().replaceAll(RegExp(r'^"|"$'), '');

                    return InkWell(
                      onTap: buyUrl.isEmpty ? null : () => _openInApp(buyUrl),
                      child: _FlyerCard(
                        url: imgUrl,
                        width: 175,
                        height: 180,
                        radius: 25,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SliderNextClassicPartys extends StatelessWidget {
  const SliderNextClassicPartys({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _NextPartiesSection(),
        SizedBox(height: 20),
        _AftermoviesSection(),
        SizedBox(height: 20),
        _OutfitSection(),
      ],
    );
  }
}

class _NextPartiesSection extends StatelessWidget {
  const _NextPartiesSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(text: "PRÓXIMAS FIESTAS"),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: db.collection('flyers_next_classic').orderBy('order').snapshots(),
              builder: (context, snap) {
                if (snap.hasError) {
                  return const Center(
                      child: Text('Error cargando',
                          style: TextStyle(color: Colors.white70)));
                }
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Sin flyers',
                          style: TextStyle(color: Colors.white70)));
                }

                final docs = snap.data!.docs;
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final raw = docs[i].data()['imageUrl'] as String? ?? '';
                    final url = raw.trim().replaceAll(RegExp(r'^"|"$'), '');
                    return _FlyerCard(
                      url: url,
                      width: 330,
                      height: 250,
                      radius: 20,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AftermoviesSection extends StatelessWidget {
  const _AftermoviesSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(text: "AFTERMOVIES"),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: db.collection('aftermovies_classic').orderBy('order').snapshots(),
              builder: (context, snap) {
                if (snap.hasError) {
                  return const Center(
                      child: Text('Error cargando',
                          style: TextStyle(color: Colors.white70)));
                }
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Sin vídeos',
                          style: TextStyle(color: Colors.white70)));
                }

                final docs = snap.data!.docs;
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final raw = docs[i].data()['videoUrl'] as String? ?? '';
                    final url = raw.trim().replaceAll(RegExp(r'^"|"$'), '');
                    return _VideoCard(
                      url: url,
                      width: 330,
                      height: 200,
                      radius: 16,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// NUEVA SECCIÓN: HABLA CON COCO AI
class _OutfitSection extends StatelessWidget {
  const _OutfitSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250, // look&feel consistente
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(text: "HABLA CON COCO IA"),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: db.collection('outfit').limit(1).snapshots(),
              builder: (context, snap) {
                if (snap.hasError) {
                  return const Center(
                    child: Text('Error cargando', style: TextStyle(color: Colors.white70)),
                  );
                }
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(
                    child: Text('Configura la imagen en /outfit', style: TextStyle(color: Colors.white70)),
                  );
                }

                final raw = docs.first.data()['imageUrl'] as String? ?? '';
                final url = raw.trim().replaceAll(RegExp(r'^"|"$'), '');

                return ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, "cocoaIA"),
                      child: _LogoCard( // tarjeta especial para logos con fondo oscuro
                        url: url,
                        width: 350,
                        height: 200,
                        radius: 100,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        text,
        style: GoogleFonts.leagueGothic(
          fontSize: 30,
          color: Colors.white,
          letterSpacing: .8,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _FlyerCard extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final double radius;
  final EdgeInsets outerMargin;
  const _FlyerCard({
    required this.url,
    required this.width,
    required this.height,
    required this.radius,
    this.outerMargin = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        color: Colors.transparent,
        margin: outerMargin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (_, __, ___) => Container(
              color: Colors.black26,
              child: const Icon(Icons.broken_image, color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta de logo: mantiene proporción, centra y usa fondo negro con padding.
class _LogoCard extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final double radius;
  final EdgeInsets outerMargin;
  const _LogoCard({
    required this.url,
    required this.width,
    required this.height,
    required this.radius,
    this.outerMargin = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        margin: outerMargin,
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            color: Colors.black, // fondo oscuro
            padding: const EdgeInsets.all(12),
            alignment: Alignment.center,
            child: CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (_, provider) => FittedBox(
                fit: BoxFit.contain,
                child: Image(
                  image: provider,
                  filterQuality: FilterQuality.high,
                  alignment: Alignment.center,
                ),
              ),
              placeholder: (_, __) =>
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              errorWidget: (_, __, ___) => const Icon(
                Icons.broken_image_outlined,
                color: Colors.white30,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoCard extends StatefulWidget {
  final String url;
  final double width;
  final double height;
  final double radius;
  final EdgeInsets outerMargin;
  const _VideoCard({
    required this.url,
    required this.width,
    required this.height,
    required this.radius,
    this.outerMargin = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    super.key,
  });

  @override
  State<_VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<_VideoCard> {
  VideoPlayerController? _controller;
  bool _ready = false;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    if (widget.url.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..setLooping(true)
        ..initialize().then((_) {
          if (!mounted) return;
          setState(() => _ready = true);
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (!_ready || _controller == null) return;
    if (_controller!.value.isPlaying) {
      _controller!.pause();
      setState(() => _playing = false);
    } else {
      _controller!.play();
      setState(() => _playing = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: widget.outerMargin,
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.radius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_ready && _controller != null)
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                )
              else
                const Center(child: CircularProgressIndicator()),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _togglePlay,
                  child: Center(
                    child: Icon(
                      _playing ? Icons.pause_circle_filled : Icons.play_circle_fill,
                      size: 56,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              if (_ready && _controller != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: VideoProgressIndicator(
                    _controller!,
                    allowScrubbing: true,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
