import 'package:fedi/refactored/app/conversation/conversation_bloc.dart';
import 'package:fedi/refactored/app/conversation/conversation_bloc_impl.dart';
import 'package:fedi/refactored/app/conversation/conversation_model.dart';
import 'package:fedi/refactored/app/conversation/list/conversation_list_item_widget.dart';
import 'package:fedi/refactored/disposable/disposable_provider.dart';
import 'package:fedi/refactored/pagination/list/pagination_list_bloc.dart';
import 'package:fedi/refactored/pagination/list/pagination_list_widget.dart';
import 'package:fedi/refactored/pagination/pagination_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationPaginationListWidget
    extends PaginationListWidget<IConversation> {
  ConversationPaginationListWidget({
    @required Key key,
    Widget header,
    Widget footer,
    bool alwaysShowHeader,
    bool alwaysShowFooter,
    RefreshAction additionalRefreshAction,
  }) : super(
            key: key,
            header: header,
            footer: footer,
            alwaysShowHeader: alwaysShowHeader,
            alwaysShowFooter: alwaysShowFooter,
            additionalRefreshAction: additionalRefreshAction);

  @override
  ScrollView buildItemsCollectionView(
          {@required BuildContext context,
          @required List<IConversation> items,
          @required Widget header,
          @required Widget footer}) =>
      PaginationListWidget.buildItemsListView(
          context: context,
          items: items,
          header: header,
          footer: footer,
          itemBuilder: (context, index) => Provider<IConversation>.value(
                value: items[index],
                child:
                    DisposableProxyProvider<IConversation, IConversationBloc>(
                        update: (context, conversation, oldValue) =>
                            ConversationBloc.createFromContext(context,
                                conversation: conversation),
                        child: ConversationListItemWidget()),
              ));

  @override
  IPaginationListBloc<PaginationPage<IConversation>, IConversation>
      retrievePaginationListBloc(BuildContext context, {bool listen}) {
    var conversationPaginationListBloc = Provider.of<
            IPaginationListBloc<PaginationPage<IConversation>, IConversation>>(
        context,
        listen: listen);
    return conversationPaginationListBloc;
  }
}