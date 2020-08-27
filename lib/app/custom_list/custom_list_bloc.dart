import 'package:fedi/app/account/account_model.dart';
import 'package:fedi/app/custom_list/custom_list_model.dart';
import 'package:fedi/disposable/disposable.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class ICustomListBloc implements Disposable {
  static ICustomListBloc of(BuildContext context, {bool listen = true}) =>
      Provider.of<ICustomListBloc>(context, listen: listen);

  ICustomList get customList;

  Stream<ICustomList> get customListStream;

  String get title;

  Stream<String> get titleStream;

  Future delete();

  Future edit({
    @required String title,
  });

  Future addAccounts({
    @required List<IAccount> accounts,
  });

  Future removeAccounts({
    @required List<IAccount> accounts,
  });
}