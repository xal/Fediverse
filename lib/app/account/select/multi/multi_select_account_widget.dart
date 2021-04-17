import 'package:fedi/app/account/account_model.dart';
import 'package:fedi/app/account/pagination/list/account_pagination_list_widget.dart';
import 'package:fedi/app/account/select/multi/multi_select_account_bloc.dart';
import 'package:fedi/app/ui/button/icon/fedi_icon_in_circle_transparent_button.dart';
import 'package:fedi/app/ui/fedi_icons.dart';
import 'package:fedi/app/ui/theme/fedi_ui_theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MultiSelectAccountWidget extends StatelessWidget {
  final bool? alwaysShowHeader;
  final Widget? header;
  final bool? alwaysShowFooter;
  final Widget? footer;

  const MultiSelectAccountWidget({
    this.header,
    this.footer,
    this.alwaysShowHeader,
    this.alwaysShowFooter,
  });

  @override
  Widget build(BuildContext context) {
    return AccountPaginationListWidget(
      header: header,
      footer: footer,
      alwaysShowHeader: alwaysShowHeader,
      alwaysShowFooter: alwaysShowFooter,
      // ignore: no-empty-block
      accountSelectedCallback: (_, __) {
        // nothing
      },
      accountActions: <Widget>[
        const _MultiSelectAccountItemActionWidget(),
      ],
      key: PageStorageKey("MultiSelectAccountWidget"),
    );
  }
}

class _MultiSelectAccountItemActionWidget extends StatelessWidget {
  const _MultiSelectAccountItemActionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var multiSelectAccountBloc = IMultiSelectAccountBloc.of(context);
    var account = Provider.of<IAccount>(context);
    return StreamBuilder<bool>(
      stream: multiSelectAccountBloc.isAccountSelectedStream(account),
      builder: (context, snapshot) {
        var isAccountSelected = snapshot.data ?? false;

        return FediIconInCircleTransparentButton(
          FediIcons.check,
          color: isAccountSelected
              ? IFediUiColorTheme.of(context).primary
              : IFediUiColorTheme.of(context).darkGrey,
          onPressed: () {
            if (isAccountSelected) {
              multiSelectAccountBloc.removeAccountSelection(account);
            } else {
              multiSelectAccountBloc.addAccountSelection(account);
            }
          },
        );
      },
    );
  }
}
