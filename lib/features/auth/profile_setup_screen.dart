import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_controller.dart';

const _languages = [
  'English',
  'Hindi (हिंदी)',
  'Tamil (தமிழ்)',
  'Telugu (తెలుగు)',
  'Marathi (मराठी)'
];

const _states = [
  'Karnataka',
  'Delhi',
  'Maharashtra',
  'Tamil Nadu',
  'West Bengal',
  'Uttar Pradesh',
  'Telangana',
  'Gujarat',
  'Rajasthan',
  'Kerala',
];

/// Profile setup screen matching stitch_ai_advocate_app_ui/profile_setup_ai_advocate
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  String _language = 'English';
  String _state = 'Karnataka';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(authControllerProvider.notifier).saveProfile(
          name: _nameController.text,
          language: _language,
          state_: _state,
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (prev, next) {
      if (next.error != null && prev?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(next.error!),
              backgroundColor: const Color(0xFFBA1A1A)),
        );
        ref.read(authControllerProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 12),
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () =>
                      ref.read(authControllerProvider.notifier).skipProfile(),
                  child: const Text('Skip for now',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF45474C),
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Set up your profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.36,
                color: Color(0xFF1B1C19),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tell us a little about yourself.',
              style: TextStyle(
                  fontSize: 14, color: Color(0xFF45474C), height: 1.6),
            ),
            const SizedBox(height: 20),
            // Profile card
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
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF5F3EE),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x14000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 2))
                              ],
                            ),
                            child: const Icon(Icons.person,
                                size: 44, color: Color(0xFF45474C)),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4263EB),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0x26000000), blurRadius: 4)
                                ],
                              ),
                              child: const Icon(Icons.photo_camera,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Add photo (Optional)',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF45474C),
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Full name
                  _FormField(
                    label: 'Full Name',
                    required: true,
                    icon: Icons.badge_outlined,
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF1B1C19)),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Vikram Malhotra',
                        hintStyle: TextStyle(color: Color(0xFF75777D)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Language
                  _FormField(
                    label: 'Preferred Language',
                    icon: Icons.translate,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _language,
                        isExpanded: true,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1B1C19),
                            fontFamily: 'Inter'),
                        items: _languages
                            .map((l) =>
                                DropdownMenuItem(value: l, child: Text(l)))
                            .toList(),
                        onChanged: (v) => setState(() => _language = v!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // State
                  _FormField(
                    label: 'State / Union Territory',
                    required: true,
                    icon: Icons.location_on_outlined,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _state,
                        isExpanded: true,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1B1C19),
                            fontFamily: 'Inter'),
                        items: _states
                            .map((s) =>
                                DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (v) => setState(() => _state = v!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Continue CTA
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: auth.isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4263EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: auth.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Continue',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).skipProfile(),
                child: const Text('Skip for now',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF45474C),
                        fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(height: 20),
          ].animate(interval: 60.ms).fadeIn(duration: 300.ms),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.icon,
    required this.child,
    this.required = false,
  });

  final String label;
  final IconData icon;
  final Widget child;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B1C19))),
            if (required)
              const Text(' *',
                  style: TextStyle(color: Color(0xFFBA1A1A), fontSize: 14)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F3EE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(icon, size: 20, color: const Color(0xFF45474C)),
              const SizedBox(width: 10),
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }
}
