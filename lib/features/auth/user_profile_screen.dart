import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_controller.dart';

/// Full user profile screen matching stitch_ai_advocate_app_ui/user_profile_ai_advocate
class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final profile = auth.profile;

    final name = (profile?.name.isNotEmpty == true) ? profile!.name : 'Guest';
    final phone = profile?.phone.isNotEmpty == true
        ? '+91 ${profile!.phone.substring(0, 5)} ${profile.phone.substring(5)}'
        : '—';
    final language = profile?.language ?? 'English';
    final state = profile?.state ?? '—';

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),
      appBar: AppBar(
        backgroundColor: const Color(0xE6FFFFFF),
        elevation: 0,
        shadowColor: const Color(0x0A000000),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'User Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B1C19),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          // Profile summary card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 8,
                    offset: Offset(0, 2))
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFF121C2E),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x4D121C2E),
                              blurRadius: 12,
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: Center(
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'G',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -1,
                      right: -1,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Color(0x14000000), blurRadius: 4)
                          ],
                        ),
                        child: const Icon(Icons.person,
                            size: 16, color: Color(0xFF1B3358)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B1C19),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(phone,
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF45474C))),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EEFC),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Text('Local Profile',
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF2F5BD8),
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1B1C19),
                      side: BorderSide.none,
                      backgroundColor: const Color(0xFFF0EEE9),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit Profile',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Account info rows
          _InfoCard(children: [
            _InfoRow(
                icon: Icons.translate,
                title: 'Preferred Language',
                subtitle: language),
            const Divider(
                height: 1, color: Color(0xFFEAE8E3), indent: 16, endIndent: 16),
            _InfoRow(
                icon: Icons.location_on_outlined,
                title: 'State',
                subtitle: state),
          ]),
          const SizedBox(height: 16),

          // Navigation rows
          _InfoCard(children: [
            _NavRow(
                icon: Icons.folder_outlined,
                label: 'My Cases',
                onTap: () => context.go('/cases')),
            const Divider(height: 1, color: Color(0xFFEAE8E3)),
            _NavRow(
                icon: Icons.bookmark_outline,
                label: 'Saved Research',
                onTap: () => context.go('/saved')),
            const Divider(height: 1, color: Color(0xFFEAE8E3)),
            _NavRow(
                icon: Icons.settings_outlined, label: 'Settings', onTap: () {}),
          ]),
          const SizedBox(height: 16),

          // Log out
          _InfoCard(children: [
            _NavRow(
              icon: Icons.logout,
              label: 'Log Out',
              onTap: () => _showLogoutDialog(context, ref),
            ),
          ]),
          const SizedBox(height: 24),
        ].animate(interval: 60.ms).fadeIn(duration: 300.ms),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E2DD),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Log out of AI Advocate?',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B1C19)),
            ),
            const SizedBox(height: 8),
            const Text(
              'You can sign in again using your phone number.',
              style: TextStyle(fontSize: 14, color: Color(0xFF75777D)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ref.read(authControllerProvider.notifier).logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF121C2E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Log Out',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF0EEE9),
                  foregroundColor: const Color(0xFF1B1C19),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cancel',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D000000), blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(
      {required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEE9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF45474C)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B1C19))),
              Text(subtitle,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF75777D))),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EEE9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFF45474C)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B1C19))),
              ),
              const Icon(Icons.chevron_right,
                  size: 20, color: Color(0xFF75777D)),
            ],
          ),
        ),
      ),
    );
  }
}
