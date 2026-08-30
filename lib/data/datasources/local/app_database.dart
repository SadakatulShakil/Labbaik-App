import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'checklist_dao.dart';
import 'checklist_state_entity.dart';
import 'progress_dao.dart';
import 'progress_entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [ProgressEntity, ChecklistStateEntity])
abstract class AppDatabase extends FloorDatabase {
  ProgressDao get progressDao;

  ChecklistDao get checklistDao;
}
