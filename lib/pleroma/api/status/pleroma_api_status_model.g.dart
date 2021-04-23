// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pleroma_api_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaScheduledStatus _$PleromaScheduledStatusFromJson(
    Map<String, dynamic> json) {
  return PleromaScheduledStatus(
    id: json['id'] as String,
    mediaAttachments: (json['media_attachments'] as List<dynamic>?)
        ?.map((e) => PleromaMediaAttachment.fromJson(e as Map<String, dynamic>))
        .toList(),
    params: PleromaScheduledStatusParams.fromJson(
        json['params'] as Map<String, dynamic>),
    scheduledAt: DateTime.parse(json['scheduled_at'] as String),
  );
}

Map<String, dynamic> _$PleromaScheduledStatusToJson(
        PleromaScheduledStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_attachments': instance.mediaAttachments,
      'params': instance.params,
      'scheduled_at': instance.scheduledAt.toIso8601String(),
    };

PleromaScheduledStatusParams _$PleromaScheduledStatusParamsFromJson(
    Map<String, dynamic> json) {
  return PleromaScheduledStatusParams(
    text: json['text'] as String?,
    mediaIds:
        (json['media_ids'] as List<dynamic>?)?.map((e) => e as String).toList(),
    sensitive: json['sensitive'] as bool,
    spoilerText: json['spoiler_text'] as String?,
    visibility: json['visibility'] as String,
    scheduledAt: DateTime.parse(json['scheduled_at'] as String),
    poll: json['poll'] == null
        ? null
        : PleromaPostStatusPoll.fromJson(json['poll'] as Map<String, dynamic>),
    idempotency: json['idempotency'] as String?,
    inReplyToId: json['in_reply_to_id'] as String?,
    applicationId: json['application_id'],
    language: json['language'] as String?,
    expiresInSeconds: json['expiresInSeconds'] as int?,
    to: (json['to'] as List<dynamic>?)?.map((e) => e as String).toList(),
    inReplyToConversationId: json['in_reply_to_conversation_id'] as String?,
  );
}

Map<String, dynamic> _$PleromaScheduledStatusParamsToJson(
        PleromaScheduledStatusParams instance) =>
    <String, dynamic>{
      'expiresInSeconds': instance.expiresInSeconds,
      'text': instance.text,
      'media_ids': instance.mediaIds,
      'sensitive': instance.sensitive,
      'spoiler_text': instance.spoilerText,
      'visibility': instance.visibility,
      'language': instance.language,
      'scheduled_at': instance.scheduledAt.toIso8601String(),
      'poll': instance.poll?.toJson(),
      'idempotency': instance.idempotency,
      'in_reply_to_id': instance.inReplyToId,
      'application_id': instance.applicationId,
      'in_reply_to_conversation_id': instance.inReplyToConversationId,
      'to': instance.to,
    };

PleromaStatus _$PleromaStatusFromJson(Map<String, dynamic> json) {
  return PleromaStatus(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    inReplyToId: json['in_reply_to_id'] as String?,
    inReplyToAccountId: json['in_reply_to_account_id'] as String?,
    sensitive: json['sensitive'] as bool,
    spoilerText: json['spoiler_text'] as String?,
    uri: json['uri'] as String,
    url: json['url'] as String?,
    repliesCount: json['replies_count'] as int?,
    reblogsCount: json['reblogs_count'] as int?,
    favouritesCount: json['favourites_count'] as int?,
    favourited: json['favourited'] as bool?,
    reblogged: json['reblogged'] as bool?,
    muted: json['muted'] as bool?,
    bookmarked: json['bookmarked'] as bool?,
    pinned: json['pinned'] as bool?,
    content: json['content'] as String?,
    reblog: json['reblog'] == null
        ? null
        : PleromaStatus.fromJson(json['reblog'] as Map<String, dynamic>),
    application: json['application'] == null
        ? null
        : PleromaApplication.fromJson(
            json['application'] as Map<String, dynamic>),
    account: PleromaAccount.fromJson(json['account'] as Map<String, dynamic>),
    mediaAttachments: (json['media_attachments'] as List<dynamic>?)
        ?.map((e) => PleromaMediaAttachment.fromJson(e as Map<String, dynamic>))
        .toList(),
    mentions: (json['mentions'] as List<dynamic>?)
        ?.map((e) => PleromaMention.fromJson(e as Map<String, dynamic>))
        .toList(),
    tags: (json['tags'] as List<dynamic>?)
        ?.map((e) => PleromaTag.fromJson(e as Map<String, dynamic>))
        .toList(),
    emojis: (json['emojis'] as List<dynamic>?)
        ?.map((e) => PleromaEmoji.fromJson(e as Map<String, dynamic>))
        .toList(),
    poll: json['poll'] == null
        ? null
        : PleromaPoll.fromJson(json['poll'] as Map<String, dynamic>),
    card: json['card'] == null
        ? null
        : PleromaCard.fromJson(json['card'] as Map<String, dynamic>),
    pleroma: json['pleroma'] == null
        ? null
        : PleromaStatusPleromaPart.fromJson(
            json['pleroma'] as Map<String, dynamic>),
    visibility: json['visibility'] as String,
    language: json['language'] as String?,
  );
}

Map<String, dynamic> _$PleromaStatusToJson(PleromaStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'in_reply_to_id': instance.inReplyToId,
      'in_reply_to_account_id': instance.inReplyToAccountId,
      'sensitive': instance.sensitive,
      'spoiler_text': instance.spoilerText,
      'uri': instance.uri,
      'url': instance.url,
      'replies_count': instance.repliesCount,
      'reblogs_count': instance.reblogsCount,
      'favourites_count': instance.favouritesCount,
      'favourited': instance.favourited,
      'reblogged': instance.reblogged,
      'muted': instance.muted,
      'bookmarked': instance.bookmarked,
      'pinned': instance.pinned,
      'content': instance.content,
      'reblog': instance.reblog?.toJson(),
      'application': instance.application?.toJson(),
      'account': instance.account.toJson(),
      'media_attachments':
          instance.mediaAttachments?.map((e) => e.toJson()).toList(),
      'mentions': instance.mentions?.map((e) => e.toJson()).toList(),
      'tags': instance.tags?.map((e) => e.toJson()).toList(),
      'emojis': instance.emojis?.map((e) => e.toJson()).toList(),
      'poll': instance.poll?.toJson(),
      'card': instance.card?.toJson(),
      'pleroma': instance.pleroma?.toJson(),
      'language': instance.language,
      'visibility': instance.visibility,
    };

PleromaStatusPleromaPart _$PleromaStatusPleromaPartFromJson(
    Map<String, dynamic> json) {
  return PleromaStatusPleromaPart(
    content: json['content'] == null
        ? null
        : PleromaContent.fromJson(json['content'] as Map<String, dynamic>),
    conversationId: json['conversation_id'] as int?,
    directConversationId: json['direct_conversation_id'] as int?,
    inReplyToAccountAcct: json['in_reply_to_account_acct'] as String?,
    local: json['local'] as bool?,
    spoilerText: json['spoiler_text'] == null
        ? null
        : PleromaContent.fromJson(json['spoiler_text'] as Map<String, dynamic>),
    expiresAt: json['expires_at'] == null
        ? null
        : DateTime.parse(json['expires_at'] as String),
    threadMuted: json['thread_muted'] as bool?,
    emojiReactions: (json['emoji_reactions'] as List<dynamic>?)
        ?.map((e) =>
            PleromaStatusEmojiReaction.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$PleromaStatusPleromaPartToJson(
        PleromaStatusPleromaPart instance) =>
    <String, dynamic>{
      'content': instance.content?.toJson(),
      'conversation_id': instance.conversationId,
      'direct_conversation_id': instance.directConversationId,
      'in_reply_to_account_acct': instance.inReplyToAccountAcct,
      'local': instance.local,
      'spoiler_text': instance.spoilerText?.toJson(),
      'expires_at': instance.expiresAt?.toIso8601String(),
      'thread_muted': instance.threadMuted,
      'emoji_reactions':
          instance.emojiReactions?.map((e) => e.toJson()).toList(),
    };

PleromaPostStatusPoll _$PleromaPostStatusPollFromJson(
    Map<String, dynamic> json) {
  return PleromaPostStatusPoll(
    expiresInSeconds: json['expires_in'] as int,
    hideTotals: json['hide_totals'] as bool,
    multiple: json['multiple'] as bool,
    options:
        (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$PleromaPostStatusPollToJson(
        PleromaPostStatusPoll instance) =>
    <String, dynamic>{
      'expires_in': instance.expiresInSeconds,
      'hide_totals': instance.hideTotals,
      'multiple': instance.multiple,
      'options': instance.options,
    };

PleromaPostStatus _$PleromaPostStatusFromJson(Map<String, dynamic> json) {
  return PleromaPostStatus(
    contentType: json['content_type'] as String?,
    expiresInSeconds: json['expires_in'] as int?,
    inReplyToConversationId: json['in_reply_to_conversation_id'] as String?,
    inReplyToId: json['in_reply_to_id'] as String?,
    language: json['language'] as String?,
    visibility: json['visibility'] as String,
    mediaIds:
        (json['media_ids'] as List<dynamic>?)?.map((e) => e as String).toList(),
    poll: json['poll'] == null
        ? null
        : PleromaPostStatusPoll.fromJson(json['poll'] as Map<String, dynamic>),
    preview: json['preview'] as bool?,
    sensitive: json['sensitive'] as bool,
    spoilerText: json['spoiler_text'] as String?,
    status: json['status'] as String?,
    to: (json['to'] as List<dynamic>?)?.map((e) => e as String?).toList(),
  );
}

Map<String, dynamic> _$PleromaPostStatusToJson(PleromaPostStatus instance) {
  final val = <String, dynamic>{
    'content_type': instance.contentType,
    'expires_in': instance.expiresInSeconds,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('in_reply_to_conversation_id', instance.inReplyToConversationId);
  writeNotNull('in_reply_to_id', instance.inReplyToId);
  val['language'] = instance.language;
  val['visibility'] = instance.visibility;
  val['media_ids'] = instance.mediaIds;
  val['poll'] = instance.poll;
  val['preview'] = instance.preview;
  val['sensitive'] = instance.sensitive;
  val['spoiler_text'] = instance.spoilerText;
  val['status'] = instance.status;
  val['to'] = instance.to;
  return val;
}

PleromaScheduleStatus _$PleromaScheduleStatusFromJson(
    Map<String, dynamic> json) {
  return PleromaScheduleStatus(
    contentType: json['content_type'] as String?,
    expiresInSeconds: json['expires_in'] as int?,
    inReplyToConversationId: json['in_reply_to_conversation_id'] as String?,
    inReplyToId: json['in_reply_to_id'] as String?,
    language: json['language'] as String?,
    visibility: json['visibility'] as String,
    mediaIds:
        (json['media_ids'] as List<dynamic>?)?.map((e) => e as String).toList(),
    poll: json['poll'] == null
        ? null
        : PleromaPostStatusPoll.fromJson(json['poll'] as Map<String, dynamic>),
    preview: json['preview'] as bool?,
    sensitive: json['sensitive'] as bool,
    spoilerText: json['spoiler_text'] as String?,
    status: json['status'] as String?,
    to: (json['to'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    scheduledAt: DateTime.parse(json['scheduled_at'] as String),
  );
}

Map<String, dynamic> _$PleromaScheduleStatusToJson(
        PleromaScheduleStatus instance) =>
    <String, dynamic>{
      'content_type': instance.contentType,
      'expires_in': instance.expiresInSeconds,
      'in_reply_to_conversation_id': instance.inReplyToConversationId,
      'in_reply_to_id': instance.inReplyToId,
      'language': instance.language,
      'visibility': instance.visibility,
      'media_ids': instance.mediaIds,
      'poll': instance.poll,
      'preview': instance.preview,
      'sensitive': instance.sensitive,
      'spoiler_text': instance.spoilerText,
      'status': instance.status,
      'to': instance.to,
      'scheduled_at':
          PleromaScheduleStatus.toUTCIsoString(instance.scheduledAt),
    };

PleromaStatusEmojiReaction _$PleromaStatusEmojiReactionFromJson(
    Map<String, dynamic> json) {
  return PleromaStatusEmojiReaction(
    name: json['name'] as String,
    count: json['count'] as int,
    me: json['me'] as bool,
    accounts: (json['accounts'] as List<dynamic>?)
        ?.map((e) => PleromaAccount.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$PleromaStatusEmojiReactionToJson(
        PleromaStatusEmojiReaction instance) =>
    <String, dynamic>{
      'name': instance.name,
      'count': instance.count,
      'me': instance.me,
      'accounts': instance.accounts,
    };