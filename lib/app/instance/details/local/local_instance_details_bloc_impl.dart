import 'package:fedi/app/auth/instance/current/current_auth_instance_bloc.dart';
import 'package:fedi/app/instance/details/instance_details_bloc.dart';
import 'package:fedi/app/instance/details/instance_details_bloc_impl.dart';
import 'package:fedi/app/instance/details/instance_details_bloc_proxy_provider.dart';
import 'package:fedi/app/instance/location/instance_location_model.dart';
import 'package:fedi/disposable/disposable_provider.dart';
import 'package:fedi/pleroma/instance/pleroma_instance_model.dart';
import 'package:fedi/pleroma/instance/pleroma_instance_service.dart';
import 'package:flutter/widgets.dart';

class LocalInstanceDetailsBloc extends InstanceDetailsBloc
    implements IInstanceDetailsBloc {
  @override
  final IPleromaInstanceService pleromaInstanceService;

  LocalInstanceDetailsBloc({
    required IPleromaInstance? initialInstance,
    required this.pleromaInstanceService,
  }) : super(
          instanceUri: pleromaInstanceService.restService.baseUri,
          initialInstance: initialInstance,
        );

  static LocalInstanceDetailsBloc createFromContext(BuildContext context) {
    var pleromaInstanceService =
        IPleromaInstanceService.of(context, listen: false);
    var currentAuthInstanceBloc =
        ICurrentAuthInstanceBloc.of(context, listen: false);
    return LocalInstanceDetailsBloc(
      pleromaInstanceService: pleromaInstanceService,
      initialInstance: currentAuthInstanceBloc.currentInstance!.info,
    );
  }

  static Widget provideToContext(
    BuildContext context, {
    required Widget child,
  }) {
    return DisposableProvider<IInstanceDetailsBloc>(
      create: (context) => LocalInstanceDetailsBloc.createFromContext(context),
      child: InstanceDetailsBlocProxyProvider(child: child),
    );
  }

  @override
  // ignore: no-empty-block
  Future internalAsyncInit() async {
    // nothing here
  }

  @override
  InstanceLocation get instanceLocation => InstanceLocation.local;

  @override
  Uri? get remoteInstanceUriOrNull => null;


}
