import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_widgets.dart';
import '../../data/models/source_ref.dart';
import '../research/research_controller.dart';

Future<void> showSourceDetail(BuildContext context, SourceRef source) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.ivory,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SourceDetailSheet(source: source),
  );
}

/// Shows only metadata supplied with the source; nothing is inferred.
class SourceDetailSheet extends ConsumerWidget {
  const SourceDetailSheet({super.key, required this.source});

  final SourceRef source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final saved = ref.watch(savedProvider).any((s) => s.id == 's:${source.id}');
    final uri = source.safeOfficialUri;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, 20 + MediaQuery.viewPaddingOf(context).bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (source.isSample) const DemoBadge(label: 'SAMPLE DATA'),
              const Spacer(),
              IconButton(
                tooltip: saved ? 'Remove from saved' : 'Save source',
                onPressed: () =>
                    ref.read(savedProvider.notifier).toggleSource(source),
                icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
              ),
            ],
          ),
          Text(source.title, style: theme.textTheme.headlineSmall),
          if (source.citationLine.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              source.citationLine,
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: AppColors.cobalt),
            ),
          ],
          if (source.date != null) ...[
            const SizedBox(height: 4),
            Text('Date: ${source.date}',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textSecondary)),
          ],
          const SizedBox(height: 16),
          if (source.excerpt != null && source.excerpt!.isNotEmpty)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Excerpt',
                      style: theme.textTheme.labelLarge
                          ?.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  SelectableText(source.excerpt!,
                      style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          const SizedBox(height: 16),
          if (source.isSample)
            Text(
              'This is placeholder data for demonstration. It is not a real citation and has no official link.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.noticeText),
            )
          else if (uri != null)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _open(context, uri),
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text('Open official source'),
              ),
            )
          else
            Text(
              'No verified official link was provided for this source.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          const SizedBox(height: 16),
          const DisclaimerNote(),
        ],
      ),
    );
  }

  Future<void> _open(BuildContext context, Uri uri) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) throw Exception('launch failed');
    } catch (_) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Could not open the link.')));
    }
  }
}
