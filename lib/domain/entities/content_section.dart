/// One block of a chapter's body content. [type] is one of
/// 'intro' | 'steps' | 'tip'.
class ContentSection {
  const ContentSection({
    required this.type,
    required this.order,
    required this.bodyBn,
    required this.bodyEn,
  });

  factory ContentSection.fromJson(Map<String, dynamic> json) {
    return ContentSection(
      type: json['type'] as String,
      order: json['order'] as int,
      bodyBn: json['bodyBn'] as String,
      bodyEn: json['bodyEn'] as String,
    );
  }

  final String type;
  final int order;
  final String bodyBn;
  final String bodyEn;
}
