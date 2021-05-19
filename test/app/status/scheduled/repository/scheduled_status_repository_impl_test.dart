import 'package:fedi/app/database/app_database.dart';
import 'package:fedi/app/status/scheduled/repository/scheduled_status_repository_impl.dart';
import 'package:fedi/app/status/scheduled/repository/scheduled_status_repository_model.dart';
import 'package:fedi/app/status/scheduled/scheduled_status_model.dart';
import 'package:fedi/app/status/scheduled/scheduled_status_model_adapter.dart';
import 'package:fedi/repository/repository_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor/ffi.dart';

import '../database/scheduled_status_database_test_helper.dart';
import '../scheduled_status_test_helper.dart';
import 'scheduled_status_repository_test_helper.dart';

// ignore_for_file: no-magic-number, avoid-late-keyword
void main() {
  late AppDatabase database;
  late ScheduledStatusRepository scheduledStatusRepository;

  DbScheduledStatus? dbScheduledStatus;

  setUp(() async {
    database = AppDatabase(VmDatabase.memory());

    scheduledStatusRepository =
        ScheduledStatusRepository(appDatabase: database);

    dbScheduledStatus =
        await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
      seed: 'seed4',
    );
  });

  tearDown(() async {
    await scheduledStatusRepository.dispose();
    await database.close();
  });

  test('insert & find by id', () async {
    var id = await scheduledStatusRepository.insertInDbType(
      dbScheduledStatus!,
      mode: null,
    );
    assert(id > 0, true);
    ScheduledStatusDatabaseTestHelper.expectDbScheduledStatus(
      await scheduledStatusRepository.findByDbIdInAppType(id),
      dbScheduledStatus,
    );
  });

  test('upsertAll', () async {
    var dbScheduledStatus1 =
        (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
      seed: 'seed5',
    ))
            .copyWith(remoteId: 'remoteId1');
    // same remote id
    var dbScheduledStatus2 =
        (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
      seed: 'seed6',
    ))
            .copyWith(remoteId: 'remoteId1');

    await scheduledStatusRepository.upsertAllInDbType(
      [dbScheduledStatus1],
      batchTransaction: null,
    );

    expect((await scheduledStatusRepository.getAllInAppType()).length, 1);

    await scheduledStatusRepository.upsertAllInDbType(
      [dbScheduledStatus2],
      batchTransaction: null,
    );
    expect((await scheduledStatusRepository.getAllInAppType()).length, 1);

    ScheduledStatusDatabaseTestHelper.expectDbScheduledStatus(
      (await scheduledStatusRepository.getAllInAppType()).first,
      dbScheduledStatus2,
    );
  });

  test('updateById', () async {
    var id = await scheduledStatusRepository.insertInDbType(
      dbScheduledStatus!,
      mode: null,
    );
    assert(id > 0, true);

    await scheduledStatusRepository.updateByDbIdInDbType(
      dbId: id,
      dbItem: dbScheduledStatus!.copyWith(remoteId: 'newRemoteId'),
      batchTransaction: null,
    );

    expect(
      (await scheduledStatusRepository.findByDbIdInDbType(id))?.remoteId,
      'newRemoteId',
    );
  });

  test('updateLocalScheduledStatusByRemoteScheduledStatus', () async {
    var id = await scheduledStatusRepository.insertInDbType(
      dbScheduledStatus!.copyWith(remoteId: 'oldRemoteId'),
      mode: null,
    );
    assert(id > 0, true);

    var oldLocalScheduledStatus = DbScheduledStatusPopulatedWrapper(
      dbScheduledStatusPopulated: DbScheduledStatusPopulated(
        dbScheduledStatus: dbScheduledStatus!.copyWith(id: id),
      ),
    );

    var newRemoteId = 'newRemoteId';
    var newRemoteScheduledStatus = DbScheduledStatusPopulatedWrapper(
      dbScheduledStatusPopulated: DbScheduledStatusPopulated(
        dbScheduledStatus: dbScheduledStatus!.copyWith(
          id: id,
          remoteId: newRemoteId,
        ),
      ),
    ).toPleromaScheduledStatus();
    await scheduledStatusRepository.updateAppTypeByRemoteType(
      appItem: oldLocalScheduledStatus,
      remoteItem: newRemoteScheduledStatus,
      batchTransaction: null,
    );

    expect(
      (await scheduledStatusRepository.findByDbIdInDbType(id))?.remoteId,
      newRemoteId,
    );
  });

  test('findByRemoteId', () async {
    await scheduledStatusRepository.insertInDbType(
      dbScheduledStatus!,
      mode: null,
    );
    ScheduledStatusDatabaseTestHelper.expectDbScheduledStatus(
      await scheduledStatusRepository
          .findByRemoteIdInAppType(dbScheduledStatus!.remoteId),
      dbScheduledStatus,
    );
  });
  test('markAsCanceled', () async {
    var id = await scheduledStatusRepository.insertInDbType(
      dbScheduledStatus!,
      mode: null,
    );
    dbScheduledStatus = dbScheduledStatus!.copyWith(id: id);
    expect(
      (await scheduledStatusRepository
              .findByRemoteIdInAppType(dbScheduledStatus!.remoteId))!
          .canceled,
      false,
    );
    await scheduledStatusRepository.markAsCanceled(
      scheduledStatus: DbScheduledStatusPopulatedWrapper(
        dbScheduledStatusPopulated: DbScheduledStatusPopulated(
          dbScheduledStatus: dbScheduledStatus!,
        ),
      ),
      batchTransaction: null,
    );

    expect(
      (await scheduledStatusRepository
              .findByRemoteIdInAppType(dbScheduledStatus!.remoteId))!
          .canceled,
      true,
    );
  });

  test('upsertRemoteScheduledStatus', () async {
    expect(await scheduledStatusRepository.countAll(), 0);

    await scheduledStatusRepository.upsertInRemoteType(
      DbScheduledStatusPopulatedWrapper(
        dbScheduledStatusPopulated: DbScheduledStatusPopulated(
          dbScheduledStatus: dbScheduledStatus!,
        ),
      ).toPleromaScheduledStatus(),
    );

    expect(await scheduledStatusRepository.countAll(), 1);
    ScheduledStatusDatabaseTestHelper.expectDbScheduledStatus(
      await scheduledStatusRepository
          .findByRemoteIdInAppType(dbScheduledStatus!.remoteId),
      dbScheduledStatus,
    );
    // item with same id updated

    await scheduledStatusRepository.upsertInRemoteType(
      DbScheduledStatusPopulatedWrapper(
        dbScheduledStatusPopulated: DbScheduledStatusPopulated(
          dbScheduledStatus: dbScheduledStatus!,
        ),
      ).toPleromaScheduledStatus(),
    );
    expect(await scheduledStatusRepository.countAll(), 1);

    ScheduledStatusDatabaseTestHelper.expectDbScheduledStatus(
      await scheduledStatusRepository
          .findByRemoteIdInAppType(dbScheduledStatus!.remoteId),
      dbScheduledStatus,
    );
  });

  test('upsertRemoteScheduledStatuses', () async {
    expect(await scheduledStatusRepository.countAll(), 0);
    await scheduledStatusRepository.upsertInRemoteType(
      DbScheduledStatusPopulatedWrapper(
        dbScheduledStatusPopulated: DbScheduledStatusPopulated(
          dbScheduledStatus: dbScheduledStatus!,
        ),
      ).toPleromaScheduledStatus(),
    );

    expect(await scheduledStatusRepository.countAll(), 1);
    ScheduledStatusDatabaseTestHelper.expectDbScheduledStatus(
      await scheduledStatusRepository
          .findByRemoteIdInAppType(dbScheduledStatus!.remoteId),
      dbScheduledStatus,
    );

    await scheduledStatusRepository.upsertInRemoteType(
      DbScheduledStatusPopulatedWrapper(
        dbScheduledStatusPopulated: DbScheduledStatusPopulated(
          dbScheduledStatus: dbScheduledStatus!,
        ),
      ).toPleromaScheduledStatus(),
    );
    // update item with same id
    expect(await scheduledStatusRepository.countAll(), 1);
    ScheduledStatusDatabaseTestHelper.expectDbScheduledStatus(
      await scheduledStatusRepository
          .findByRemoteIdInAppType(dbScheduledStatus!.remoteId),
      dbScheduledStatus,
    );
  });

  test('createQuery empty', () async {
    var query = scheduledStatusRepository.createQuery(
      filters: null,
      pagination: null,
      orderingTermData: null,
    );

    expect((await query.get()).length, 0);

    await scheduledStatusRepository.insertInDbType(
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed1',
      ))
          .copyWith(),
      mode: null,
    );

    expect((await query.get()).length, 1);

    await scheduledStatusRepository.insertInDbType(
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed2',
      ))
          .copyWith(),
      mode: null,
    );

    expect((await query.get()).length, 2);

    await scheduledStatusRepository.insertInDbType(
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed3',
      ))
          .copyWith(),
      mode: null,
    );

    expect((await query.get()).length, 3);
  });

  test('createQuery excludeCanceled', () async {
    var query = scheduledStatusRepository.createQuery(
      filters: ScheduledStatusRepositoryFilters(
        excludeCanceled: true,
      ),
      pagination: null,
      orderingTermData: null,
    );

    var scheduledStatus =
        (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
      seed: 'seed2',
      canceled: false,
    ))
            .copyWith(remoteId: 'remoteId4');
    scheduledStatus =
        await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      scheduledStatus,
    );

    expect((await query.get()).length, 1);

    await scheduledStatusRepository.markAsCanceled(
      scheduledStatus: DbScheduledStatusPopulatedWrapper(
        dbScheduledStatusPopulated: DbScheduledStatusPopulated(
          dbScheduledStatus: scheduledStatus,
        ),
      ),
      batchTransaction: null,
    );
    expect((await query.get()).length, 0);
  });
  test('createQuery excludeScheduleAtExpired', () async {
    var query = scheduledStatusRepository.createQuery(
      filters: ScheduledStatusRepositoryFilters(
        excludeScheduleAtExpired: true,
      ),
      pagination: null,
      orderingTermData: null,
    );

    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed2',
        scheduledAt: DateTime.now().add(Duration(minutes: 1)),
      ))
          .copyWith(remoteId: 'remoteId4'),
    );

    expect((await query.get()).length, 1);

    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed3',
        scheduledAt: DateTime.now().subtract(Duration(minutes: 1)),
      ))
          .copyWith(remoteId: 'remoteId5'),
    );

    expect((await query.get()).length, 1);
  });

  test('createQuery newerThan', () async {
    var query = scheduledStatusRepository.createQuery(
      filters: null,
      pagination: RepositoryPagination(
        newerThanItem:
            await ScheduledStatusTestHelper.createTestScheduledStatus(
          seed: 'remoteId5',
          remoteId: 'remoteId5',
        ),
      ),
      orderingTermData: ScheduledStatusRepositoryOrderingTermData.remoteIdDesc,
    );

    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed2',
      ))
          .copyWith(remoteId: 'remoteId4'),
    );

    expect((await query.get()).length, 0);

    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed2',
      ))
          .copyWith(remoteId: 'remoteId5'),
    );

    expect((await query.get()).length, 0);

    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed1',
      ))
          .copyWith(remoteId: 'remoteId6'),
    );

    expect((await query.get()).length, 1);
    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed1',
      ))
          .copyWith(remoteId: 'remoteId7'),
    );

    expect((await query.get()).length, 2);
  });

  test('createQuery notNewerThan', () async {
    var query = scheduledStatusRepository.createQuery(
      filters: null,
      pagination: RepositoryPagination(
        olderThanItem:
            await ScheduledStatusTestHelper.createTestScheduledStatus(
          seed: 'remoteId5',
          remoteId: 'remoteId5',
        ),
      ),
      orderingTermData: ScheduledStatusRepositoryOrderingTermData.remoteIdDesc,
    );

    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed2',
      ))
          .copyWith(remoteId: 'remoteId3'),
    );

    expect((await query.get()).length, 1);
    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed2',
      ))
          .copyWith(
        remoteId: 'remoteId4',
      ),
    );

    expect((await query.get()).length, 2);

    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed2',
      ))
          .copyWith(
        remoteId: 'remoteId5',
      ),
    );

    expect((await query.get()).length, 2);

    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed1',
      ))
          .copyWith(
        remoteId: 'remoteId6',
      ),
    );

    expect((await query.get()).length, 2);
  });

  test('createQuery notNewerThan & newerThan', () async {
    var query = scheduledStatusRepository.createQuery(
      filters: null,
      pagination: RepositoryPagination(
        newerThanItem:
            await ScheduledStatusTestHelper.createTestScheduledStatus(
          seed: 'remoteId2',
          remoteId: 'remoteId2',
        ),
        olderThanItem:
            await ScheduledStatusTestHelper.createTestScheduledStatus(
          seed: 'remoteId5',
          remoteId: 'remoteId5',
        ),
      ),
      orderingTermData: ScheduledStatusRepositoryOrderingTermData.remoteIdDesc,
    );

    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed1',
      ))
          .copyWith(
        remoteId: 'remoteId1',
      ),
    );

    expect((await query.get()).length, 0);

    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed2',
      ))
          .copyWith(
        remoteId: 'remoteId2',
      ),
    );

    expect((await query.get()).length, 0);
    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed3',
      ))
          .copyWith(
        remoteId: 'remoteId3',
      ),
    );

    expect((await query.get()).length, 1);

    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed4',
      ))
          .copyWith(
        remoteId: 'remoteId4',
      ),
    );

    expect((await query.get()).length, 2);

    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed5',
      ))
          .copyWith(
        remoteId: 'remoteId5',
      ),
    );

    expect((await query.get()).length, 2);

    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed6',
      ))
          .copyWith(
        remoteId: 'remoteId6',
      ),
    );

    expect((await query.get()).length, 2);
  });

  test('createQuery orderingTermData remoteId asc no limit', () async {
    var query = scheduledStatusRepository.createQuery(
      filters: null,
      pagination: null,
      orderingTermData: ScheduledStatusRepositoryOrderingTermData.remoteIdAsc,
    );

    var scheduledStatus2 =
        await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed2',
      ))
          .copyWith(
        remoteId: 'remoteId2',
      ),
    );
    var scheduledStatus1 =
        await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed1',
      ))
          .copyWith(
        remoteId: 'remoteId1',
      ),
    );
    var scheduledStatus3 =
        await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed3',
      ))
          .copyWith(
        remoteId: 'remoteId3',
      ),
    );

    var actualList = await query.get();

    expect(actualList.length, 3);

    ScheduledStatusDatabaseTestHelper.expectDbScheduledStatus(
      actualList[0],
      scheduledStatus1,
    );
    ScheduledStatusDatabaseTestHelper.expectDbScheduledStatus(
      actualList[1],
      scheduledStatus2,
    );
    ScheduledStatusDatabaseTestHelper.expectDbScheduledStatus(
      actualList[2],
      scheduledStatus3,
    );
  });

  test('createQuery orderingTermData remoteId desc no limit', () async {
    var query = scheduledStatusRepository.createQuery(
      filters: null,
      pagination: null,
      orderingTermData: ScheduledStatusRepositoryOrderingTermData.remoteIdDesc,
    );

    var scheduledStatus2 =
        await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed2',
      ))
          .copyWith(
        remoteId: 'remoteId2',
      ),
    );
    var scheduledStatus1 =
        await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed1',
      ))
          .copyWith(
        remoteId: 'remoteId1',
      ),
    );
    var scheduledStatus3 =
        await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed3',
      ))
          .copyWith(
        remoteId: 'remoteId3',
      ),
    );
    var actualList = await query.get();

    expect(
      actualList.length,
      3,
    );

    ScheduledStatusDatabaseTestHelper.expectDbScheduledStatus(
      actualList[0],
      scheduledStatus3,
    );
    ScheduledStatusDatabaseTestHelper.expectDbScheduledStatus(
      actualList[1],
      scheduledStatus2,
    );
    ScheduledStatusDatabaseTestHelper.expectDbScheduledStatus(
      actualList[2],
      scheduledStatus1,
    );
  });

  test('createQuery orderingTermData remoteId desc & limit & offset', () async {
    var query = scheduledStatusRepository.createQuery(
      filters: null,
      pagination: RepositoryPagination(
        limit: 1,
        offset: 1,
      ),
      orderingTermData: ScheduledStatusRepositoryOrderingTermData.remoteIdAsc,
    );

    var scheduledStatus2 =
        await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed2',
      ))
          .copyWith(
        remoteId: 'remoteId2',
      ),
    );
    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed1',
      ))
          .copyWith(
        remoteId: 'remoteId1',
      ),
    );
    await ScheduledStatusRepositoryTestHelper.insertDbScheduledStatus(
      scheduledStatusRepository,
      (await ScheduledStatusDatabaseTestHelper.createTestDbScheduledStatus(
        seed: 'seed3',
      ))
          .copyWith(
        remoteId: 'remoteId3',
      ),
    );

    var actualList = await query.get();

    expect(actualList.length, 1);

    ScheduledStatusDatabaseTestHelper.expectDbScheduledStatus(
      actualList[0],
      scheduledStatus2,
    );
  });
}
