import 'package:fedi/app/toast/toast_model.dart';
import 'package:fedi/app/toast/toast_service.dart';
import 'package:fedi/app/toast/toast_widget.dart';
import 'package:fedi/disposable/disposable_owner.dart';
import 'package:fedi/overlay_notification/overlay_notification_service.dart';
import 'package:flutter/widgets.dart';

class ToastService extends DisposableOwner implements IToastService {
  final IOverlayNotificationService overlayNotificationService;

  ToastService({
    @required this.overlayNotificationService,
  });

  @override
  void showErrorToast({
    @required BuildContext context,
    @required String title,
    bool titleAutoFontSize = true,
    String content,
    VoidCallback onClick,
    Duration duration = const Duration(seconds: 2, milliseconds: 500),
  }) {
    assert(title != null);
    overlayNotificationService.showNotification(
      child: ToastWidget(
        toastType: ToastType.error,
        title: title,
        content: content,
        titleAutoFontSize: titleAutoFontSize,
        onClick: onClick,
      ),
      slideDismissible: true,
      key: ValueKey(title),
      duration: duration,
    );
  }

  @override
  void showInfoToast({
    @required BuildContext context,
    @required String title,
    bool titleAutoFontSize = true,
    String content,
    VoidCallback onClick,
    Duration duration = const Duration(seconds: 1, milliseconds: 500),
  }) {
    assert(title != null);
    overlayNotificationService.showNotification(
      child: ToastWidget(
        toastType: ToastType.info,
        title: title,
        content: content,
        titleAutoFontSize: titleAutoFontSize,
        onClick: onClick,
      ),
      slideDismissible: true,
      key: ValueKey(title),
      duration: duration,
    );
  }
}