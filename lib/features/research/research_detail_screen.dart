import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_widgets.dart';
import '../../data/models/research_item.dart';
import 'research_controller.dart';
import 'widgets/answer_sections.dart';

class ResearchDetailScreen extends ConsumerWidget {
  const ResearchDetailScreen({super.key, required this.itemId});

  final String itemId;

  ResearchItem? _find(WidgetRef ref) {
    for (final r in ref.watch(researchHistoryProvider)) {
      if (r.id == itemId) return r;
    }
    for (final s in ref.watch(savedProvider)) {
      if (s.research?.id == itemId) return s.research;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = _find(ref);
    if (item == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          icon: Icons.search_off,
          title: 'Research not found',
          message: 'This item is no longer available.',
        ),
      );
    }
    final saved = ref.watch(savedProvider).any((s) => s.id == 'r:${item.id}');
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Research'),
        actions: [
          IconButton(
            tooltip: saved ? 'Remove from saved' : 'Save',
            onPressed: () =>
                ref.read(savedProvider.notifier).toggleResearch(item),
            icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (item.demo) ...[
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: DemoBadge(label: 'DEMO RESPONSE')),
                  const SizedBox(height: 8),
                ],
                Text(item.title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 14),
                AnswerSection(
                  title: 'Answer',
                  icon: Icons.chat_bubble_outline,
                  child: AnswerMarkdown(item.answer),
                ),
                const SizedBox(height: 12),
                SupportingSources(item.sources),
                const SizedBox(height: 16),
                DisclaimerNote(text: item.disclaimer),
                const SizedBox(height: 8),
                Text(
                  'Uncertainty is expected: verify any provision with its official source and a qualified advocate.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
