import '../../domain/repositories/checklist_repository.dart';
import '../datasources/local/checklist_dao.dart';
import '../datasources/local/checklist_state_entity.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  ChecklistRepositoryImpl(this._dao);

  final ChecklistDao _dao;

  @override
  Future<bool> isChecked(String itemId) async {
    final items = await _dao.getAll();
    for (final item in items) {
      if (item.itemId == itemId) return item.checked == 1;
    }
    return false;
  }

  @override
  Future<void> setChecked(String itemId, bool value) {
    return _dao.upsert(
      ChecklistStateEntity(itemId: itemId, checked: value ? 1 : 0),
    );
  }
}
