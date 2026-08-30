import 'chapter_content.dart';

/// The full bundled content for one journey ('umrah' or 'hajj').
class JourneyContent {
  const JourneyContent({
    required this.journey,
    required this.titleBn,
    required this.titleEn,
    required this.chapters,
  });

  factory JourneyContent.fromJson(Map<String, dynamic> json) {
    return JourneyContent(
      journey: json['journey'] as String,
      titleBn: json['titleBn'] as String,
      titleEn: json['titleEn'] as String,
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => ChapterContent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String journey;
  final String titleBn;
  final String titleEn;
  final List<ChapterContent> chapters;
}
