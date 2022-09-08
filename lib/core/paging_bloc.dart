import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stream_paging/core/paging_state.dart';
import 'package:flutter_stream_paging/data_source/data_source.dart';
import 'package:flutter_stream_paging/model/paging_status.dart';

class PagingBloc<PageKeyType, ItemType>
    extends Cubit<PagingState<PageKeyType, ItemType>> {
  PagingBloc({required this.dataSource})
      : super(PagingState<PageKeyType, ItemType>.loading());

  final DataSource<PageKeyType, ItemType> dataSource;

  Future loadPage({PageKeyType? nextPageKey, bool isRefresh = false}) async {
    var items = state.maybeMap((value) => value.items, orElse: () => null);
    await dataSource.loadPage(isRefresh: isRefresh).then((value) {
      int? itemCount = isRefresh
          ? [...value].length
          : items != null
              ? [...items, ...value].length
              : [...value].length;

      bool hasNextPage = dataSource.currentKey != null;

      bool hasItems = itemCount != null && itemCount > 0;

      bool isListingUnfinished = hasItems && hasNextPage;

      bool isOngoing = isListingUnfinished;

      bool isCompleted = hasItems && !hasNextPage;

      /// The current pagination status.
      PagingStatus status = (isOngoing)
          ? PagingStatus.ongoing
          : (isCompleted)
              ? PagingStatus.completed
              : PagingStatus.noItemsFound;

      emit(PagingState<PageKeyType, ItemType>(
          nextPageKey,
          isRefresh
              ? [...value]
              : items != null
                  ? [...items, ...value]
                  : [...value],
          status,
          false));
    }, onError: (e) => emit(PagingState<PageKeyType, ItemType>.error(e)));
  }

  void requestNextPage({bool hasRequestNextPage = true}) {
    state.maybeMap(
        (value) => emit(PagingState<PageKeyType, ItemType>(
            value.nextPageKey, value.items, value.status, hasRequestNextPage)),
        orElse: () => null);
  }
}
