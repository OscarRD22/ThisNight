import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ScreenCocoaTikets extends StatefulWidget {
  const ScreenCocoaTikets({super.key});
  @override
  State<ScreenCocoaTikets> createState() => _ScreenCocoaTiketsState();
}

class _ScreenCocoaTiketsState extends State<ScreenCocoaTikets> {
  static final Uri _eventsUri =
      Uri.parse('https://www.fourvenues.com/es/cocoa-mataro/events');

  late final WebViewController _ctrl;
  int _progress = 0;

  static const _hideHeaderJS = r'''
    (function () {
      function hide() {
        const sel = [
          'header','nav','[role="banner"]',
          '[id*="header"]','[class*="header"]','[class*="Header"]',
          '.navbar','.site-header'
        ].join(',');
        document.querySelectorAll(sel).forEach(el => el.style.setProperty('display','none','important'));
        const candidates = Array.from(document.querySelectorAll('h1,h2'))
          .filter(h => /cocoa/i.test(h.textContent || ''));
        candidates.forEach(h => (h.closest('section,div,header') || h).style.setProperty('display','none','important'));
      }
      hide();
      new MutationObserver(hide).observe(document.body || document.documentElement, {childList:true,subtree:true});
    })();
  ''';

  @override
  void initState() {
    super.initState();
    _ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color.fromARGB(156, 31, 29, 29))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (p) => setState(() => _progress = p),
        onPageFinished: (_) => _ctrl.runJavaScript(_hideHeaderJS),
      ))
      ..loadRequest(_eventsUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Atrás',
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'TICKETS',
          style: GoogleFonts.leagueGothic(
            fontSize: 35,
            color: Colors.white,
            letterSpacing: .8,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Ir a eventos',
            onPressed: () async {
              await _ctrl.loadRequest(_eventsUri); // siempre va a /events
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(156, 31, 29, 29),
      body: Stack(
        children: [
          WebViewWidget(controller: _ctrl),
          if (_progress < 100) LinearProgressIndicator(value: _progress / 100),
        ],
      ),
    );
  }
}
