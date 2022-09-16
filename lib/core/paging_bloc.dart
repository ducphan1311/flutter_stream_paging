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

      bool hasNextPage = dataSource.currentKey != null && !dataSource.isEndList;

      bool hasItems =  itemCount > 0;

      bool isListingUnfinished = hasItems && hasNextPage;

      bool isOngoing = isListingUnfinished;

      bool isCompleted = hasItems && !hasNextPage;

      /// The current pagination status.
      PagingStatus status = (isOngoing)
          ? PagingStatus.ongoing
          : PagingStatus.completed;

      emit(PagingState<PageKeyType, ItemType>(
          isRefresh
              ? [...value]
              : items != null
                  ? [...items, ...value]
                  : [...value],
          status,
          false));
    }, onError: (e) {
      if (dataSource.currentKey == null) {
        emit(PagingState<PageKeyType, ItemType>.error(e));
      } else {
        state.maybeMap(
                (value) => emit(PagingState<PageKeyType, ItemType>(
                value.items, PagingStatus.noItemsFound, true)),
            orElse: () => null);
      }
    });
  }

  void copyWith(ItemType newItem, int index) {
    state.maybeMap((value) {
      var items = [...value.items];
      items[index] = newItem;
      emit(PagingStateData(items, value.status, value.hasRequestNextPage));
    }, orElse: () => null);
  }

  void requestNextPage({bool hasRequestNextPage = true}) {
    state.maybeMap(
        (value) => emit(PagingState<PageKeyType, ItemType>(
            value.items, value.status, hasRequestNextPage)),
        orElse: () => null);
  }
}
