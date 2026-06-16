import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0920),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Privacy Policy',
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
            const Divider(color: Color(0xFF1BC6C6), thickness: 0.2, height: 1),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _Section(
                      title: 'Last updated: June 2025',
                      body: 'koko&me ("we", "our", "us") is committed to protecting your privacy. '
                          'This policy explains what data we collect, how we use it, and your rights.',
                    ),
                    _Section(
                      title: '1. Data We Collect',
                      body: 'We collect the following personal data when you create an account:\n'
                          '  • Name and email address\n'
                          '  • Learning progress (XP, streak, completed lessons)\n'
                          '  • Department preferences selected during onboarding\n\n'
                          'We do not collect payment information, location data, or device identifiers.',
                    ),
                    _Section(
                      title: '2. How We Use Your Data',
                      body: 'Your data is used exclusively to:\n'
                          '  • Provide and personalise the learning experience\n'
                          '  • Sync your progress across devices\n'
                          '  • Send streak reminder notifications (only if you enable them)\n\n'
                          'We do not sell, share, or rent your data to third parties.',
                    ),
                    _Section(
                      title: '3. Data Storage',
                      body: 'Your data is stored securely using Google Firebase (Firestore and Authentication), '
                          'which is hosted in the European Union. Data is encrypted in transit (TLS) '
                          'and at rest.',
                    ),
                    _Section(
                      title: '4. Your Rights (GDPR)',
                      body: 'Under the GDPR, you have the right to:\n'
                          '  • Access your data: request a copy at any time\n'
                          '  • Correct your data: update your name or email in Settings\n'
                          '  • Delete your data: use "Delete Account" in Settings\n'
                          '  • Withdraw consent: disable notifications in Settings\n\n'
                          'To exercise your rights, contact us at privacy@kokome.app',
                    ),
                    _Section(
                      title: '5. Account Deletion',
                      body: 'You can permanently delete your account and all associated data '
                          'at any time from Settings > Delete Account. '
                          'Deletion is immediate and irreversible.',
                    ),
                    _Section(
                      title: '6. Cookies & Analytics',
                      body: 'We do not use advertising cookies or third-party analytics trackers. '
                          'Firebase may collect anonymised crash and performance data to help us '
                          'improve the app.',
                    ),
                    _Section(
                      title: '7. Children',
                      body: 'koko&me is intended for users aged 16 and over. '
                          'We do not knowingly collect data from children under 16.',
                    ),
                    _Section(
                      title: '8. Contact',
                      body: 'For any privacy-related questions:\n'
                          'Email: privacy@kokome.app',
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
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: Color(0xFF1BC6C6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              height: 1.7,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}
