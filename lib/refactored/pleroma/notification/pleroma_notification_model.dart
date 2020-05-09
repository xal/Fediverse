import 'dart:convert';

import 'package:fedi/refactored/enum/enum_values.dart';
import 'package:fedi/refactored/mastodon/notification/mastodon_notification_model.dart';
import 'package:fedi/refactored/pleroma/account/pleroma_account_model.dart';
import 'package:fedi/refactored/pleroma/chat/pleroma_chat_model.dart';
import 'package:fedi/refactored/pleroma/status/pleroma_status_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pleroma_notification_model.g.dart';

abstract class IPleromaNotification extends IMastodonNotification {
  @override
  IPleromaAccount get account;

  @override
  IPleromaStatus get status;

  IPleromaChatMessage get chatMessage;

  PleromaNotificationType get typePleroma;
}


enum PleromaNotificationType {
  follow,
  mention,
  reblog,
  favourite,
  poll,
  chatMention
}

@JsonSerializable()
class PleromaNotification extends IPleromaNotification {
  @override
  PleromaAccount account;
  @override
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @override
  String id;
  @override
  String type;
  @override
  PleromaStatus status;

  @override
  @JsonKey(name: "chat_message")
  PleromaChatMessage chatMessage;

  PleromaNotification({
    this.account,
    this.createdAt,
    this.id,
    this.type,
    this.status,
    this.chatMessage,
  });

  factory PleromaNotification.fromJson(Map<String, dynamic> json) =>
      _$PleromaNotificationFromJson(json);

  factory PleromaNotification.fromJsonString(String jsonString) =>
      _$PleromaNotificationFromJson(jsonDecode(jsonString));

  static List<PleromaNotification> listFromJsonString(String str) =>
      List<PleromaNotification>.from(
          json.decode(str).map((x) => PleromaNotification.fromJson(x)));

  Map<String, dynamic> toJson() => _$PleromaNotificationToJson(this);
  String toJsonString() => jsonEncode(_$PleromaNotificationToJson(this));

  @override
  String toString() {
    return 'PleromaNotification{account: $account, createdAt: $createdAt, id: $id,'
        ' type: $type, status: $status}';
  }

  @override
  MastodonNotificationType get typeMastodon => mastodonNotificationTypeValues
      .map[type];

  @override
  PleromaNotificationType get typePleroma => pleromaNotificationTypeValues
      .map[type];
}


final pleromaNotificationTypeValues = EnumValues({
  "follow": PleromaNotificationType.follow,
  "mention": PleromaNotificationType.mention,
  "reblog": PleromaNotificationType.reblog,
  "favourite": PleromaNotificationType.favourite,
  "poll": PleromaNotificationType.poll,
  "pleroma:chat_mention": PleromaNotificationType.chatMention,
});
