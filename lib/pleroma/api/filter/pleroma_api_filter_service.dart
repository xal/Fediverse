import 'package:fedi/pleroma/api/pleroma_api_api_service.dart';
import 'package:fedi/pleroma/api/filter/pleroma_api_filter_model.dart';
import 'package:fedi/pleroma/api/pagination/pleroma_api_pagination_model.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class IPleromaFilterService extends IPleromaApi {
  static IPleromaFilterService of(BuildContext context, {bool listen = true}) =>
      Provider.of<IPleromaFilterService>(context, listen: listen);

  Future<List<IPleromaFilter>> getFilters({
    IPleromaPaginationRequest? pagination,
  });

  Future<IPleromaFilter> getFilter({
    required String? filterRemoteId,
  });

  Future deleteFilter({
    required String? filterRemoteId,
  });

  Future<IPleromaFilter> createFilter({
    required IPostPleromaFilter postPleromaFilter,
  });

  Future<IPleromaFilter> updateFilter({
    required String? filterRemoteId,
    required IPostPleromaFilter postPleromaFilter,
  });
}