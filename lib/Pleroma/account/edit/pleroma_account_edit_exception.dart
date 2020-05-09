import 'package:fedi/Pleroma/rest/pleroma_rest_exception.dart';
import 'package:flutter/widgets.dart';

class PleromaAccountEditException extends PleromaRestException {
  PleromaAccountEditException({@required int statusCode, @required String body})
      : super(statusCode: statusCode, body: body);
}