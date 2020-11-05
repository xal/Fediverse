// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pleroma_chat_database_dao.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$ChatDaoMixin on DatabaseAccessor<AppDatabase> {
  $DbChatsTable get dbChats => attachedDatabase.dbChats;
  Selectable<int> countAll() {
    return customSelect('SELECT Count(*) FROM db_chats;',
        variables: [],
        readsFrom: {dbChats}).map((QueryRow row) => row.readInt('Count(*)'));
  }

  Selectable<int> countById(int id) {
    return customSelect('SELECT COUNT(*) FROM db_chats WHERE id = :id;',
        variables: [Variable.withInt(id)],
        readsFrom: {dbChats}).map((QueryRow row) => row.readInt('COUNT(*)'));
  }

  Future<int> deleteById(int id) {
    return customUpdate(
      'DELETE FROM db_chats WHERE id = :id;',
      variables: [Variable.withInt(id)],
      updates: {dbChats},
      updateKind: UpdateKind.delete,
    );
  }

  Future<int> clear() {
    return customUpdate(
      'DELETE FROM db_chats',
      variables: [],
      updates: {dbChats},
      updateKind: UpdateKind.delete,
    );
  }

  Selectable<DbChat> getAll() {
    return customSelect('SELECT * FROM db_chats',
        variables: [], readsFrom: {dbChats}).map(dbChats.mapFromRow);
  }

  Selectable<int> findLocalIdByRemoteId(String remoteId) {
    return customSelect('SELECT id FROM db_chats WHERE remote_id = :remoteId;',
        variables: [Variable.withString(remoteId)],
        readsFrom: {dbChats}).map((QueryRow row) => row.readInt('id'));
  }
}