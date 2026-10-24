class CaseWorkspace {
  const CaseWorkspace({
    required this.id,
    required this.title,
    required this.summary,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String summary;
  final DateTime updatedAt;

  CaseWorkspace copyWith({
    String? title,
    String? summary,
    DateTime? updatedAt,
  }) {
    return CaseWorkspace(
      id: id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
