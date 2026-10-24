import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_widgets.dart';
import '../../data/models/chat_models.dart';
import '../research/widgets/answer_sections.dart';
import 'chat_controller.dart';

class MessageBubble extends ConsumerWidget {
  const MessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxWidth = MediaQuery.sizeOf(context).width * 0.88;
    final Widget bubble;

    if (message.role == ChatRole.user) {
      bubble = Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: SelectableText(
            message.text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
          ),
        ),
      );
    } else if (message.isError) {
      bubble = Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ErrorBanner(
            message: message.text,
            onRetry: () => ref.read(chatControllerProvider.notifier).retry(),
          ),
        ),
      );
    } else {
      bubble = Align(
        alignment: Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.all(14),
          decoration: cardDecoration(radius: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.demo) ...[
                const DemoBadge(label: 'DEMO RESPONSE'),
                const SizedBox(height: 8)
              ],
              AnswerMarkdown(message.text),
              if (message.sources.isNotEmpty) ...[
                const Divider(height: 24),
                Text('Sources',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: AppColors.textSecondary)),
                for (final s in message.sources) SourceTile(source: s),
              ],
              const Divider(height: 24),
              DisclaimerNote(text: message.disclaimer ?? AppConfig.disclaimer),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: bubble
          .animate()
          .fadeIn(duration: 200.ms)
          .slideY(begin: 0.04, end: 0, duration: 200.ms),
    );
  }
}
