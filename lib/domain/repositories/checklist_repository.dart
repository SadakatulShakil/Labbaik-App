/// Tracks the checked/unchecked state of preparation checklist items.
abstract class ChecklistRepository {
  Future<bool> isChecked(String itemId);

  Future<void> setChecked(String itemId, bool value);
}
