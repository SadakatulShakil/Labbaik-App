import 'package:floor/floor.dart';

import 'progress_entity.dart';

@dao
abstract class ProgressDao {
  @Query('SELECT * FROM progress WHERE journeyId = :journeyId')
  Future<List<ProgressEntity>> getByJourney(String journeyId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(ProgressEntity progress);

  @Query('DELETE FROM progress WHERE journeyId = :journeyId')
  Future<void> deleteByJourney(String journeyId);

  @Query('DELETE FROM progress')
  Future<void> deleteAll();
}
