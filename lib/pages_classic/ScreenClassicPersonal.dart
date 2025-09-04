import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ScreenClassicPersonal extends StatefulWidget {
  const ScreenClassicPersonal({super.key});

  @override
  State<ScreenClassicPersonal> createState() => _ScreenClassicPersonalState();
}

class _ScreenClassicPersonalState extends State<ScreenClassicPersonal> {
  final _auth = FirebaseAuth.instance;
  final _picker = ImagePicker();
  bool _busy = false;

  User? get _user => _auth.currentUser;

  Future<void> _changeAvatar() async {
    final u = _user;
    if (u == null || _busy) return;

    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _busy = true);
    try {
      final ref = FirebaseStorage.instance.ref('users/${u.uid}/avatar.jpg');
      await ref.putFile(File(picked.path), SettableMetadata(contentType: 'image/jpeg'));
      final url = await ref.getDownloadURL();
      await u.updatePhotoURL(url);
      await u.reload();
      if (mounted) setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto de perfil actualizada')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar la foto')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return '-';
    final d = dt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  Future<void> _sendEmailVerification() async {
    final u = _user;
    if (u == null) return;
    if (u.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email ya verificado')));
      return;
    }
    setState(() => _busy = true);
    try {
      await u.sendEmailVerification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verificación enviada')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _passwordReset() async {
    final email = _user?.email;
    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cuenta sin email')));
      return;
    }
    setState(() => _busy = true);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email de reseteo enviado a $email')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _updateDisplayName() async {
    final u = _user;
    if (u == null) return;
    final controller = TextEditingController(text: u.displayName ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar nombre'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nombre para mostrar'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Guardar')),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await u.updateDisplayName(controller.text.trim());
      await u.reload();
      if (mounted) setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nombre actualizado')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteAccount() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Eliminar cuenta'),
      content: const Text('Esta acción es irreversible. ¿Eliminar tu cuenta?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
      ],
    ),
  );
  if (confirm != true) return;

  setState(() => _busy = true);
  try {
    // Si no tienes _user, usa: FirebaseAuth.instance.currentUser?.delete();
    await _user?.delete();

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, 'landing', (_) => false);
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;
    final msg = e.code == 'requires-recent-login'
        ? 'Vuelve a iniciar sesión para eliminar la cuenta.'
        : (e.message ?? 'Error al eliminar la cuenta');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  } finally {
    if (mounted) setState(() => _busy = false);
  }
}


  @override
  Widget build(BuildContext context) {
    final u = _user;
    final photoUrl = u?.photoURL;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "ACCOUNT",
          textAlign: TextAlign.center,
          style: GoogleFonts.leagueGothic(
            fontSize: 35, color: Colors.white, letterSpacing: .8, fontWeight: FontWeight.w500),
        ),
         actions: [
  IconButton(
    icon: const Icon(Icons.logout),
    tooltip: 'Logout',
    onPressed: () async {
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, 'landing', (_) => false);
    },
  ),
],

      ),
      backgroundColor: const Color.fromARGB(156, 31, 29, 29),
      body: u == null
          ? const Center(child: Text('No autenticado', style: TextStyle(color: Colors.white70)))
          : AbsorbPointer(
              absorbing: _busy,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Avatar clicable: abre galería
                  Row(
                    children: [
                      InkWell(
                        onTap: _changeAvatar,
                        borderRadius: BorderRadius.circular(50),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.pinkAccent,
                          backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                              ? NetworkImage(photoUrl)
                              : null,
                          child: (photoUrl == null || photoUrl.isEmpty)
                              ? Text(
                                  (u.displayName?.isNotEmpty == true
                                          ? u.displayName![0]
                                          : (u.email?.isNotEmpty == true ? u.email![0] : '?'))
                                      .toUpperCase(),
                                  style: const TextStyle(fontSize: 28, color: Colors.white),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u.displayName?.trim().isNotEmpty == true ? u.displayName!.trim() : 'Sin nombre',
                                style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(u.email ?? '', style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _busy ? null : _updateDisplayName,
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Editar'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Verificación de email', style: TextStyle(color: Colors.white)),
                    subtitle: Text(u.emailVerified ? 'Verificado' : 'Tocar para enviar verificación',
                        style: const TextStyle(color: Colors.white70)),
                    trailing: Icon(
                      u.emailVerified ? Icons.verified : Icons.error_outline,
                      color: u.emailVerified ? Colors.lightGreenAccent : Colors.orangeAccent,
                    ),
                    onTap: _busy ? null : _sendEmailVerification,
                  ),
                  ListTile(
                    title: const Text('UID', style: TextStyle(color: Colors.white)),
                    subtitle: Text(u.uid, style: const TextStyle(color: Colors.white70)),
                  ),
                  ListTile(
                    title: const Text('Cambiar contraseña (email)', style: TextStyle(color: Colors.white)),
                    trailing: const Icon(Icons.lock_reset, color: Colors.white70),
                    onTap: _busy ? null : _passwordReset,
                  ),

                  const SizedBox(height: 16),
                  Card(
                    color: const Color.fromARGB(40, 244, 67, 54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.warning_amber, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Zona peligrosa',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                              onPressed: _busy ? null : _deleteAccount,
                              icon: const Icon(Icons.delete_forever),
                              label: const Text('Eliminar cuenta'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_busy) const SizedBox(height: 24),
                  if (_busy) const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
    );
  }
}