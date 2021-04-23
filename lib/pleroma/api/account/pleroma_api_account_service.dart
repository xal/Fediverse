import 'package:fedi/pleroma/api/account/pleroma_api_account_model.dart';
import 'package:fedi/pleroma/api/pleroma_api_api_service.dart';
import 'package:fedi/pleroma/api/pagination/pleroma_api_pagination_model.dart';
import 'package:fedi/pleroma/api/status/pleroma_api_status_model.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class IPleromaAccountService extends IPleromaApi {
  static IPleromaAccountService of(
    BuildContext context, {
    bool listen = true,
  }) =>
      Provider.of<IPleromaAccountService>(context, listen: listen);

  Future<List<IPleromaAccount>> getAccountFollowings({
    required String accountRemoteId,
    IPleromaPaginationRequest? pagination,
  });

  Future<List<IPleromaAccount>> getAccountFollowers({
    required String accountRemoteId,
    IPleromaPaginationRequest? pagination,
  });

  Future<List<IPleromaStatus>> getAccountStatuses({
    required String accountRemoteId,
    String? tagged,
    bool? pinned,
    bool? excludeReplies,
    bool? excludeReblogs,
    List<String>? excludeVisibilities,
    bool? withMuted,
    bool? onlyWithMedia,
    IPleromaPaginationRequest? pagination,
  });

  Future<List<IPleromaStatus>> getAccountFavouritedStatuses({
    required String accountRemoteId,
    IPleromaPaginationRequest? pagination,
  });

  Future<IPleromaAccount> getAccount({
    required String accountRemoteId,
  });
}