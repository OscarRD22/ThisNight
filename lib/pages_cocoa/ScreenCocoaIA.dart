// lib/pages_cocoa/ScreenCocoaIA.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

/// NO hardcodees tu key. Pásala con:
/// flutter run --dart-define=OPENAI_API_KEY=sk-XXXX
const String _apiKey = String.fromEnvironment('OPENAI_API_KEY');

class ScreenCocoaIA extends StatefulWidget {
  const ScreenCocoaIA({super.key});
  @override
  State<ScreenCocoaIA> createState() => _ScreenCocoaIAState();
}

class _ScreenCocoaIAState extends State<ScreenCocoaIA> {
  final _input = TextEditingController();
  final List<_Msg> _msgs = <_Msg>[];
  bool _sending = false;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() {
      _msgs.add(_Msg(role: 'user', text: text));
      _input.clear();
      _sending = true;
    });

    final reply = await _askOpenAI(_msgs);
    setState(() {
      _msgs.add(_Msg(role: 'assistant', text: reply));
      _sending = false;
    });
  }

  Future<String> _askOpenAI(List<_Msg> history) async {
    if (_apiKey.isEmpty) {
      return 'API key no configurada. Ejecuta con --dart-define=OPENAI_API_KEY=sk-XXXX';
    }

    final uri = Uri.parse('https://api.openai.com/v1/responses');
    final headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };

    const systemText =
        'Eres un asistente de un club nocturno. Respondes en español, breve y claro. '
        'Temas: fiesta, dress code, outfits, música, reservas, horarios, precios estándar, '
        'seguridad y transporte. Si está fuera de tema, redirige. No inventes datos.';

    final input = <Map<String, dynamic>>[
      {
        'role': 'system',
        'content': [
          {'type': 'input_text', 'text': systemText}
        ]
      },
      for (final m in history)
        {
          'role': m.role,
          'content': [
            {'type': 'input_text', 'text': m.text}
          ]
        },
    ];

    final body = jsonEncode({'model': 'gpt-4o-mini', 'input': input});

    http.Response res;
    try {
      res = await http
          .post(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: 30));
    } on TimeoutException {
      return 'Tiempo de espera agotado. Reintenta.';
    } catch (e) {
      return 'Fallo de red: $e';
    }

    if (res.statusCode >= 400) {
      debugPrint('OpenAI ${res.statusCode}: ${res.body}');
      return _mapError(res.statusCode, res.body);
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final outText =
        (data['output_text'] as String?) ?? _extractFirstTextFromOutput(data['output']);
    return (outText?.trim().isNotEmpty == true) ? outText!.trim() : 'Sin respuesta.';
  }

  String _mapError(int code, String body) {
    // Intenta extraer mensaje del JSON:
    String? msg;
    try {
      final j = jsonDecode(body);
      msg = (j['error']?['message'] ?? j['message'])?.toString();
    } catch (_) {}

    if (code == 401) return 'API key inválida o revocada.';
    if (code == 429) return 'Límite/saldo agotado. Reintenta más tarde.';
    if (code == 400) return 'Petición inválida. Revisa el modelo y el formato.';
    return 'Error $code${msg != null ? ": $msg" : ""}';
  }

  String? _extractFirstTextFromOutput(dynamic output) {
    if (output is List && output.isNotEmpty) {
      final first = output.first;
      if (first is Map && first['content'] is List) {
        for (final c in (first['content'] as List)) {
          final t = c['text'];
          if (t is String && t.isNotEmpty) return t;
          if (c['type'] == 'output_text' && t is String && t.isNotEmpty) return t;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final keyMissing = _apiKey.isEmpty;
    return Scaffold(
      backgroundColor: const Color.fromARGB(156, 31, 29, 29),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:  Text(
          'COCO IA',
          style: GoogleFonts.leagueGothic(
            fontSize: 35,
            color: Colors.white,
            letterSpacing: .8,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (keyMissing)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Falta OPENAI_API_KEY',
                  style: TextStyle(color: Colors.orangeAccent),
                ),
              ),
            const SizedBox(height: 12),
            CircleAvatar(
              radius: 44,
              backgroundColor: Colors.pinkAccent,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/ia_avatar.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.auto_awesome, color: Colors.white, size: 36),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: _msgs.length,
                itemBuilder: (context, i) {
                  final m = _msgs[i];
                  final isUser = m.role == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.78,
                      ),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.pinkAccent : const Color(0xFF2E2B2B),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(14),
                          topRight: const Radius.circular(14),
                          bottomLeft: Radius.circular(isUser ? 14 : 4),
                          bottomRight: Radius.circular(isUser ? 4 : 14),
                        ),
                      ),
                      child: Text(m.text, style: const TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Pregunta sobre outfits, dress code, horarios…',
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: const Color(0xFF242222),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sending ? null : _send,
                    icon: _sending
                        ? const SizedBox(
                            width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.send),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Msg {
  final String role; // 'user' | 'assistant'
  final String text;
  _Msg({required this.role, required this.text});
}
