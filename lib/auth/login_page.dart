import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart'; // arriba del archivo


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color _pink = Color(0xFFFF2EB1);

  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  bool _isLogin = true;
  bool _busy = false;
  bool _showPass = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _pass.text,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _pass.text,
        );
      }
      // AuthGate se encargará de redirigir si usas StreamBuilder de FirebaseAuth.
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resetPassword() async {
    final mail = _email.text.trim();
    if (mail.isEmpty || !mail.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce un email válido')),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: mail);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Te enviamos un email para restablecer la contraseña')),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'No se pudo enviar el email')),
      );
    }
  }

  InputDecoration _decoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _pink, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true, // <- permite que el body suba hasta el notch
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF2B2B2B), Colors.black],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título grande estilo ScreenCocoaMainLoginRegistro
                      Text(
                        _isLogin ? 'Log in' : 'Sign up',
                        style: GoogleFonts.leagueGothic(
                          fontSize: (size.width * 0.16).clamp(48, 96).toDouble(),
                          color: Colors.white,
                          height: .95,
                          letterSpacing: .2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isLogin
                            ? 'Bienvenido de nuevo. Ready for tonight?'
                            : 'Crea tu cuenta. Let’s get the party started.',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 24),

                      // Toggle Login / Registro tipo chips
                      Row(
                        children: [
                          Expanded(
                            child: _ModeChip(
                              text: 'Iniciar sesión',
                              selected: _isLogin,
                              onTap: _busy ? null : () => setState(() => _isLogin = true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ModeChip(
                              text: 'Registrarme',
                              selected: !_isLogin,
                              onTap: _busy ? null : () => setState(() => _isLogin = false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Email
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration(label: 'Email', icon: Icons.mail_outline),
                        validator: (v) => v != null && v.contains('@') ? null : 'Email inválido',
                        enabled: !_busy,
                      ),
                      const SizedBox(height: 14),

                      // Password
                      TextFormField(
                        controller: _pass,
                        obscureText: !_showPass,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration(label: 'Contraseña', icon: Icons.lock_outline).copyWith(
                          suffixIcon: IconButton(
                            onPressed: _busy ? null : () => setState(() => _showPass = !_showPass),
                            icon: Icon(_showPass ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                          ),
                        ),
                        validator: (v) => v != null && v.length >= 6 ? null : 'Mínimo 6 caracteres',
                        enabled: !_busy,
                      ),

                      if (_isLogin) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _busy ? null : _resetPassword,
                            child: const Text('¿Olvidaste la contraseña?'),
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),

                      // Botón principal
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _busy ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _pink,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            elevation: 0,
                          ),
                          child: _busy
                              ? const SizedBox(
                                  height: 22, width: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Text(
                                  _isLogin ? 'Entrar' : 'Crear cuenta',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),

                      const SizedBox(height: 12),

                     

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback? onTap;
  const _ModeChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _LoginPageState._pink : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? _LoginPageState._pink : Colors.white.withOpacity(0.15),
            width: 1.2,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
