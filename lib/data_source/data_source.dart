import 'dart:async';

import 'package:tuple/tuple.dart';

abstract class DataSource<PageKeyType, ItemType> {
  FutureOr<Tuple2<List<ItemType>, PageKeyType>> loadInitial(int pageSize);

  FutureOr<Tuple2<List<ItemType>, PageKeyType>> loadPageAfter(
      PageKeyType params, int pageSize);

  /// Request load page for Data Source
  Future<List<ItemType>> loadPage({bool isRefresh = false}) async {
    if (currentKey == null || isRefresh) {
      final results = await loadInitial(pageSize);
      isEndList = (results.item1.length < pageSize);
      currentKey = results.item2;
      return results.item1;
    } else {
      final results = await loadPageAfter(currentKey as PageKeyType, pageSize);
      currentKey = results.item2;
      isEndList = (results.item1.length < pageSize);
      return results.item1;
    }
  }

  PageKeyType? currentKey;

  /// true when your list is don't have any data for next request.
  bool isEndList;

  final int pageSize;

  DataSource({this.isEndList = false, this.pageSize = kDefaultPageSize});
}

const kDefaultPageSize = 20;
