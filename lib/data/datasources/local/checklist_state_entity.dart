import 'package:floor/floor.dart';

/// Checked/unchecked state of a single packing/preparation checklist item.
@Entity(tableName: 'checklist_state')
class ChecklistStateEntity {
  const ChecklistStateEntity({
    required this.itemId,
    required this.checked,
  });

  @primaryKey
  final String itemId;
  final int checked;
}
