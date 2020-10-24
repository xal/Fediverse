import 'package:cached_network_image/cached_network_image.dart';
import 'package:fedi/app/account/account_bloc.dart';
import 'package:fedi/app/ui/fedi_icons.dart';
import 'package:fedi/app/ui/progress/fedi_circular_progress_indicator.dart';
import 'package:fedi/app/ui/theme/fedi_ui_theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AccountHeaderBackgroundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var accountBloc = IAccountBloc.of(context, listen: true);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return StreamBuilder<String>(
          stream: accountBloc.headerStream.distinct(),
          builder: (context, snapshot) {
            var header = snapshot.data;

            if (header == null) {
              return buildProgressWidget(context);
            }

            return CachedNetworkImage(
              imageUrl: header,
              width: constraints.maxWidth,
              memCacheWidth: constraints.maxWidth.toInt(),
              imageBuilder: (context, imageProvider) {
                return Stack(
                  children: [
                    Image(
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      image: imageProvider,
                    ),
                    buildDarkOverlayContainer(
                      context: context,
                      child: null,
                    ),
                  ],
                );
              },
              progressIndicatorBuilder: (context, url, progress) =>
                  buildProgressWidget(context),
              errorWidget: (context, url, error) => buildDarkOverlayContainer(
                context: context,
                child: Center(
                  child: Icon(
                    FediIcons.warning,
                    color: IFediUiColorTheme.of(context).error,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildProgressWidget(BuildContext context) {
    return buildDarkOverlayContainer(
      context: context,
      child: Center(
        child: FediCircularProgressIndicator(),
      ),
    );
  }

  Widget buildDarkOverlayContainer({
    @required BuildContext context,
    @required Widget child,
  }) =>
      Container(
        child: child,
        decoration: BoxDecoration(
            color: IFediUiColorTheme.of(context).imageDarkOverlay),
      );

  const AccountHeaderBackgroundWidget();
}
