import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/research_item.dart';
import '../../data/models/source_ref.dart';

/// Recent research, newest first.
class ResearchHistoryController extends Notifier<List<ResearchItem>> {
  static const _maxItems = 30;

  @override
  List<ResearchItem> build() {
    return [
      ResearchItem(
        id: 'sample-res-1',
        title: 'Tenant statutory remedies for security deposit return',
        answer:
            'Under Section 108 of the Transfer of Property Act, 1882, the lessee is entitled to quiet possession and return of security deposits upon surrender of the premises, subject only to legitimate deductions for actual physical damage beyond normal wear and tear.',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        sources: const [
          SourceRef(
            id: 'sample-tpa-108',
            title: 'Transfer of Property Act, 1882 - Section 108',
            act: 'Transfer of Property Act, 1882',
            section: 'Section 108',
            excerpt:
                'Rights and liabilities of lessor and lessee in the absence of a contract to the contrary.',
            isSample: true,
          ),
        ],
        demo: true,
      ),
    ];
  }

  void add(ResearchItem item) {
    state =
        [item, ...state.where((r) => r.id != item.id)].take(_maxItems).toList();
  }
}

final researchHistoryProvider =
    NotifierProvider<ResearchHistoryController, List<ResearchItem>>(
        ResearchHistoryController.new);

/// Bookmarked research answers and legal sources.
class SavedController extends Notifier<List<SavedItem>> {
  @override
  List<SavedItem> build() {
    final sample = ResearchItem(
      id: 'sample-res-1',
      title: 'Tenant statutory remedies for security deposit return',
      answer:
          'Under Section 108 of the Transfer of Property Act, 1882, the lessee is entitled to return of security deposits upon vacant handover, subject only to agreed deductions for physical damage.',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      sources: const [
        SourceRef(
          id: 'sample-tpa-108',
          title: 'Transfer of Property Act, 1882 - Section 108',
          act: 'Transfer of Property Act, 1882',
          section: 'Section 108',
          excerpt: 'Rights and liabilities of lessor and lessee in India.',
          isSample: true,
        ),
      ],
      demo: true,
    );

    return [
      SavedItem.research(sample),
      SavedItem.source(
        const SourceRef(
          id: 'sample-cpa-sec2',
          title: 'Consumer Protection Act, 2019 - Section 2(7)',
          act: 'Consumer Protection Act, 2019',
          section: 'Section 2(7)',
          excerpt:
              'Statutory definition of consumer and remedies against deficiency of services.',
          isSample: true,
        ),
      ),
    ];
  }

  bool isSaved(String id) => state.any((s) => s.id == id);

  void toggleResearch(ResearchItem item) => _toggle(SavedItem.research(item));

  void toggleSource(SourceRef ref) => _toggle(SavedItem.source(ref));

  void remove(String id) => state = state.where((s) => s.id != id).toList();

  void _toggle(SavedItem item) {
    state = isSaved(item.id)
        ? state.where((s) => s.id != item.id).toList()
        : [item, ...state];
  }
}

final savedProvider =
    NotifierProvider<SavedController, List<SavedItem>>(SavedController.new);
