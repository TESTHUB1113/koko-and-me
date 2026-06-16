import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/user_profile.dart';

// ─── EDIT PROFILE SCREEN ─────────────────────────────────────────────────────
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  String? _pickedImagePath;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl  = TextEditingController(text: UserProfile.name);
    _emailCtrl = TextEditingController(text: UserProfile.email);
    _pickedImagePath = UserProfile.avatarPath.isNotEmpty ? UserProfile.avatarPath : null;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked != null) {
      setState(() => _pickedImagePath = picked.path);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await UserProfile.save(
      newName:       _nameCtrl.text,
      newEmail:      _emailCtrl.text,
      newAvatarPath: _pickedImagePath ?? '',
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232337),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xEE0E0920),
                border: Border(
                  bottom: BorderSide(
                      color: const Color(0xFF52EBE9).withValues(alpha: 0.15)),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 14, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // ── Tappable avatar
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          // Avatar circle
                          Container(
                            width: 100, height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF8689E8),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: _pickedImagePath != null
                                ? Image.file(
                                    File(_pickedImagePath!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _InitialText(_nameCtrl),
                                  )
                                : _InitialText(_nameCtrl),
                          ),

                          // Camera badge
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              width: 30, height: 30,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1BC6C6),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color(0xFF232337), width: 2),
                              ),
                              child: const Icon(Icons.camera_alt_rounded,
                                  size: 15, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'Tap to change photo',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.40),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Name field
                    _label('Full Name'),
                    const SizedBox(height: 8),
                    _Field(
                      controller: _nameCtrl,
                      hint: 'e.g. Alex Johnson',
                      icon: Icons.person_outline_rounded,
                    ),

                    const SizedBox(height: 20),

                    // ── Email field
                    _label('Email Address'),
                    const SizedBox(height: 8),
                    _Field(
                      controller: _emailCtrl,
                      hint: 'e.g. alex@company.com',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 40),

                    // ── Save button
                    GestureDetector(
                      onTap: _saving ? null : _save,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF501794), Color(0xFF3E70A1)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: _saving
                            ? const SizedBox(
                                width: 22, height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Color(0xFFD9D9D9),
          ),
        ),
      );
}

// ─── INITIAL LETTER (fallback when no photo) ─────────────────────────────────
class _InitialText extends StatelessWidget {
  final TextEditingController ctrl;
  const _InitialText(this.ctrl);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: ctrl,
      builder: (_, val, __) {
        final initial = val.text.isNotEmpty
            ? val.text.trim()[0].toUpperCase()
            : 'A';
        return Center(
          child: Text(
            initial,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
              fontSize: 42,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

// ─── FIELD WIDGET ─────────────────────────────────────────────────────────────
class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF3B2063),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF190733).withValues(alpha: 0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.35)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.30),
                  fontFamily: 'Nunito',
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
