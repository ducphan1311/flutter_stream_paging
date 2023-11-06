import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_stream_paging/fl_stream_paging.dart';

typedef NewPageWidgetBuilder = Widget Function(
  BuildContext context,
  Function()? onLoadMore,
);

typedef AddItemWidgetBuilder<ItemType> = Widget Function(
  BuildContext context,
  Function(ItemType newItem) onAddItem,
);

class PagingListView<PageKeyType, ItemType>
    extends BaseWidget<PageKeyType, ItemType> {
  const PagingListView({
    Key? key,
    this.isEnablePullToRefresh = true,
    this.padding = EdgeInsets.zero,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.addRepaintBoundaries = true,
    this.addAutomaticKeepAlives = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.semanticIndexCallback,
    this.itemExtent,
    this.invisibleItemsThreshold = 3,
    this.newPageErrorIndicatorBuilder,
    this.newPageCompletedIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.addItemBuilder,
    required PagedChildBuilderDelegate<ItemType> builderDelegate,
    required DataSource<PageKeyType, ItemType> pageDataSource,
    WidgetBuilder? emptyBuilder,
    WidgetBuilder? loadingBuilder,
    ErrorBuilder? errorBuilder,
    WidgetBuilder? refreshBuilder,
  })  : _separatorBuilder = null,
        super(
          builderDelegate: builderDelegate,
          emptyBuilder: emptyBuilder,
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
          pageDataSource: pageDataSource,
          refreshBuilder: refreshBuilder,
          key: key,
        );

  const PagingListView.separated({
    Key? key,
    this.isEnablePullToRefresh = true,
    this.padding = EdgeInsets.zero,
    required SeparatorBuilder<ItemType> separatorBuilder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.addRepaintBoundaries = true,
    this.addAutomaticKeepAlives = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.semanticIndexCallback,
    this.itemExtent,
    this.invisibleItemsThreshold = 3,
    this.newPageErrorIndicatorBuilder,
    this.newPageCompletedIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.addItemBuilder,
    required PagedChildBuilderDelegate<ItemType> builderDelegate,
    required DataSource<PageKeyType, ItemType> pageDataSource,
    WidgetBuilder? emptyBuilder,
    WidgetBuilder? loadingBuilder,
    ErrorBuilder? errorBuilder,
    WidgetBuilder? refreshBuilder,
  })  : _separatorBuilder = separatorBuilder,
        super(
          builderDelegate: builderDelegate,
          emptyBuilder: emptyBuilder,
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
          pageDataSource: pageDataSource,
          refreshBuilder: refreshBuilder,
          key: key,
        );

  final widgets.EdgeInsets padding;
  final SeparatorBuilder<ItemType>? _separatorBuilder;
  final Axis scrollDirection;
  final bool reverse;
  final bool isEnablePullToRefresh;
  final ScrollController? controller;
  final bool? primary;

  ///In Android pull to refresh only work
  /// if total height height  < height of screen => physics = [AlwaysScrollableScrollPhysics]
  /// if total height of item > height of screen => physics = [BouncingScrollPhysics] || [AlwaysScrollableScrollPhysics]
  /// default physics = [AlwaysScrollableScrollPhysics]
  final ScrollPhysics? physics;

  final bool shrinkWrap;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final SemanticIndexCallback? semanticIndexCallback;
  final double? itemExtent;
  final int invisibleItemsThreshold;
  final WidgetBuilder? newPageErrorIndicatorBuilder;
  final WidgetBuilder? newPageCompletedIndicatorBuilder;
  final NewPageWidgetBuilder? newPageProgressIndicatorBuilder;
  final AddItemWidgetBuilder<ItemType>? addItemBuilder;

  @override
  PagingListViewState<PageKeyType, ItemType> createState() =>
      PagingListViewState<PageKeyType, ItemType>();
}

class PagingListViewState<PageKeyType, ItemType>
    extends State<PagingListView<PageKeyType, ItemType>> {
  PagingState<PageKeyType, ItemType> _pagingState = const PagingState.loading();
  CancelableOperation? cancelableOperation;

  void emit(PagingState<PageKeyType, ItemType> state) {
    if (mounted) {
      setState(() {
        _pagingState = state;
      });
    }
  }

  late DataSource<PageKeyType, ItemType> dataSource;

  Future loadPage({PageKeyType? nextPageKey, bool isRefresh = false}) async {
    if (cancelableOperation != null && !cancelableOperation!.isCompleted) {
      cancelableOperation!.cancel();
    }
    var items =
        _pagingState.maybeMap((value) => value.items, orElse: () => null);
    cancelableOperation = CancelableOperation.fromFuture(
        dataSource.loadPage(isRefresh: isRefresh));
    cancelableOperation!.value.then((value) {
      int? itemCount = isRefresh
          ? [...value].length
          : items != null
              ? [...items, ...value].length
              : [...value].length;

      bool hasNextPage = dataSource.currentKey != null && !dataSource.isEndList;

      bool hasItems = itemCount > 0;

      bool isListingUnfinished = hasItems && hasNextPage;

      bool isOngoing = isListingUnfinished;

      bool isCompleted = hasItems && !hasNextPage;

      /// The current pagination status.
      PagingStatus status =
          (isOngoing) ? PagingStatus.ongoing : PagingStatus.completed;

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
        _pagingState.maybeMap(
            (value) => emit(PagingState<PageKeyType, ItemType>(
                value.items, PagingStatus.noItemsFound, true)),
            orElse: () => null);
      }
    });
    // await dataSource.loadPage(isRefresh: isRefresh).then((value) {
    //   int? itemCount = isRefresh
    //   ? [...value].length
    //       : items != null
    //   ? [...items, ...value].length
    //       : [...value].length;
    //
    //   bool hasNextPage = dataSource.currentKey != null && !dataSource.isEndList;
    //
    //   bool hasItems = itemCount > 0;
    //
    //   bool isListingUnfinished = hasItems && hasNextPage;
    //
    //   bool isOngoing = isListingUnfinished;
    //
    //   bool isCompleted = hasItems && !hasNextPage;
    //
    //   /// The current pagination status.
    //   PagingStatus status =
    //   (isOngoing) ? PagingStatus.ongoing : PagingStatus.completed;
    //
    //   emit(PagingState<PageKeyType, ItemType>(
    //   isRefresh
    //   ? [...value]
    //       : items != null
    //   ? [...items, ...value]
    //       : [...value],
    //   status,
    //   false));
    // }, onError: (e) {
    //   if (dataSource.currentKey == null) {
    //     emit(PagingState<PageKeyType, ItemType>.error(e));
    //   } else {
    //     _pagingState.maybeMap(
    //             (value) => emit(PagingState<PageKeyType, ItemType>(
    //             value.items, PagingStatus.noItemsFound, true)),
    //         orElse: () => null);
    //   }
    // });
  }

  void copyWith(ItemType newItem, int index) {
    _pagingState.maybeMap((value) {
      var items = [...value.items];
      items[index] = newItem;
      emit(PagingStateData(items, value.status, value.hasRequestNextPage));
    }, orElse: () => null);
  }

  void addItem(ItemType newItem) {
    _pagingState.maybeMap((value) {
      var items = [newItem, ...value.items];
      emit(PagingStateData(items, value.status, value.hasRequestNextPage));
    }, orElse: () => null);
  }

  void deleteItem(int index) {
    _pagingState.maybeMap((value) {
      var items = [...value.items];
      items.removeWhere((element) => items.indexOf(element) == index);
      emit(PagingStateData(items, value.status, value.hasRequestNextPage));
    }, orElse: () => null);
  }

  void requestNextPage({bool hasRequestNextPage = true}) {
    _pagingState.maybeMap(
        (value) => emit(PagingState<PageKeyType, ItemType>(
            value.items, value.status, hasRequestNextPage)),
        orElse: () => null);
  }

  @override
  void initState() {
    super.initState();
    dataSource = widget.pageDataSource;
    loadPage();
  }

  @override
  void didUpdateWidget(
      covariant PagingListView<PageKeyType, ItemType> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    cancelableOperation?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _pagingState.when((items, status, hasRequestNextPage) {
      return widget.addItemBuilder != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: _pagingSilverBuilder(items: items, status: status),
                ),
                widget.addItemBuilder!(context, (newItem) => addItem(newItem))
              ],
            )
          : _pagingSilverBuilder(items: items, status: status);
    },
        loading: () => (widget.loadingBuilder != null)
            ? widget.loadingBuilder!(context)
            : const PagingDefaultLoading(),
        error: (error) => widget.errorBuilder != null
            ? widget.errorBuilder!(context, error)
            : PagingDefaultErrorWidget(
                errorMessage: error,
                onPressed: () async {
                  await loadPage(isRefresh: true);
                },
              ));
  }

  Widget _buildListItemWidget({
    required BuildContext context,
    required int index,
    required List<ItemType> itemList,
    required int itemCount,
  }) {
    var hasRequestedNextPage = _pagingState
        .maybeMap((value) => value.hasRequestNextPage, orElse: () => false);
    if (!hasRequestedNextPage) {
      final newPageRequestTriggerIndex =
          max(0, itemCount - widget.invisibleItemsThreshold);

      final isBuildingTriggerIndexItem = index == newPageRequestTriggerIndex;

      if (!dataSource.isEndList && isBuildingTriggerIndexItem) {
        // Schedules the request for the end of this frame.
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          requestNextPage();
          print('requestNextPage:');
          await loadPage();
          // _pagingController.notifyPageRequestListeners(_nextKey!);
        });
      }
    }

    final item = itemList[index];
    return widget.builderDelegate.itemBuilder(context, item, index, (newItem) {
      copyWith(newItem, index);
    }, () => deleteItem(index), itemList);
  }

  SliverMultiBoxAdaptorWidget _buildSliverList(
    IndexedWidgetBuilder itemBuilder,
    int itemCount, {
    WidgetBuilder? statusIndicatorBuilder,
    IndexedWidgetBuilder? separatorBuilder,
  }) {
    final delegate = _buildSliverDelegate(
      itemBuilder,
      itemCount,
      statusIndicatorBuilder: statusIndicatorBuilder,
      separatorBuilder: separatorBuilder,
    );

    final itemExtent = widget.itemExtent;

    return (itemExtent == null || widget._separatorBuilder != null)
        ? SliverList(
            delegate: delegate,
          )
        : SliverFixedExtentList(
            delegate: delegate,
            itemExtent: itemExtent,
          );
  }

  SliverChildBuilderDelegate _buildSliverDelegate(
    IndexedWidgetBuilder itemBuilder,
    int itemCount, {
    WidgetBuilder? statusIndicatorBuilder,
    IndexedWidgetBuilder? separatorBuilder,
  }) {
    return separatorBuilder == null
        ? AppendedSliverChildBuilderDelegate(
            builder: itemBuilder,
            childCount: itemCount,
            appendixBuilder: statusIndicatorBuilder,
            addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
            addRepaintBoundaries: widget.addRepaintBoundaries,
            addSemanticIndexes: widget.addSemanticIndexes,
            semanticIndexCallback: widget.semanticIndexCallback,
          )
        : AppendedSliverChildBuilderDelegate.separated(
            builder: itemBuilder,
            childCount: itemCount,
            appendixBuilder: statusIndicatorBuilder,
            separatorBuilder: separatorBuilder,
            addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
            addRepaintBoundaries: widget.addRepaintBoundaries,
            addSemanticIndexes: widget.addSemanticIndexes,
          );
  }

  WidgetBuilder _defaultRefreshBuilder(BuildContext context) {
    return (context) => CupertinoSliverRefreshControl(
          refreshTriggerPullDistance: 100.0,
          refreshIndicatorExtent: 60.0,
          onRefresh: () async {
            await loadPage(isRefresh: true);
          },
        );
  }

  Widget _pagingSilverBuilder(
      {required List<ItemType> items, required PagingStatus status}) {
    return PagingSilverBuilder<PageKeyType, ItemType>(
      builderDelegate: widget.builderDelegate,
      padding: widget.padding,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addSemanticIndexes: widget.addSemanticIndexes,
      cacheExtent: widget.cacheExtent,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      completedListingBuilder: (_) => _buildSliverList(
        (context, index) => _buildListItemWidget(
          context: context,
          index: index,
          itemList: items,
          itemCount: items.length,
        ),
        items.length,
        statusIndicatorBuilder: widget.newPageCompletedIndicatorBuilder,
        separatorBuilder: (context, index) => widget._separatorBuilder != null
            ? widget._separatorBuilder!(context, index, items[index], items)
            : const SizedBox(),
      ),
      loadingListingBuilder: (_) => _buildSliverList(
        (context, index) => _buildListItemWidget(
          context: context,
          index: index,
          itemList: items,
          itemCount: items.length,
        ),
        items.length,
        statusIndicatorBuilder: (_) =>
            (widget.newPageProgressIndicatorBuilder != null)
                ? widget.newPageProgressIndicatorBuilder!(context, () async {
                    await loadPage();
                  })
                : const NewPageProgressIndicator(),
        separatorBuilder: (context, index) => widget._separatorBuilder != null
            ? widget._separatorBuilder!(context, index, items[index], items)
            : const SizedBox(),
      ),
      errorListingBuilder: (_) => _buildSliverList(
        (context, index) => _buildListItemWidget(
          context: context,
          index: index,
          itemList: items,
          itemCount: items.length,
        ),
        items.length,
        statusIndicatorBuilder: widget.newPageErrorIndicatorBuilder,
        separatorBuilder: (context, index) => widget._separatorBuilder != null
            ? widget._separatorBuilder!(context, index, items[index], items)
            : const SizedBox(),
      ),
      status: status,
      refreshBuilder: (_) => widget.isEnablePullToRefresh
          ? ((widget.refreshBuilder ?? _defaultRefreshBuilder(_))(_))
          : const SliverToBoxAdapter(),
    );
  }
}
