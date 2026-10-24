/// A legal source exactly as supplied by the backend. The UI only displays
/// metadata present here and never invents citations or URLs.
class SourceRef {
  const SourceRef({
    required this.id,
    required this.title,
    this.act,
    this.section,
    this.excerpt,
    this.date,
    this.officialUrl,
    this.isSample = false,
  });

  final String id;
  final String title;
  final String? act;
  final String? section;
  final String? excerpt;
  final String? date;

  /// Verified official URL supplied by the backend, if any.
  final String? officialUrl;

  /// True when this entry is placeholder data, not a real citation.
  final bool isSample;

  /// Only https links on non-sample sources may be opened.
  Uri? get safeOfficialUri {
    if (isSample || officialUrl == null) return null;
    final uri = Uri.tryParse(officialUrl!);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) return null;
    return uri;
  }

  String get citationLine =>
      [act, section].whereType<String>().where((s) => s.isNotEmpty).join(' · ');

  factory SourceRef.fromJson(Map<String, dynamic> json) {
    return SourceRef(
      id: (json['id'] ?? json['title'] ?? '').toString(),
      title: (json['title'] ?? 'Untitled source').toString(),
      act: json['act'] as String?,
      section: json['section'] as String?,
      excerpt: json['excerpt'] as String?,
      date: json['date'] as String?,
      officialUrl: json['official_url'] as String?,
      isSample: json['is_sample'] == true,
    );
  }
}
