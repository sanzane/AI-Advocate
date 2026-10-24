import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../data/models/source_ref.dart';
import '../../sources/source_detail_sheet.dart';

/// Reusable building blocks for research answers and case briefs.

class AnswerSection extends StatelessWidget {
  const AnswerSection(
      {super.key,
      required this.title,
      required this.icon,
      required this.child});

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.cobalt),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class BulletList extends StatelessWidget {
  const BulletList(this.items, {super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 7, right: 10),
                  child: Icon(Icons.circle, size: 6, color: AppColors.cobalt),
                ),
                Expanded(child: Text(item, style: style)),
              ],
            ),
          ),
      ],
    );
  }
}

/// Markdown body styled for answers. Links are intentionally not tappable.
class AnswerMarkdown extends StatelessWidget {
  const AnswerMarkdown(this.data, {super.key, this.color});

  final String data;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodyMedium?.copyWith(color: color);
    return MarkdownBody(
      data: data,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
        p: base,
        h3: theme.textTheme.titleMedium?.copyWith(color: color),
        listBullet: base,
        blockquote: base?.copyWith(color: AppColors.textSecondary),
        blockquoteDecoration: const BoxDecoration(
          border: Border(left: BorderSide(color: AppColors.border, width: 3)),
        ),
      ),
    );
  }
}

class SituationSummary extends StatelessWidget {
  const SituationSummary(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => AnswerSection(
        title: 'Situation summary',
        icon: Icons.description_outlined,
        child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      );
}

class RelevantProvisions extends StatelessWidget {
  const RelevantProvisions(this.sources, {super.key});

  final List<SourceRef> sources;

  @override
  Widget build(BuildContext context) => AnswerSection(
        title: 'Potentially relevant provisions',
        icon: Icons.gavel_outlined,
        child: sources.isEmpty
            ? const Text('No provisions identified yet.')
            : Column(
                children: [for (final s in sources) SourceTile(source: s)]),
      );
}

class PlainLanguageExplanation extends StatelessWidget {
  const PlainLanguageExplanation(this.markdown, {super.key});

  final String markdown;

  @override
  Widget build(BuildContext context) => AnswerSection(
        title: 'In plain language',
        icon: Icons.chat_bubble_outline,
        child: AnswerMarkdown(markdown),
      );
}

class LawApplication extends StatelessWidget {
  const LawApplication(this.markdown, {super.key});

  final String markdown;

  @override
  Widget build(BuildContext context) => AnswerSection(
        title: 'How the law might apply',
        icon: Icons.balance_outlined,
        child: AnswerMarkdown(markdown),
      );
}

class ExceptionsAndMissingInfo extends StatelessWidget {
  const ExceptionsAndMissingInfo(this.items,
      {super.key, this.title = 'Exceptions and missing information'});

  final List<String> items;
  final String title;

  @override
  Widget build(BuildContext context) => AnswerSection(
        title: title,
        icon: Icons.help_outline,
        child: BulletList(items),
      );
}

class NextSteps extends StatelessWidget {
  const NextSteps(this.items, {super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) => AnswerSection(
        title: 'Possible next steps',
        icon: Icons.checklist_outlined,
        child: BulletList(items),
      );
}

class SupportingSources extends StatelessWidget {
  const SupportingSources(this.sources, {super.key});

  final List<SourceRef> sources;

  @override
  Widget build(BuildContext context) => AnswerSection(
        title: 'Supporting sources',
        icon: Icons.menu_book_outlined,
        child: sources.isEmpty
            ? Text(
                'No sources were supplied for this answer.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              )
            : Column(
                children: [for (final s in sources) SourceTile(source: s)]),
      );
}

class AdvocateQuestions extends StatelessWidget {
  const AdvocateQuestions(this.items, {super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) => AnswerSection(
        title: 'Questions to discuss with an advocate',
        icon: Icons.record_voice_over_outlined,
        child: BulletList(items),
      );
}

/// Compact tappable source row; opens the detail sheet.
class SourceTile extends StatelessWidget {
  const SourceTile({super.key, required this.source});

  final SourceRef source;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => showSourceDetail(context, source),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.article_outlined,
                size: 20, color: AppColors.navySoft),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(source.title, style: theme.textTheme.titleSmall),
                  if (source.citationLine.isNotEmpty)
                    Text(
                      source.citationLine,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                ],
              ),
            ),
            if (source.isSample) const DemoBadge(label: 'SAMPLE'),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
