import '../../core/config/app_config.dart';
import 'source_ref.dart';

/// One question + answer, kept in memory for the "Recent research" list.
class ResearchItem {
  const ResearchItem({
    required this.id,
    required this.title,
    required this.answer,
    required this.createdAt,
    this.sources = const [],
    this.demo = false,
    this.disclaimer = AppConfig.disclaimer,
  });

  final String id;
  final String title;
  final String answer;
  final DateTime createdAt;
  final List<SourceRef> sources;
  final bool demo;
  final String disclaimer;
}

enum SavedKind { research, source }

/// Something the user bookmarked: either a research answer or a source.
class SavedItem {
  SavedItem.research(ResearchItem item)
      : id = 'r:${item.id}',
        kind = SavedKind.research,
        research = item,
        source = null;

  SavedItem.source(SourceRef ref)
      : id = 's:${ref.id}',
        kind = SavedKind.source,
        research = null,
        source = ref;

  final String id;
  final SavedKind kind;
  final ResearchItem? research;
  final SourceRef? source;
}
