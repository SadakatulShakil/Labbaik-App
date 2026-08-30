import 'package:floor/floor.dart';

/// Tracks that a user has completed a given chapter of a journey.
@Entity(tableName: 'progress', primaryKeys: ['journeyId', 'chapterId'])
class ProgressEntity {
  const ProgressEntity({
    required this.journeyId,
    required this.chapterId,
    required this.completedAt,
  });

  final String journeyId;
  final String chapterId;
  final int completedAt;
}
