import 'dart:async';

import 'package:async/async.dart';
import 'package:tuple/tuple.dart';

abstract class DataSource<PageKeyType, ItemType> {
  CancelableOperation<Tuple2<List<ItemType>, PageKeyType>>? _cancelableOperation;

  Future<Tuple2<List<ItemType>, PageKeyType>> loadInitial(int pageSize);

  Future<Tuple2<List<ItemType>, PageKeyType>> loadPageAfter(
      PageKeyType params, int pageSize);

  /// Request load page for Data Source
  Future<List<ItemType>> loadPage({bool isRefresh = false}) async {
    if (currentKey == null || isRefresh) {
      if (_cancelableOperation != null && !_cancelableOperation!.isCompleted) {
        _cancelableOperation!.cancel();
      }
      _cancelableOperation = CancelableOperation.fromFuture(loadInitial(pageSize));
      final results = await _cancelableOperation!.valueOrCancellation();
      isEndList = ((results?.item1.length??0) < pageSize);
      currentKey = results?.item2;
      return results?.item1??[];
    } else {
      _cancelableOperation =  CancelableOperation.fromFuture(loadPageAfter(currentKey!, pageSize));
      final results = await _cancelableOperation!.valueOrCancellation();
      // final results = await loadPageAfter(currentKey as PageKeyType, pageSize);
      currentKey = results?.item2;
      isEndList = ((results?.item1.length??0) < pageSize);
      return results?.item1??[];
    }
  }

  PageKeyType? currentKey;

  /// true when your list is don't have any data for next request.
  bool isEndList;

  final int pageSize;

  DataSource({this.isEndList = false, this.pageSize = kDefaultPageSize});
}

const kDefaultPageSize = 20;
