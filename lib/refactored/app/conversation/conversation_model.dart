import 'package:fedi/refactored/app/database/app_database.dart';

abstract class IConversation {
  int get localId;

  String get remoteId;

  bool get unread;
}

class DbConversationWrapper implements IConversation {
  final DbConversation dbConversation;

  DbConversationWrapper(this.dbConversation);

  @override
  int get localId => dbConversation.id;

  @override
  String get remoteId => dbConversation.remoteId;

  @override
  bool get unread => dbConversation.unread;

  @override
  String toString() {
    return 'DbConversationWrapper{dbConversation: $dbConversation}';
  }

  DbConversationWrapper copyWith({int id, String remoteId, bool unread}) =>
      DbConversationWrapper(dbConversation.copyWith(
        id: id ?? this.localId,
        remoteId: remoteId ?? this.remoteId,
        unread: unread ?? this.unread,
      ));
}
