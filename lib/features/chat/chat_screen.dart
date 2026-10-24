import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_widgets.dart';
import 'chat_controller.dart';
import 'message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send([String? overrideText]) {
    final text = (overrideText ?? _controller.text).trim();
    if (text.isEmpty) return;
    ref.read(chatControllerProvider.notifier).send(text);
    _controller.clear();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatControllerProvider);
    final theme = Theme.of(context);

    ref.listen(chatControllerProvider, (prev, next) {
      if (prev?.messages.length != next.messages.length ||
          prev?.isLoading != next.isLoading) {
        _scrollToEnd();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask AI'),
        actions: [
          if (!AppConfig.useBackend)
            const Padding(
              padding: EdgeInsets.only(right: 6),
              child: DemoBadge(label: 'DEMO MODE'),
            ),
          if (chat.messages.isNotEmpty)
            IconButton(
              tooltip: 'New conversation',
              onPressed: () =>
                  ref.read(chatControllerProvider.notifier).reset(),
              icon: const Icon(Icons.add_comment_outlined),
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: chat.messages.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                color: AppColors.cobaltTint,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.question_answer_outlined,
                                color: AppColors.cobalt,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text('Ask a legal question',
                                style: theme.textTheme.titleLarge,
                                textAlign: TextAlign.center),
                            const SizedBox(height: 6),
                            Text(
                              'Describe your legal situation or ask about Indian statutes and rights.',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            // Quick suggestion chips
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                ActionChip(
                                  label: const Text('Security deposit refund'),
                                  avatar:
                                      const Icon(Icons.home_outlined, size: 16),
                                  onPressed: () => _send(
                                    'What are a tenant’s legal rights if a landlord refuses to return the security deposit in India?',
                                  ),
                                ),
                                ActionChip(
                                  label:
                                      const Text('Consumer warranty refusal'),
                                  avatar: const Icon(Icons.storefront_outlined,
                                      size: 16),
                                  onPressed: () => _send(
                                    'How to file a consumer grievance for refusal of warranty under Consumer Protection Act 2019?',
                                  ),
                                ),
                                ActionChip(
                                  label: const Text('Cyber fraud & BNS 318'),
                                  avatar: const Icon(Icons.security_outlined,
                                      size: 16),
                                  onPressed: () => _send(
                                    'Which sections of Bharatiya Nyaya Sanhita (BNS) cover online banking fraud?',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount:
                          chat.messages.length + (chat.isLoading ? 1 : 0),
                      itemBuilder: (context, i) {
                        if (i == chat.messages.length) {
                          return const _WaitingIndicator();
                        }
                        return MessageBubble(message: chat.messages[i]);
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Column(
                children: [
                  Composer(
                    controller: _controller,
                    onSend: () => _send(),
                    enabled: !chat.isLoading,
                    hint: chat.messages.isEmpty
                        ? 'Describe your legal question…'
                        : 'Ask a follow-up…',
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'General legal information only. Not a substitute for professional legal advice.',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary, fontSize: 11),
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

/// Shown only while a real request is in flight.
class _WaitingIndicator extends StatelessWidget {
  const _WaitingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 10),
          Text(
            'Analyzing legal sources…',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
