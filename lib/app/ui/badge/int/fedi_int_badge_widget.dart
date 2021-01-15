import 'package:fedi/app/ui/badge/int/fedi_int_badge_bloc.dart';
import 'package:fedi/app/ui/theme/fedi_ui_theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FediIntBadgeWidget extends StatelessWidget {
  final Widget child;
  final double offset;

  static const badgeSize = 16.0;
  static const badgeDefaultOffset = 8.0;

  const FediIntBadgeWidget({
    @required this.child,
    this.offset = badgeDefaultOffset,
  });

  @override
  Widget build(BuildContext context) {
    var fediIntBadgeBloc = IFediIntBadgeBloc.of(context);

    return StreamBuilder<int>(
      stream: fediIntBadgeBloc.badgeStream.distinct(),
      builder: (context, snapshot) {
        var count = snapshot.data ?? 0;

        if (count > 0) {
          return Stack(
            children: [
              child,
              Positioned(
                right: offset,
                top: offset,
                child: Container(
                  width: badgeSize,
                  height: badgeSize,
                  decoration: BoxDecoration(
                    color: IFediUiColorTheme.of(context).secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "$count",
                      style: IFediUiTextTheme.of(context).smallWhite,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return child;
        }
      },
    );
  }
}
