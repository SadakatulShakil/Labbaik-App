import 'content_section.dart';
import 'dua_content.dart';
import 'story_content.dart';

/// A single chapter within a journey (Umrah/Hajj), e.g. "Ihram" or "Tawaf".
class ChapterContent {
  const ChapterContent({
    required this.id,
    required this.order,
    required this.phase,
    required this.titleBn,
    required this.titleEn,
    required this.icon,
    required this.sections,
    required this.duas,
    this.story,
  });

  factory ChapterContent.fromJson(Map<String, dynamic> json) {
    return ChapterContent(
      id: json['id'] as String,
      order: json['order'] as int,
      phase: json['phase'] as String,
      titleBn: json['titleBn'] as String,
      titleEn: json['titleEn'] as String,
      icon: json['icon'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => ContentSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      duas: (json['duas'] as List<dynamic>)
          .map((e) => DuaContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      story: json['story'] != null
          ? StoryContent.fromJson(json['story'] as Map<String, dynamic>)
          : null,
    );
  }

  final String id;
  final int order;
  final String phase;
  final String titleBn;
  final String titleEn;
  final String icon;
  final List<ContentSection> sections;
  final List<DuaContent> duas;
  final StoryContent? story;
}
