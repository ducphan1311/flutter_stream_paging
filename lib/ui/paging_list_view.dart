import 'dart:io';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    super.key,
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
    required super.builderDelegate,
    required super.pageDataSource,
    super.emptyBuilder,
    super.loadingBuilder,
    super.errorBuilder,
    super.refreshBuilder,
  })  : _separatorBuilder = null;

  const PagingListView.separated({
    super.key,
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
    required super.builderDelegate,
    required super.pageDataSource,
    super.emptyBuilder,
    super.loadingBuilder,
    super.errorBuilder,
    super.refreshBuilder,
  })  : _separatorBuilder = separatorBuilder;

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
  late final ScrollController _scrollController;
  // Thêm một Map để lưu trữ các key cho các item
  final Map<int, GlobalKey> _itemKeys = {};
  double _previousScrollOffset = 0;

  // Cập nhật getter data để sử dụng pattern matching
  List<ItemType> get data {
    if (_pagingState is PagingStateData<PageKeyType, ItemType>) {
      return (_pagingState as PagingStateData<PageKeyType, ItemType>).items;
    }
    return <ItemType>[];
  }
  
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
    
    // Cập nhật để sử dụng pattern matching
    List<ItemType>? items;
    if (_pagingState is PagingStateData<PageKeyType, ItemType>) {
      items = (_pagingState as PagingStateData<PageKeyType, ItemType>).items;
    }
    
    cancelableOperation = CancelableOperation.fromFuture(
        dataSource.loadPage(isRefresh: isRefresh, newKey: nextPageKey));
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

      // bool isCompleted = hasItems && !hasNextPage;

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
        // Cập nhật để sử dụng pattern matching
        if (_pagingState is PagingStateData<PageKeyType, ItemType>) {
          final stateData = _pagingState as PagingStateData<PageKeyType, ItemType>;
          emit(PagingState<PageKeyType, ItemType>(
              stateData.items, PagingStatus.noItemsFound, true));
        }
      }
    });
  }

  void copyWith(ItemType newItem, int index) {
    // Cập nhật để sử dụng pattern matching
    if (_pagingState is PagingStateData<PageKeyType, ItemType>) {
      final value = _pagingState as PagingStateData<PageKeyType, ItemType>;
      var items = [...value.items];
      items[index] = newItem;
      emit(PagingStateData(items, value.status, value.hasRequestNextPage));
    }
  }

  void addItem(ItemType newItem) {
    if (_pagingState is PagingStateData<PageKeyType, ItemType>) {
      final value = _pagingState as PagingStateData<PageKeyType, ItemType>;

      if (widget.reverse && _scrollController.hasClients) {
        _previousScrollOffset = _scrollController.position.pixels;
        final beforeExtent = _scrollController.position.maxScrollExtent;

        // Thêm item mới vào đầu danh sách
        var items = [newItem, ...value.items];
        emit(PagingStateData(items, value.status, value.hasRequestNextPage));

        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            final afterExtent = _scrollController.position.maxScrollExtent;
            final itemSize = afterExtent - beforeExtent;

            if (itemSize > 0) {
              // Điều chỉnh vị trí cuộn dựa trên kích thước thực của viewport
              final adjustedOffset = _previousScrollOffset + itemSize;
              _scrollController.jumpTo(adjustedOffset);
            }
          }
        });
      } else {
        var items = [newItem, ...value.items];
        emit(PagingStateData(items, value.status, value.hasRequestNextPage));
      }
    }
  }

  void deleteItem(int index) {
    // Cập nhật để sử dụng pattern matching
    if (_pagingState is PagingStateData<PageKeyType, ItemType>) {
      final value = _pagingState as PagingStateData<PageKeyType, ItemType>;
      var items = [...value.items];
      items.removeWhere((element) => items.indexOf(element) == index);
      emit(PagingStateData(items, value.status, value.hasRequestNextPage));
    }
  }

  void requestNextPage({bool hasRequestNextPage = true}) {
    // Cập nhật để sử dụng pattern matching
    if (_pagingState is PagingStateData<PageKeyType, ItemType>) {
      final value = _pagingState as PagingStateData<PageKeyType, ItemType>;
      emit(PagingState<PageKeyType, ItemType>(
          value.items, value.status, hasRequestNextPage));
    }
  }

  @override
  void initState() {
    super.initState();
    dataSource = widget.pageDataSource;
    _scrollController = widget.controller ?? ScrollController();
    loadPage();
  }

  @override
  void didUpdateWidget(covariant PagingListView<PageKeyType, ItemType> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Kiểm tra sau khi widget đã được cập nhật
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _adjustScrollPositionAfterAddingItem();
    // });
  }

  @override
  void dispose() {
    cancelableOperation?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cập nhật để sử dụng pattern matching
    Widget child;
    
    switch (_pagingState) {
      case PagingStateData(items: final items, status: final status):
        child = widget.addItemBuilder != null
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
        break;
        
      case PagingStateLoading():
        child = (widget.loadingBuilder != null)
            ? widget.loadingBuilder!(context)
            : const PagingDefaultLoading();
        break;
        
      case PagingStateError():
        final error = (_pagingState as PagingStateError).error;
        child = widget.errorBuilder != null
            ? widget.errorBuilder!(context, error)
            : PagingDefaultErrorWidget(
                errorMessage: error,
                onPressed: () async {
                  await loadPage(isRefresh: true);
                },
              );
        break;
        
      default:
        child = SizedBox();
    }
    
    if (Platform.isAndroid && !widget.reverse) {
      return RefreshIndicator(
          child: child,
          onRefresh: () async {
            return await loadPage(isRefresh: true);
          });
    } else {
      return child;
    }
  }

  Widget _buildListItemWidget({
    required BuildContext context,
    required int index,
    required List<ItemType> itemList,
    required int itemCount,
  }) {
    // Cập nhật để sử dụng pattern matching
    bool hasRequestedNextPage = false;
    if (_pagingState is PagingStateData<PageKeyType, ItemType>) {
      hasRequestedNextPage = (_pagingState as PagingStateData<PageKeyType, ItemType>).hasRequestNextPage;
    }
    
    if (!hasRequestedNextPage) {
      final newPageRequestTriggerIndex =
          max(0, itemCount - widget.invisibleItemsThreshold);

      final isBuildingTriggerIndexItem = index == newPageRequestTriggerIndex;

      if (!dataSource.isEndList && isBuildingTriggerIndexItem) {
        // Schedules the request for the end of this frame.
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          requestNextPage();
          await loadPage();
          // _pagingController.notifyPageRequestListeners(_nextKey!);
        });
      }
    }

    final item = itemList[index];

    // Tạo key cho item nếu chưa có
    if (!_itemKeys.containsKey(index)) {
      _itemKeys[index] = GlobalKey();
    }

    // Sử dụng key cho item
    return KeyedSubtree(
      key: _itemKeys[index],
      child: widget.builderDelegate.itemBuilder(context, item, index, (newItem) {
        copyWith(newItem, index);
      }, () => deleteItem(index), itemList),
    );
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
    return items.isNotEmpty
        ? PagingSilverBuilder<PageKeyType, ItemType>(
            builderDelegate: widget.builderDelegate,
            padding: widget.padding,
            scrollDirection: widget.scrollDirection,
            reverse: widget.reverse,
            controller: _scrollController,
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
              separatorBuilder: (context, index) =>
                  widget._separatorBuilder != null
                      ? widget._separatorBuilder!(
                          context, index, items[index], items)
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
              statusIndicatorBuilder: (_) => (widget
                          .newPageProgressIndicatorBuilder !=
                      null)
                  ? widget.newPageProgressIndicatorBuilder!(context, () async {
                      await loadPage();
                    })
                  : const NewPageProgressIndicator(),
              separatorBuilder: (context, index) =>
                  widget._separatorBuilder != null
                      ? widget._separatorBuilder!(
                          context, index, items[index], items)
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
              separatorBuilder: (context, index) =>
                  widget._separatorBuilder != null
                      ? widget._separatorBuilder!(
                          context, index, items[index], items)
                      : const SizedBox(),
            ),
            status: status,
            refreshBuilder: (_) => widget.isEnablePullToRefresh
                ? ((widget.refreshBuilder ?? _defaultRefreshBuilder(_))(_))
                : const SliverToBoxAdapter(),
          )
        : (widget.emptyBuilder != null
            ? widget.emptyBuilder!(context)
            : const SizedBox());
  }
}
