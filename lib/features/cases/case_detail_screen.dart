import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_widgets.dart';
import '../../data/models/case_workspace.dart';
import '../../shared/format.dart';
import 'cases_controller.dart';

/// Interactive workspace for a legal case matter.
class CaseDetailScreen extends ConsumerStatefulWidget {
  const CaseDetailScreen({super.key, required this.caseId});

  final String caseId;

  @override
  ConsumerState<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends ConsumerState<CaseDetailScreen> {
  final List<String> _pickedNames = [];

  Future<void> _pick() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result == null) return;
      setState(() => _pickedNames.addAll(result.files.map((f) => f.name)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the file picker.')),
      );
    }
  }

  void _showEditSheet(BuildContext context, CaseWorkspace workspace) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.ivory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EditCaseSheet(workspace: workspace),
    );
  }

  void _confirmDelete(BuildContext context, CaseWorkspace workspace) {
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
              context.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CaseWorkspace? workspace;
    for (final c in ref.watch(casesProvider)) {
      if (c.id == widget.caseId) workspace = c;
    }
    final theme = Theme.of(context);

    if (workspace == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          icon: Icons.folder_off_outlined,
          title: 'Case not found',
          message: 'This workspace is no longer available.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Case workspace'),
        actions: [
          IconButton(
            tooltip: 'Edit details',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditSheet(context, workspace!),
          ),
          IconButton(
            tooltip: 'Delete case',
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
            onPressed: () => _confirmDelete(context, workspace!),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(workspace.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              'Updated ${relativeTime(workspace.updatedAt)}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            if (workspace.summary.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(workspace.summary, style: theme.textTheme.bodyLarge),
            ],
            const SizedBox(height: 20),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.attach_file,
                          color: AppColors.cobalt, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Documents & Evidence',
                            style: theme.textTheme.titleMedium),
                      ),
                      const DemoBadge(label: 'PREVIEW'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Attach notices, agreements, or receipts. Files remain on this device.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  if (_pickedNames.isEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.ivory,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.description_outlined,
                              size: 18, color: AppColors.textSecondary),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Sample_Notice_of_Demand.pdf (Mock file)',
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  for (final name in _pickedNames)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.insert_drive_file_outlined,
                              size: 18, color: AppColors.navy),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _pick,
                    icon: const Icon(Icons.add),
                    label: const Text('Add document'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.assignment_outlined,
                          color: AppColors.cobalt, size: 20),
                      const SizedBox(width: 8),
                      Text('Case brief & summary',
                          style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'View structured legal overview, relevant statutes, and questions to ask an advocate.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => context.push('/brief'),
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: const Text('Open case brief'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const DisclaimerNote(),
          ],
        ),
      ),
    );
  }
}

class _EditCaseSheet extends ConsumerStatefulWidget {
  const _EditCaseSheet({required this.workspace});

  final CaseWorkspace workspace;

  @override
  ConsumerState<_EditCaseSheet> createState() => _EditCaseSheetState();
}

class _EditCaseSheetState extends ConsumerState<_EditCaseSheet> {
  late final TextEditingController _title;
  late final TextEditingController _summary;
  String? _error;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.workspace.title);
    _summary = TextEditingController(text: widget.workspace.summary);
  }

  @override
  void dispose() {
    _title.dispose();
    _summary.dispose();
    super.dispose();
  }

  void _save() {
    if (_title.text.trim().isEmpty) {
      setState(() => _error = 'Please enter a case title.');
      return;
    }
    ref.read(casesProvider.notifier).edit(
          id: widget.workspace.id,
          title: _title.text,
          summary: _summary.text,
        );
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
            Text('Edit case details', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _title,
              maxLength: 100,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Title',
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
                labelText: 'Summary',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                child: const Text('Save changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
