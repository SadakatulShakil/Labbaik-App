import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../core/constants/app_assets.dart';
import '../../domain/entities/chapter_content.dart';
import '../../domain/entities/journey_content.dart';
import '../../domain/repositories/content_repository.dart';

/// Loads a journey's bundled JSON once per journey and caches the parsed
/// result in memory for the lifetime of the app.
class ContentRepositoryImpl implements ContentRepository {
  final Map<String, JourneyContent> _cache = {};

  @override
  Future<JourneyContent> getJourney(String journey) async {
    final cached = _cache[journey];
    if (cached != null) return cached;

    final raw = await rootBundle
        .loadString('${AppAssets.dataBasePath}/$journey.json');
    final parsed = JourneyContent.fromJson(
      json.decode(raw) as Map<String, dynamic>,
    );
    _cache[journey] = parsed;
    return parsed;
  }

  @override
  Future<List<ChapterContent>> getChapters(String journey) async {
    final content = await getJourney(journey);
    return content.chapters;
  }

  @override
  Future<ChapterContent?> getChapter(String journey, String chapterId) async {
    final chapters = await getChapters(journey);
    for (final chapter in chapters) {
      if (chapter.id == chapterId) return chapter;
    }
    return null;
  }
}
