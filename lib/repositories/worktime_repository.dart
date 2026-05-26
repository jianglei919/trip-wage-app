import 'package:drift/drift.dart';

import '../core/db/database.dart';

class WorkTimeRepository {
  WorkTimeRepository(this._db);
  final AppDatabase _db;

  Future<WorkTime?> getByDate(String date) {
    return (_db.select(_db.workTimes)..where((t) => t.date.equals(date)))
        .getSingleOrNull();
  }

  Stream<WorkTime?> watchByDate(String date) {
    return (_db.select(_db.workTimes)..where((t) => t.date.equals(date)))
        .watchSingleOrNull();
  }

  Stream<List<WorkTime>> watchByDateRange(String startDate, String endDate) {
    return (_db.select(_db.workTimes)
          ..where((t) => t.date.isBetweenValues(startDate, endDate)))
        .watch();
  }

  /// 每天一条，按 date upsert
  Future<void> upsert({
    required String date,
    required String startTime,
    required String endTime,
    required double workHours,
  }) {
    final data = WorkTimesCompanion.insert(
      date: date,
      startTime: Value(startTime),
      endTime: Value(endTime),
      workHours: Value(workHours),
      updatedAt: Value(DateTime.now()),
    );
    return _db.into(_db.workTimes).insert(
          data,
          onConflict: DoUpdate(
            (_) => data,
            target: [_db.workTimes.date],
          ),
        );
  }
}
