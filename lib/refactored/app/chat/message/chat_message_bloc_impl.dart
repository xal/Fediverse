import 'package:fedi/refactored/app/account/account_model.dart';
import 'package:fedi/refactored/app/account/repository/account_repository.dart';
import 'package:fedi/refactored/app/chat/message/chat_message_bloc.dart';
import 'package:fedi/refactored/app/chat/message/chat_message_model.dart';
import 'package:fedi/refactored/app/chat/message/repository/chat_message_repository.dart';
import 'package:fedi/refactored/app/emoji/emoji_text_helper.dart';
import 'package:fedi/refactored/disposable/disposable_owner.dart';
import 'package:fedi/refactored/pleroma/account/pleroma_account_service.dart';
import 'package:fedi/refactored/pleroma/chat/pleroma_chat_service.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

var _logger = Logger("chat_message_bloc_impl.dart");

final int minimumCharactersLimitToCollapse = 400;

class ChatMessageBloc extends DisposableOwner implements IChatMessageBloc {
  static ChatMessageBloc createFromContext(
    BuildContext context,
    IChatMessage chatMessage, {
    bool isNeedWatchLocalRepositoryForUpdates = true,
    bool delayInit = true,
  }) =>
      ChatMessageBloc(
          pleromaChatService: IPleromaChatService.of(context, listen: false),
          pleromaAccountService:
              IPleromaAccountService.of(context, listen: false),
          chatMessageRepository:
              IChatMessageRepository.of(context, listen: false),
          accountRepository: IAccountRepository.of(context, listen: false),
          chatMessage: chatMessage,
          needRefreshFromNetworkOnInit: false,
          delayInit: delayInit,
          isNeedWatchLocalRepositoryForUpdates:
              isNeedWatchLocalRepositoryForUpdates);

  final BehaviorSubject<IChatMessage> _chatMessageSubject;



  final IPleromaChatService pleromaChatService;
  final IPleromaAccountService pleromaAccountService;
  final IChatMessageRepository chatMessageRepository;
  final IAccountRepository accountRepository;
  final bool isNeedWatchLocalRepositoryForUpdates;

  ChatMessageBloc({
    @required this.pleromaChatService,
    @required this.pleromaAccountService,
    @required this.chatMessageRepository,
    @required this.accountRepository,
    @required
        IChatMessage chatMessage, // for better performance we don't update
    // account too often
    bool needRefreshFromNetworkOnInit =
        false, // todo: remove hack. Don't init when bloc quickly disposed. Help
    //  improve performance in timeline unnecessary recreations
    bool delayInit = true,
    this.isNeedWatchLocalRepositoryForUpdates = true,
  }) : _chatMessageSubject = BehaviorSubject.seeded(chatMessage) {
    addDisposable(subject: _chatMessageSubject);

    assert(needRefreshFromNetworkOnInit != null);
    assert(isNeedWatchLocalRepositoryForUpdates != null);
    if (delayInit) {
      Future.delayed(Duration(seconds: 1), () {
        _init(chatMessage, needRefreshFromNetworkOnInit);
      });
    } else {
      _init(chatMessage, needRefreshFromNetworkOnInit);
    }
  }

  void _init(IChatMessage chatMessage, bool needRefreshFromNetworkOnInit) {
    if (!disposed) {
      if (isNeedWatchLocalRepositoryForUpdates) {
        addDisposable(
            streamSubscription: chatMessageRepository
                .watchByRemoteId(chatMessage.remoteId)
                .listen((updatedChatMessage) {
          if (updatedChatMessage != null) {
            _chatMessageSubject.add(updatedChatMessage);
          }
        }));
      }
      if (needRefreshFromNetworkOnInit) {
        refreshFromNetwork();
      }
    }
  }

  @override
  IChatMessage get chatMessage => _chatMessageSubject.value;

  @override
  Stream<IChatMessage> get chatMessageStream =>
      _chatMessageSubject.stream.distinct();

  @override
  IAccount get account => chatMessage?.account;

  @override
  Stream<IAccount> get accountStream =>
      chatMessageStream.map((chatMessage) => chatMessage.account).distinct();

  @override
  DateTime get createdAt => chatMessage?.createdAt;

  @override
  Stream<DateTime> get createdAtStream =>
      chatMessageStream.map((chatMessage) => chatMessage?.createdAt).distinct();

  @override
  String get remoteId => chatMessage.remoteId;

  @override
  String get content => chatMessage?.content;

  @override
  Stream<String> get contentStream =>
      chatMessageStream.map((chatMessage) => chatMessage?.content).distinct();

  @override
  String get accountAvatar => account?.avatar;

  @override
  Stream<String> get accountAvatarStream =>
      accountStream.map((account) => account.avatar).distinct();

  @override
  Future refreshFromNetwork() async {
    throw "not supported by API yet";
//    var remoteChatMessage =
//        await pleromaChatService.getChatMessage(chatMessageRemoteId: remoteId);
//
//    return _updateByRemoteChatMessage(remoteChatMessage);
  }

//  Future _updateByRemoteChatMessage(IPleromaChatMessage remoteChatMessage) {
//    return chatMessageRepository.updateLocalChatMessageByRemoteChatMessage(
//        oldLocalChatMessage: chatMessage,
//        newRemoteChatMessage: remoteChatMessage);
//  }

  @override
  String get contentWithEmojis =>
      addEmojiToHtmlContent(chatMessage.content, chatMessage.emojis);

  @override
  Stream<String> get contentWithEmojisStream => chatMessageStream
      .map((chatMessage) =>
          addEmojiToHtmlContent(chatMessage.content, chatMessage.emojis))
      .distinct();

  @override
  void dispose() {
    super.dispose();

    _logger.finest(() => "dispose");
  }
}