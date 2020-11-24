import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fedi/app/settings/settings_model.dart';
import 'package:fedi/app/timeline/type/timeline_type_model.dart';
import 'package:fedi/pleroma/account/pleroma_account_model.dart';
import 'package:fedi/pleroma/list/pleroma_list_model.dart';
import 'package:fedi/pleroma/timeline/pleroma_timeline_model.dart';
import 'package:fedi/pleroma/visibility/pleroma_visibility_model.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'timeline_settings_model.g.dart';

Function eq = const ListEquality().equals;

// -32 is hack for hive 0.x backward ids compatibility
// see reservedIds in Hive,
// which not exist in Hive 0.x
//@HiveType()
@HiveType(typeId: -32 + 79)
@JsonSerializable(explicitToJson: true)
class TimelineSettings extends ISettings<TimelineSettings> {
  static TimelineSettings createDefaultPublicSettings() =>
      TimelineSettings.public(
        onlyWithMedia: false,
        onlyRemote: false,
        onlyLocal: false,
        withMuted: false,
        excludeVisibilities: [],
        websocketsUpdates: true,
      );

  static TimelineSettings createDefaultHomeSettings() => TimelineSettings.home(
        onlyLocal: false,
        withMuted: false,
        excludeVisibilities: [],
        websocketsUpdates: true,
      );

  static TimelineSettings createDefaultCustomListSettings({
    @required IPleromaList onlyInRemoteList,
  }) =>
      TimelineSettings.list(
        withMuted: false,
        excludeVisibilities: [],
        onlyInRemoteList: onlyInRemoteList,
        websocketsUpdates: true,
      );

  static TimelineSettings createDefaultHashtagSettings({
    @required String withRemoteHashtag,
  }) =>
      TimelineSettings.hashtag(
        onlyWithMedia: false,
        onlyLocal: false,
        withMuted: false,
        excludeVisibilities: [],
        withRemoteHashtag: withRemoteHashtag,
        websocketsUpdates: true,
      );

  static TimelineSettings createDefaultAccountSettings({
    @required IPleromaAccount onlyFromRemoteAccount,
  }) =>
      TimelineSettings.account(
        onlyWithMedia: false,
        excludeReblogs: false,
        excludeReplies: false,
        onlyPinned: false,
        onlyFromRemoteAccount: onlyFromRemoteAccount,
        websocketsUpdates: true,
      );

  @HiveField(1)
  @JsonKey(name: "only_with_media")
  final bool onlyWithMedia;

  @HiveField(2)
  @JsonKey(name: "exclude_replies")
  final bool excludeReplies;

  @HiveField(3)
  @JsonKey(name: "exclude_nsfw_sensitive")
  final bool excludeNsfwSensitive;

  @HiveField(4)
  @JsonKey(name: "only_remote")
  final bool onlyRemote;

  @HiveField(5)
  @JsonKey(name: "only_local")
  final bool onlyLocal;

  @HiveField(6)
  @JsonKey(name: "with_muted")
  final bool withMuted;

  @HiveField(7)
  @JsonKey(name: "exclude_visibilities_strings")
  final List<String> excludeVisibilitiesStrings;

  @HiveField(9)
  @JsonKey(name: "only_in_list")
  final PleromaList onlyInRemoteList;

  @HiveField(10)
  @JsonKey(name: "with_remote_hashtag")
  final String withRemoteHashtag;

  @HiveField(11)
  @JsonKey(name: "reply_visibility_filter_string")
  final String replyVisibilityFilterString;

  @HiveField(13)
  @JsonKey(name: "only_from_remote_account")
  final PleromaAccount onlyFromRemoteAccount;

  @HiveField(14)
  @JsonKey(name: "only_pinned")
  final bool onlyPinned;

  @HiveField(15)
  @JsonKey(name: "exclude_reblogs")
  final bool excludeReblogs;

  @HiveField(16)
  @JsonKey(name: "web_sockets_updates")
  final bool webSocketsUpdates;

  TimelineSettings({
    @required this.onlyWithMedia,
    @required this.excludeReplies,
    @required this.excludeNsfwSensitive,
    @required this.onlyRemote,
    @required this.onlyLocal,
    @required this.withMuted,
    @required this.excludeVisibilitiesStrings,
    @required this.onlyInRemoteList,
    @required this.withRemoteHashtag,
    @required this.replyVisibilityFilterString,
    @required this.onlyFromRemoteAccount,
    @required this.onlyPinned,
    @required this.excludeReblogs,
    @required this.webSocketsUpdates,
  });

  TimelineSettings.home({
    @required bool onlyLocal,
    @required bool withMuted,
    @required List<PleromaVisibility> excludeVisibilities,
    @required bool websocketsUpdates,
  }) : this(
          onlyWithMedia: null,
          excludeReplies: null,
          excludeNsfwSensitive: null,
          onlyRemote: null,
          onlyLocal: onlyLocal,
          withMuted: withMuted,
          excludeVisibilitiesStrings: excludeVisibilities
              ?.map((excludeVisibility) => excludeVisibility.toJsonValue())
              ?.toList(),
          onlyInRemoteList: null,
          withRemoteHashtag: null,
          replyVisibilityFilterString: null,
          onlyFromRemoteAccount: null,
          onlyPinned: null,
          excludeReblogs: null,
          webSocketsUpdates: websocketsUpdates,
        );

  TimelineSettings.public({
    @required bool onlyWithMedia,
    @required bool onlyRemote,
    @required bool onlyLocal,
    @required bool withMuted,
    @required List<PleromaVisibility> excludeVisibilities,
    @required bool websocketsUpdates,
  }) : this(
          onlyWithMedia: onlyWithMedia,
          excludeReplies: null,
          excludeNsfwSensitive: null,
          onlyRemote: onlyRemote,
          onlyLocal: onlyLocal,
          withMuted: withMuted,
          excludeVisibilitiesStrings: excludeVisibilities
              ?.map((excludeVisibility) => excludeVisibility.toJsonValue())
              ?.toList(),
          onlyInRemoteList: null,
          withRemoteHashtag: null,
          replyVisibilityFilterString: null,
          onlyFromRemoteAccount: null,
          onlyPinned: null,
          excludeReblogs: null,
          webSocketsUpdates: websocketsUpdates,
        );

  TimelineSettings.hashtag({
    @required bool onlyWithMedia,
    @required bool onlyLocal,
    @required bool withMuted,
    @required List<PleromaVisibility> excludeVisibilities,
    @required String withRemoteHashtag,
    @required bool websocketsUpdates,
  }) : this(
          onlyWithMedia: onlyWithMedia,
          excludeReplies: null,
          excludeNsfwSensitive: null,
          onlyRemote: null,
          onlyLocal: onlyLocal,
          withMuted: withMuted,
          excludeVisibilitiesStrings: excludeVisibilities
              ?.map((excludeVisibility) => excludeVisibility.toJsonValue())
              ?.toList(),
          onlyInRemoteList: null,
          withRemoteHashtag: withRemoteHashtag,
          replyVisibilityFilterString: null,
          onlyFromRemoteAccount: null,
          onlyPinned: null,
          excludeReblogs: null,
          webSocketsUpdates: websocketsUpdates,
        );

  TimelineSettings.list({
    @required bool withMuted,
    @required List<PleromaVisibility> excludeVisibilities,
    @required IPleromaList onlyInRemoteList,
    @required bool websocketsUpdates,
  }) : this(
          onlyWithMedia: null,
          excludeReplies: null,
          excludeNsfwSensitive: null,
          onlyRemote: null,
          onlyLocal: null,
          withMuted: withMuted,
          excludeVisibilitiesStrings: excludeVisibilities
              ?.map((excludeVisibility) => excludeVisibility.toJsonValue())
              ?.toList(),
          onlyInRemoteList: onlyInRemoteList,
          withRemoteHashtag: null,
          replyVisibilityFilterString: null,
          onlyFromRemoteAccount: null,
          onlyPinned: null,
          excludeReblogs: null,
          webSocketsUpdates: websocketsUpdates,
        );

  TimelineSettings.account({
    @required IPleromaAccount onlyFromRemoteAccount,
    @required bool onlyWithMedia,
    @required bool excludeReplies,
    @required bool excludeReblogs,
    @required bool onlyPinned,
    @required bool websocketsUpdates,
  }) : this(
          onlyWithMedia: onlyWithMedia,
          excludeReplies: excludeReplies,
          excludeNsfwSensitive: null,
          onlyRemote: null,
          onlyLocal: null,
          withMuted: null,
          excludeVisibilitiesStrings: [],
          onlyInRemoteList: null,
          withRemoteHashtag: null,
          replyVisibilityFilterString: null,
          onlyFromRemoteAccount: onlyFromRemoteAccount,
          onlyPinned: onlyPinned,
          excludeReblogs: excludeReblogs,
          webSocketsUpdates: websocketsUpdates,
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelineSettings &&
          runtimeType == other.runtimeType &&
          onlyWithMedia == other.onlyWithMedia &&
          excludeReplies == other.excludeReplies &&
          excludeNsfwSensitive == other.excludeNsfwSensitive &&
          onlyRemote == other.onlyRemote &&
          onlyLocal == other.onlyLocal &&
          withMuted == other.withMuted &&
          eq(excludeVisibilitiesStrings, other.excludeVisibilitiesStrings) &&
          onlyInRemoteList == other.onlyInRemoteList &&
          withRemoteHashtag == other.withRemoteHashtag &&
          replyVisibilityFilterString == other.replyVisibilityFilterString &&
          onlyFromRemoteAccount == other.onlyFromRemoteAccount &&
          onlyPinned == other.onlyPinned &&
          excludeReblogs == other.excludeReblogs &&
          webSocketsUpdates == other.webSocketsUpdates;

  @override
  int get hashCode =>
      onlyWithMedia.hashCode ^
      excludeReplies.hashCode ^
      excludeNsfwSensitive.hashCode ^
      onlyRemote.hashCode ^
      onlyLocal.hashCode ^
      withMuted.hashCode ^
      excludeVisibilitiesStrings.hashCode ^
      onlyInRemoteList.hashCode ^
      withRemoteHashtag.hashCode ^
      replyVisibilityFilterString.hashCode ^
      onlyFromRemoteAccount.hashCode ^
      onlyPinned.hashCode ^
      excludeReblogs.hashCode ^
      webSocketsUpdates.hashCode;

  @override
  String toString() {
    return 'TimelineSettings{'
        ' onlyWithMedia: $onlyWithMedia,'
        ' excludeReplies: $excludeReplies,'
        ' excludeNsfwSensitive: $excludeNsfwSensitive,'
        ' onlyRemote: $onlyRemote, onlyLocal: $onlyLocal,'
        ' withMuted: $withMuted,'
        ' excludeVisibilitiesStrings: $excludeVisibilitiesStrings,'
        ' onlyInListWithRemoteId: $onlyInRemoteList,'
        ' withHashtag: $withRemoteHashtag,'
        ' PleromaReplyVisibilityFilterString:'
        ' $replyVisibilityFilterString,'
        ' onlyFromAccountWithRemoteId: $onlyFromRemoteAccount,'
        ' websocketsUpdates: $webSocketsUpdates,'
        ' onlyPinned: $onlyPinned, excludeReblogs: $excludeReblogs}';
  }

  factory TimelineSettings.fromJson(Map<String, dynamic> json) =>
      _$TimelineSettingsFromJson(json);

  factory TimelineSettings.fromJsonString(String jsonString) =>
      _$TimelineSettingsFromJson(jsonDecode(jsonString));

  static List<TimelineSettings> listFromJsonString(String str) =>
      List<TimelineSettings>.from(
          json.decode(str).map((x) => TimelineSettings.fromJson(x)));

  @override
  Map<String, dynamic> toJson() => _$TimelineSettingsToJson(this);

  String toJsonString() => jsonEncode(_$TimelineSettingsToJson(this));

  List<PleromaVisibility> get excludeVisibilities => excludeVisibilitiesStrings
      ?.map((excludeVisibilityString) =>
          excludeVisibilityString.toPleromaVisibility())
      ?.toList();

  PleromaReplyVisibilityFilter get replyVisibilityFilter =>
      replyVisibilityFilterString?.toPleromaReplyVisibilityFilter();

  static String generateUniqueTimelineId() =>
      "${DateTime.now().millisecondsSinceEpoch}";

  @override
  TimelineSettings clone() => copyWith();

  TimelineSettings copyWith({
    bool onlyWithMedia,
    bool excludeReplies,
    bool excludeNsfwSensitive,
    bool onlyRemote,
    bool onlyLocal,
    bool withMuted,
    List<String> excludeVisibilitiesStrings,
    PleromaList onlyInRemoteList,
    String withRemoteHashtag,
    String replyVisibilityFilterString,
    PleromaAccount onlyFromRemoteAccount,
    bool onlyPinned,
    bool excludeReblogs,
    bool webSocketsUpdates,
  }) =>
      TimelineSettings(
        onlyWithMedia: onlyWithMedia ?? this.onlyWithMedia,
        excludeReplies: excludeReplies ?? this.excludeReplies,
        excludeNsfwSensitive: excludeNsfwSensitive ?? this.excludeNsfwSensitive,
        onlyRemote: onlyRemote ?? this.onlyRemote,
        onlyLocal: onlyLocal ?? this.onlyLocal,
        withMuted: withMuted ?? this.withMuted,
        excludeVisibilitiesStrings:
            excludeVisibilitiesStrings ?? this.excludeVisibilitiesStrings,
        onlyInRemoteList: onlyInRemoteList ?? this.onlyInRemoteList,
        withRemoteHashtag: withRemoteHashtag ?? this.withRemoteHashtag,
        replyVisibilityFilterString:
            replyVisibilityFilterString ?? this.replyVisibilityFilterString,
        onlyFromRemoteAccount:
            onlyFromRemoteAccount ?? this.onlyFromRemoteAccount,
        onlyPinned: onlyPinned ?? this.onlyPinned,
        excludeReblogs: excludeReblogs ?? this.excludeReblogs,
        webSocketsUpdates: webSocketsUpdates ?? this.webSocketsUpdates,
      );

  static TimelineSettings createDefaultSettings(TimelineType timelineType) {
    switch (timelineType) {
      case TimelineType.public:
        return createDefaultPublicSettings();
        break;
      case TimelineType.customList:
        return createDefaultCustomListSettings(onlyInRemoteList: null);
        break;
      case TimelineType.home:
        return createDefaultHomeSettings();
        break;
      case TimelineType.hashtag:
        return createDefaultHashtagSettings(withRemoteHashtag: null);
        break;
      case TimelineType.account:
        return createDefaultAccountSettings(onlyFromRemoteAccount: null);
        break;
    }

    throw UnsupportedError("Unsupported timelineType $timelineType");
  }
}
