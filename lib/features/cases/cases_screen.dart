import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_widgets.dart';
import '../../data/models/case_workspace.dart';
import '../../shared/format.dart';
import 'cases_controller.dart';

class CasesScreen extends ConsumerWidget {
  const CasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cases = ref.watch(casesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cases'),
        actions: [
          IconButton(
            tooltip: 'New case',
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateSheet(context, ref),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateSheet(context, ref),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New case'),
      ),
      body: SafeArea(
        child: cases.isEmpty
            ? EmptyState(
                icon: Icons.folder_open_outlined,
                title: 'No case workspaces yet',
                message:
                    'A workspace keeps your facts, documents and research for one matter in one place.',
                action: FilledButton.icon(
                  onPressed: () => _showCreateSheet(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Create a case'),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                itemCount: cases.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final c = cases[i];
                  return AppCard(
                    onTap: () => context.push('/case/${c.id}'),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.cobaltTint,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.folder_outlined,
                            color: AppColors.cobalt,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.title, style: theme.textTheme.titleMedium),
                              if (c.summary.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  c.summary,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                'Updated ${relativeTime(c.updatedAt)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          tooltip: 'Options',
                          icon: const Icon(
                            Icons.more_vert,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onSelected: (val) {
                            if (val == 'open') {
                              context.push('/case/${c.id}');
                            } else if (val == 'delete') {
                              _confirmDelete(context, ref, c);
                            }
                          },
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(
                              value: 'open',
                              child: Row(
                                children: [
                                  Icon(Icons.visibility_outlined, size: 18),
                                  SizedBox(width: 8),
                                  Text('Open'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline,
                                      size: 18, color: AppColors.danger),
                                  SizedBox(width: 8),
                                  Text('Delete',
                                      style:
                                          TextStyle(color: AppColors.danger)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, CaseWorkspace workspace) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete case workspace?'),
        content: Text(
          'Are you sure you want to delete "${workspace.title}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(casesProvider.notifier).delete(workspace.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateSheet(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.ivory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _CreateCaseSheet(),
    );
  }
}

class _CreateCaseSheet extends ConsumerStatefulWidget {
  const _CreateCaseSheet();

  @override
  ConsumerState<_CreateCaseSheet> createState() => _CreateCaseSheetState();
}

class _CreateCaseSheetState extends ConsumerState<_CreateCaseSheet> {
  final _title = TextEditingController();
  final _summary = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _summary.dispose();
    super.dispose();
  }

  void _create() {
    if (_title.text.trim().isEmpty) {
      setState(() => _error = 'Give the case a short title.');
      return;
    }
    ref
        .read(casesProvider.notifier)
        .create(title: _title.text, summary: _summary.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New case workspace', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _title,
              autofocus: true,
              maxLength: 100,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Case Title',
                hintText: 'e.g. Consumer Dispute with Online Retailer',
                errorText: _error,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _summary,
              maxLength: 400,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Short summary & background facts',
                hintText: 'Briefly note dates, parties involved, and key facts',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _create,
                child: const Text('Create case'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
