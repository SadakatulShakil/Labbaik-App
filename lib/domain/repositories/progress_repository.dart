import '../entities/chapter_content.dart';

/// Tracks which chapters of a journey the user has completed.
abstract class ProgressRepository {
  Future<Set<String>> completedChapterIds(String journey);

  Future<void> markCompleted(String journey, String chapterId);

  Future<int> completedCount(String journey);

  /// A chapter is unlocked if it's the first one, or the chapter before it
  /// (by [ChapterContent.order]) has been completed.
  Future<bool> isUnlocked(
    String journey,
    ChapterContent chapter,
    List<ChapterContent> allChapters,
  );

  Future<void> resetJourney(String journey);
}
