import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_controller.dart';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      final hasText = _phoneController.text.trim().isNotEmpty;
      if (hasText != _hasInput) {
        setState(() => _hasInput = hasText);
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    final raw = _phoneController.text.trim().replaceAll(RegExp(r'\D'), '');
    if (raw.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    ref.read(authProvider.notifier).requestOtp(raw);
    context.push('/otp', extra: raw);
  }

  @override
  Widget build(BuildContext context) {
    final isComplete =
        _phoneController.text.trim().replaceAll(RegExp(r'\D'), '').length == 10;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Top Bar: Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/welcome');
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F3EE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1B1C19),
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Header Block
                const Text(
                  'Welcome to AI Advocate',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF121C2E),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Enter your phone number to continue.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF45474C),
                  ),
                ),
                const SizedBox(height: 24),
                // Elevated Input Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0C000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1B1C19),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Input Bar
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F3EE),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isComplete
                                ? const Color(0xFF4263EB)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Country Selector Pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0A000000),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const Row(
                                children: [
                                  Text('🇮🇳', style: TextStyle(fontSize: 16)),
                                  SizedBox(width: 6),
                                  Text(
                                    '+91',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1B1C19),
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Icon(Icons.expand_more,
                                      size: 16, color: Color(0xFF515F78)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Number Field
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                focusNode: _focusNode,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                onSubmitted: (_) => _onSendOtp(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1B1C19),
                                  letterSpacing: 0.8,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '98765 43210',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF8E9096),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                            if (_hasInput)
                              IconButton(
                                icon: const Icon(Icons.cancel,
                                    size: 18, color: Color(0xFF515F78)),
                                onPressed: () {
                                  _phoneController.clear();
                                  _focusNode.requestFocus();
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Send OTP Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4263EB),
                            foregroundColor: Colors.white,
                            elevation: isComplete ? 2 : 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _onSendOtp,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Send OTP',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Footnote
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "We'll send a 6-digit verification code. Standard rates may apply.\nYour number is kept private and secure.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF515F78),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
