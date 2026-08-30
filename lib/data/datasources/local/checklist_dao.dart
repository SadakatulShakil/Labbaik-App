import 'package:floor/floor.dart';

import 'checklist_state_entity.dart';

@dao
abstract class ChecklistDao {
  @Query('SELECT * FROM checklist_state')
  Future<List<ChecklistStateEntity>> getAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsert(ChecklistStateEntity item);
}
