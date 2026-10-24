import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_widgets.dart';
import '../../shared/format.dart';
import '../auth/auth_controller.dart';
import '../chat/chat_controller.dart';
import '../research/research_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _sendQuestion([String? prompt]) {
    final text = (prompt ?? _controller.text).trim();
    if (text.isEmpty) return;
    ref.read(chatControllerProvider.notifier).send(text);
    _controller.clear();
    _focus.unfocus();
    context.go('/ask');
  }

  void _documentComingSoon() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.ivory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.cobaltTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.upload_file_outlined,
                      color: AppColors.cobalt),
                ),
                const SizedBox(width: 12),
                Text('Document Analysis',
                    style: Theme.of(ctx).textTheme.titleLarge),
                const Spacer(),
                const DemoBadge(label: 'ROADMAP'),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Document OCR and clause extraction are planned for the next release. '
              'In the meantime, you can create a case matter in My Cases and attach documents locally.',
              style: Theme.of(ctx)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.go('/cases');
                    },
                    child: const Text('Go to My Cases'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recent = ref.watch(researchHistoryProvider);
    final auth = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                // Header bar
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.balance,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text('AI Advocate', style: theme.textTheme.titleLarge),
                    const Spacer(),
                    if (!AppConfig.useBackend)
                      const DemoBadge(label: 'DEMO MODE'),
                    const SizedBox(width: 8),
                    // Profile avatar / menu
                    PopupMenuButton<String>(
                      tooltip: 'Account',
                      icon: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.cobaltTint,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Center(
                          child: Icon(
                            auth.isAuthenticated
                                ? Icons.person
                                : Icons.person_outline,
                            size: 20,
                            color: AppColors.cobalt,
                          ),
                        ),
                      ),
                      onSelected: (val) {
                        if (val == 'profile') {
                          context.push('/profile');
                        } else if (val == 'logout') {
                          ref.read(authProvider.notifier).logout();
                          context.go('/welcome');
                        } else if (val == 'login') {
                          context.push('/login');
                        }
                      },
                      itemBuilder: (ctx) => [
                        if (auth.isAuthenticated && !auth.isGuest) ...[
                          PopupMenuItem(
                            enabled: false,
                            child: Text(
                              auth.profile?.name.isNotEmpty == true
                                  ? auth.profile!.name
                                  : '+91 ${auth.phoneNumber ?? ''}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'profile',
                            child: Row(
                              children: [
                                Icon(Icons.badge_outlined, size: 18),
                                SizedBox(width: 8),
                                Text('View Profile'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout,
                                    size: 18, color: AppColors.danger),
                                SizedBox(width: 8),
                                Text('Log Out',
                                    style: TextStyle(color: AppColors.danger)),
                              ],
                            ),
                          ),
                        ] else ...[
                          const PopupMenuItem(
                            value: 'profile',
                            child: Row(
                              children: [
                                Icon(Icons.badge_outlined, size: 18),
                                SizedBox(width: 8),
                                Text('Guest Profile'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'login',
                            child: Row(
                              children: [
                                Icon(Icons.login,
                                    size: 18, color: AppColors.cobalt),
                                SizedBox(width: 8),
                                Text('Sign In with Phone',
                                    style: TextStyle(color: AppColors.cobalt)),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Welcome heading
                Text(
                  'How can I help you\nunderstand the law?',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Plain-language guidance on Indian statutes, legal rights, and procedure.',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),

                // Legal Question Composer
                Composer(
                  controller: _controller,
                  focusNode: _focus,
                  minLines: 3,
                  hint:
                      'e.g. My landlord is not returning my security deposit after moving out…',
                  onSend: () => _sendQuestion(),
                ),
                const SizedBox(height: 10),
                const DisclaimerNote(),
                const SizedBox(height: 24),

                // Quick actions
                Text('Quick actions', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _QuickAction(
                      icon: Icons.menu_book_outlined,
                      label: 'Explain a law',
                      description: 'Demystify consumer & civil laws',
                      onTap: () => _sendQuestion(
                        'Explain the key provisions and buyer protections under the Consumer Protection Act, 2019 in simple words.',
                      ),
                    ),
                    _QuickAction(
                      icon: Icons.manage_search,
                      label: 'Find relevant sections',
                      description: 'Search penal & cyber provisions',
                      onTap: () => _sendQuestion(
                        'Which sections of Bharatiya Nyaya Sanhita (BNS), 2023 apply to digital cheating and cyber fraud?',
                      ),
                    ),
                    _QuickAction(
                      icon: Icons.upload_file_outlined,
                      label: 'Analyze a document',
                      description: 'Roadmap & file attach',
                      onTap: _documentComingSoon,
                    ),
                    _QuickAction(
                      icon: Icons.assignment_outlined,
                      label: 'Prepare a case brief',
                      description: 'Structured lawyer briefing',
                      onTap: () => context.push('/brief'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Recent research section
                Row(
                  children: [
                    Text('Recent research', style: theme.textTheme.titleMedium),
                    const Spacer(),
                    if (recent.isNotEmpty)
                      TextButton(
                        onPressed: () => context.go('/saved'),
                        child: const Text('View saved'),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                if (recent.isEmpty)
                  AppCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: EmptyState(
                        icon: Icons.history_edu_outlined,
                        title: 'No research yet',
                        message:
                            'Questions you ask will appear here with retrieved legal sections so you can return to them anytime.',
                        action: OutlinedButton.icon(
                          onPressed: () => _sendQuestion(
                            'What are a tenant’s statutory rights if a landlord refuses to return the security deposit in India?',
                          ),
                          icon: const Icon(Icons.lightbulb_outline, size: 18),
                          label: const Text('Try a sample question'),
                        ),
                      ),
                    ),
                  )
                else
                  for (final item in recent.take(5))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppCard(
                        onTap: () => context.push('/research/${item.id}'),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.cobaltTint,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline,
                                size: 18,
                                color: AppColors.cobalt,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    relativeTime(item.createdAt),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (item.demo) const DemoBadge(),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
              ].animate(interval: 30.ms).fadeIn(duration: 220.ms),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.cobaltTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.cobalt, size: 18),
              ),
              const Icon(Icons.arrow_forward,
                  size: 14, color: AppColors.textSecondary),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
