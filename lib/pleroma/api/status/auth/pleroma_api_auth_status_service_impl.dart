import 'package:fedi/pleroma/api/account/pleroma_api_account_model.dart';
import 'package:fedi/pleroma/api/pagination/pleroma_api_pagination_model.dart';
import 'package:fedi/pleroma/api/rest/auth/pleroma_api_auth_rest_service.dart';
import 'package:fedi/pleroma/api/status/auth/pleroma_api_auth_status_service.dart';
import 'package:fedi/pleroma/api/status/pleroma_api_status_model.dart';
import 'package:fedi/pleroma/api/status/pleroma_api_status_service_impl.dart';
import 'package:fedi/rest/rest_request_model.dart';
import 'package:path/path.dart';

class PleromaAuthStatusService extends PleromaStatusService
    implements IPleromaAuthStatusService {
  final IPleromaAuthRestService authRestService;

  @override
  bool get isPleroma => authRestService.isPleroma;

  PleromaAuthStatusService({
    required this.authRestService,
  }) : super(
          restService: authRestService,
        );

  @override
  Future deleteStatus({
    required String statusRemoteId,
  }) async {
    await restService.sendHttpRequest(
      RestRequest.delete(
        relativePath: join(statusRelativeUrlPath, statusRemoteId),
      ),
    );
  }

  @override
  Future<IPleromaStatus> muteStatus({
    required String statusRemoteId,
    required int? expireDurationInSeconds,
  }) async {
    var bodyJson = <String, dynamic>{};
    if (expireDurationInSeconds != null) {
      assert(isPleroma, "expireDurationInSeconds supported only on Pleroma");
      bodyJson["expire_in"] = expireDurationInSeconds;
    }

    var request = RestRequest.post(
      relativePath: join(
        statusRelativeUrlPath,
        statusRemoteId,
        "mute",
      ),
      bodyJson: bodyJson,
    );
    var httpResponse = await restService.sendHttpRequest(request);

    return parseStatusResponse(httpResponse);
  }

  @override
  Future<IPleromaStatus> unMuteStatus({
    required String statusRemoteId,
  }) async {
    var request = RestRequest.post(
      relativePath: join(
        statusRelativeUrlPath,
        statusRemoteId,
        "unmute",
      ),
    );
    var httpResponse = await restService.sendHttpRequest(request);

    return parseStatusResponse(httpResponse);
  }

  @override
  Future<IPleromaStatus> pinStatus({
    required String statusRemoteId,
  }) async {
    var request = RestRequest.post(
      relativePath: join(
        statusRelativeUrlPath,
        statusRemoteId,
        "pin",
      ),
    );
    var httpResponse = await restService.sendHttpRequest(request);

    return parseStatusResponse(httpResponse);
  }

  @override
  Future<IPleromaStatus> unPinStatus({
    required String statusRemoteId,
  }) async {
    var request = RestRequest.post(
      relativePath: join(
        statusRelativeUrlPath,
        statusRemoteId,
        "unpin",
      ),
    );
    var httpResponse = await restService.sendHttpRequest(request);

    return parseStatusResponse(httpResponse);
  }

  @override
  Future<List<IPleromaAccount>> favouritedBy({
    required String statusRemoteId,
    IPleromaPaginationRequest? pagination,
  }) async {
    var request = RestRequest.get(
      queryArgs: pagination?.toQueryArgs(),
      relativePath: join(
        statusRelativeUrlPath,
        statusRemoteId,
        "favourited_by",
      ),
    );
    var httpResponse = await restService.sendHttpRequest(request);

    return parseAccountsResponse(httpResponse);
  }

  @override
  Future<List<IPleromaAccount>> rebloggedBy({
    required String statusRemoteId,
    IPleromaPaginationRequest? pagination,
  }) async {
    var request = RestRequest.get(
      queryArgs: pagination?.toQueryArgs(),
      relativePath: join(
        statusRelativeUrlPath,
        statusRemoteId,
        "reblogged_by",
      ),
    );
    var httpResponse = await restService.sendHttpRequest(request);

    return parseAccountsResponse(httpResponse);
  }

  @override
  Future<IPleromaStatus> reblogStatus({
    required String statusRemoteId,
  }) async {
    var request = RestRequest.post(
      relativePath: join(
        statusRelativeUrlPath,
        statusRemoteId,
        "reblog",
      ),
    );
    var httpResponse = await restService.sendHttpRequest(request);

    return parseStatusResponse(httpResponse);
  }

  @override
  Future<IPleromaStatus> unReblogStatus({
    required String statusRemoteId,
  }) async {
    var request = RestRequest.post(
      relativePath: join(
        statusRelativeUrlPath,
        statusRemoteId,
        "unreblog",
      ),
    );
    var httpResponse = await restService.sendHttpRequest(request);

    return parseStatusResponse(httpResponse);
  }

  @override
  Future<IPleromaStatus> favouriteStatus({
    required String statusRemoteId,
  }) async {
    var request = RestRequest.post(
      relativePath: join(
        statusRelativeUrlPath,
        statusRemoteId,
        "favourite",
      ),
    );
    var httpResponse = await restService.sendHttpRequest(request);

    return parseStatusResponse(httpResponse);
  }

  @override
  Future<IPleromaStatus> unFavouriteStatus({
    required String statusRemoteId,
  }) async {
    var request = RestRequest.post(
      relativePath: join(
        statusRelativeUrlPath,
        statusRemoteId,
        "unfavourite",
      ),
    );
    var httpResponse = await restService.sendHttpRequest(request);

    return parseStatusResponse(httpResponse);
  }

  @override
  Future<IPleromaStatus> bookmarkStatus({
    required String statusRemoteId,
  }) async {
    var request = RestRequest.post(
      relativePath: join(
        statusRelativeUrlPath,
        statusRemoteId,
        "bookmark",
      ),
    );
    var httpResponse = await restService.sendHttpRequest(request);

    return parseStatusResponse(httpResponse);
  }

  @override
  Future<IPleromaStatus> unBookmarkStatus({
    required String statusRemoteId,
  }) async {
    var request = RestRequest.post(
      relativePath: join(
        statusRelativeUrlPath,
        statusRemoteId,
        "unbookmark",
      ),
    );
    var httpResponse = await restService.sendHttpRequest(request);

    return parseStatusResponse(httpResponse);
  }

  @override
  Future<IPleromaStatus> postStatus({
    required IPleromaPostStatus data,
  }) async {
    var json = data.toJson();

    var request = RestRequest.post(
      relativePath: statusRelativeUrlPath,
      headers: {
        if (data.idempotencyKey?.isNotEmpty == true)
          "Idempotency-Key": data.idempotencyKey!,
      },
      bodyJson: json,
    );

    var httpResponse = await restService.sendHttpRequest(request);

    return parseStatusResponse(httpResponse);
  }

  @override
  Future<IPleromaScheduledStatus> scheduleStatus({
    required IPleromaScheduleStatus data,
  }) async {
    var json = data.toJson();

    var request = RestRequest.post(
      relativePath: statusRelativeUrlPath,
      bodyJson: json,
    );

    var httpResponse = await restService.sendHttpRequest(request);

    return parseScheduledStatusResponse(httpResponse);
  }

  @override
  bool get isMastodon => authRestService.isMastodon;
}