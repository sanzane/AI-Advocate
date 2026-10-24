import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_widgets.dart';
import '../../data/models/research_item.dart';
import '../research/research_controller.dart';
import '../sources/source_detail_sheet.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});

  @override
  ConsumerState<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen> {
  String _query = '';

  String _titleOf(SavedItem s) => s.research?.title ?? s.source?.title ?? '';

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(savedProvider);
    final q = _query.trim().toLowerCase();
    final items = q.isEmpty
        ? all
        : all.where((s) => _titleOf(s).toLowerCase().contains(q)).toList();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: SafeArea(
        child: all.isEmpty
            ? const EmptyState(
                icon: Icons.bookmark_border,
                title: 'Nothing saved yet',
                message:
                    'Tap the bookmark on a research answer or a legal source to keep it here.',
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: 'Search saved items',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: items.isEmpty
                        ? const EmptyState(
                            icon: Icons.search_off,
                            title: 'No matches',
                            message: 'Try a different search term.',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final s = items[i];
                              final isResearch = s.kind == SavedKind.research;
                              return AppCard(
                                onTap: () {
                                  if (isResearch) {
                                    context.push('/research/${s.research!.id}');
                                  } else {
                                    showSourceDetail(context, s.source!);
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      isResearch
                                          ? Icons.chat_bubble_outline
                                          : Icons.gavel_outlined,
                                      color: AppColors.cobalt,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(_titleOf(s),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  theme.textTheme.titleSmall),
                                          Text(
                                            isResearch
                                                ? 'Research'
                                                : (s.source!.citationLine
                                                        .isEmpty
                                                    ? 'Source'
                                                    : s.source!.citationLine),
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                    color: AppColors
                                                        .textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Remove from saved',
                                      onPressed: () {
                                        ref
                                            .read(savedProvider.notifier)
                                            .remove(s.id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Removed from saved items'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.bookmark,
                                          color: AppColors.navy),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
