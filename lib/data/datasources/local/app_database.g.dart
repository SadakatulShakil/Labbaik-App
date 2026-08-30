// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ProgressDao? _progressDaoInstance;

  ChecklistDao? _checklistDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `progress` (`journeyId` TEXT NOT NULL, `chapterId` TEXT NOT NULL, `completedAt` INTEGER NOT NULL, PRIMARY KEY (`journeyId`, `chapterId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `checklist_state` (`itemId` TEXT NOT NULL, `checked` INTEGER NOT NULL, PRIMARY KEY (`itemId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ProgressDao get progressDao {
    return _progressDaoInstance ??= _$ProgressDao(database, changeListener);
  }

  @override
  ChecklistDao get checklistDao {
    return _checklistDaoInstance ??= _$ChecklistDao(database, changeListener);
  }
}

class _$ProgressDao extends ProgressDao {
  _$ProgressDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _progressEntityInsertionAdapter = InsertionAdapter(
            database,
            'progress',
            (ProgressEntity item) => <String, Object?>{
                  'journeyId': item.journeyId,
                  'chapterId': item.chapterId,
                  'completedAt': item.completedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProgressEntity> _progressEntityInsertionAdapter;

  @override
  Future<List<ProgressEntity>> getByJourney(String journeyId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM progress WHERE journeyId = ?1',
        mapper: (Map<String, Object?> row) => ProgressEntity(
            journeyId: row['journeyId'] as String,
            chapterId: row['chapterId'] as String,
            completedAt: row['completedAt'] as int),
        arguments: [journeyId]);
  }

  @override
  Future<void> deleteByJourney(String journeyId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM progress WHERE journeyId = ?1',
        arguments: [journeyId]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM progress');
  }

  @override
  Future<void> insert(ProgressEntity progress) async {
    await _progressEntityInsertionAdapter.insert(
        progress, OnConflictStrategy.replace);
  }
}

class _$ChecklistDao extends ChecklistDao {
  _$ChecklistDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _checklistStateEntityInsertionAdapter = InsertionAdapter(
            database,
            'checklist_state',
            (ChecklistStateEntity item) => <String, Object?>{
                  'itemId': item.itemId,
                  'checked': item.checked
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ChecklistStateEntity>
      _checklistStateEntityInsertionAdapter;

  @override
  Future<List<ChecklistStateEntity>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM checklist_state',
        mapper: (Map<String, Object?> row) => ChecklistStateEntity(
            itemId: row['itemId'] as String, checked: row['checked'] as int));
  }

  @override
  Future<void> upsert(ChecklistStateEntity item) async {
    await _checklistStateEntityInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }
}
