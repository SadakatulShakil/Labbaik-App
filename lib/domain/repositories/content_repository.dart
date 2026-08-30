import '../entities/chapter_content.dart';
import '../entities/journey_content.dart';

/// Read-only access to the bundled journey content (Umrah/Hajj).
abstract class ContentRepository {
  Future<JourneyContent> getJourney(String journey);

  Future<List<ChapterContent>> getChapters(String journey);

  Future<ChapterContent?> getChapter(String journey, String chapterId);
}
