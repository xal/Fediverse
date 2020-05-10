import 'package:easy_localization/easy_localization.dart';
import 'package:fedi/refactored/app/account/my/settings/my_account_settings_bloc.dart';
import 'package:fedi/refactored/app/conversation/conversations_list_bloc.dart';
import 'package:fedi/refactored/app/conversation/conversations_list_bloc_impl.dart';
import 'package:fedi/refactored/app/conversation/conversations_list_widget.dart';
import 'package:fedi/refactored/app/conversation/start/start_conversation_page.dart';
import 'package:fedi/refactored/app/header/header_image_decoration_widget.dart';
import 'package:fedi/refactored/disposable/disposable_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

var _logger = Logger("conversations_home_tab_page.dart");

class ConversationsHomeTabPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  ConversationsHomeTabPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _logger.finest(() => "build");

    return Scaffold(
      key: _drawerKey,
      body: Column(
        children: <Widget>[
          HeaderImageDecorationWidget(
              child: SafeArea(child: buildTopBar(context))),
          DisposableProvider<IConversationsListBloc>(
              create: (context) =>
                  ConversationsListBloc.createFromContext(context),
              child: Expanded(child: ConversationsListWidget(key: key)))
        ],
      ),
    );
  }

  Widget buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(AppLocalizations.of(context)
            .tr("app.home.tab.conversations.title")),
        Row(
          children: <Widget>[
            OutlineButton(
              onPressed: () {
                IMyAccountSettingsBloc.of(context, listen: false)
                    .changeIsNewChatsEnabled(true);
              },
              child: Text(
                AppLocalizations.of(context)
                    .tr("app.home.tab.conversations.action.switch_to_chats"),
                style: TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                goToStartConversationPage(context);
              },
            ),
          ],
        )
      ],
    );
  }
}
