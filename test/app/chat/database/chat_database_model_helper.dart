import 'package:fedi/app/chat/chat_model.dart';
import 'package:fedi/app/database/app_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Future<DbChat> createTestDbChat(
        {@required String seed,
        String remoteId,
        int unread,
        DateTime updatedAt}) async =>
    DbChat(
      id: null,
      remoteId: remoteId ?? seed + "remoteId1",
      unread: unread ?? seed.hashCode,
      updatedAt: updatedAt ?? DateTime(seed.hashCode % 2000),
    );

void expectDbChat(IChat actual, DbChat expected) {
  if (actual == null && expected == null) {
    return;
  }

  expect(actual != null, true);

  expect(actual.localId != null, true);
  expect(actual.remoteId, expected.remoteId);
  expect(actual.unread, expected.unread);
  expect(actual.updatedAt, expected.updatedAt);
}