import '../../domain/entities/chapter_content.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/local/progress_dao.dart';
import '../datasources/local/progress_entity.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl(this._dao);

  final ProgressDao _dao;

  @override
  Future<Set<String>> completedChapterIds(String journey) async {
    final rows = await _dao.getByJourney(journey);
    return rows.map((row) => row.chapterId).toSet();
  }

  @override
  Future<void> markCompleted(String journey, String chapterId) {
    return _dao.insert(
      ProgressEntity(
        journeyId: journey,
        chapterId: chapterId,
        completedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  @override
  Future<int> completedCount(String journey) async {
    final rows = await _dao.getByJourney(journey);
    return rows.length;
  }

  @override
  Future<bool> isUnlocked(
    String journey,
    ChapterContent chapter,
    List<ChapterContent> allChapters,
  ) async {
    if (chapter.order == 1) return true;

    ChapterContent? previous;
    for (final candidate in allChapters) {
      if (candidate.order == chapter.order - 1) {
        previous = candidate;
        break;
      }
    }
    if (previous == null) return false;

    final completed = await completedChapterIds(journey);
    return completed.contains(previous.id);
  }

  @override
  Future<void> resetJourney(String journey) {
    return _dao.deleteByJourney(journey);
  }
}
