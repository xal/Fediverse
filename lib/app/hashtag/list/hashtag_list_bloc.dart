import 'package:fedi/app/instance/location/instance_location_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class IHashtagListBloc implements IInstanceLocationBloc {
  static IHashtagListBloc of(BuildContext context, {bool listen = true}) =>
      Provider.of<IHashtagListBloc>(context, listen: listen);
}
