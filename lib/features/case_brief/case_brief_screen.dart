import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_widgets.dart';
import '../../data/models/case_brief.dart';
import '../research/widgets/answer_sections.dart';

class CaseBriefScreen extends StatelessWidget {
  const CaseBriefScreen({super.key, this.brief = CaseBrief.demo});

  final CaseBrief brief;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const gap = SizedBox(height: 12);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Case brief'),
        actions: [
          IconButton(
            tooltip: 'Share (coming soon)',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Export and sharing are not implemented yet.')),
            ),
            icon: const Icon(Icons.ios_share),
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
                if (brief.isDemo)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.noticeTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Demo content only. This brief shows the layout; it is not based on your facts or on verified law.',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.noticeText),
                    ),
                  ),
                gap,
                SituationSummary(brief.situation),
                gap,
                AnswerSection(
                  title: 'Important facts and dates',
                  icon: Icons.event_note_outlined,
                  child: BulletList(brief.facts),
                ),
                gap,
                RelevantProvisions(brief.sources),
                gap,
                ExceptionsAndMissingInfo(brief.missingFacts,
                    title: 'Missing facts'),
                gap,
                NextSteps(brief.nextSteps),
                gap,
                AdvocateQuestions(brief.advocateQuestions),
                const SizedBox(height: 16),
                const DisclaimerNote(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
