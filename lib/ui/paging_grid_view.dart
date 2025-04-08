import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_stream_paging/fl_stream_paging.dart';
import 'package:sliver_tools/sliver_tools.dart';

class PagingGridView<PageKeyType, ItemType>
    extends BaseWidget<PageKeyType, ItemType> {
  static const path = '/paging_grid_view';
  const PagingGridView({
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
    this.showNewPageProgressIndicatorAsGridChild = true,
    this.showNewPageErrorIndicatorAsGridChild = true,
    this.showNoMoreItemsIndicatorAsGridChild = true,
    this.invisibleItemsThreshold = 3,
    this.newPageErrorIndicatorBuilder,
    this.newPageCompletedIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.addItemBuilder,
    required super.builderDelegate,
    required super.pageDataSource,
    required this.gridDelegate,
    super.emptyBuilder,
    super.loadingBuilder,
    super.errorBuilder,
    super.refreshBuilder,
  });

  final widgets.EdgeInsets padding;
  final Axis scrollDirection;
  final bool reverse;
  final bool isEnablePullToRefresh;
  final ScrollController? controller;
  final bool? primary;

  /// Corresponds to [GridView.gridDelegate].
  final SliverGridDelegate gridDelegate;

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

  /// Corresponds to [PagedSliverGrid.showNewPageProgressIndicatorAsGridChild].
  final bool showNewPageProgressIndicatorAsGridChild;

  /// Corresponds to [PagedSliverGrid.showNewPageErrorIndicatorAsGridChild].
  final bool showNewPageErrorIndicatorAsGridChild;

  /// Corresponds to [PagedSliverGrid.showNoMoreItemsIndicatorAsGridChild].
  final bool showNoMoreItemsIndicatorAsGridChild;

  final int invisibleItemsThreshold;

  final WidgetBuilder? newPageErrorIndicatorBuilder;
  final WidgetBuilder? newPageCompletedIndicatorBuilder;
  final WidgetBuilder? newPageProgressIndicatorBuilder;
  final AddItemWidgetBuilder<ItemType>? addItemBuilder;

  @override
  State<PagingGridView<PageKeyType, ItemType>> createState() =>
      PagingGridViewState<PageKeyType, ItemType>();
}

class PagingGridViewState<PageKeyType, ItemType>
    extends State<PagingGridView<PageKeyType, ItemType>> {
  PagingState<PageKeyType, ItemType> _pagingState = const PagingState.loading();
  late DataSource<PageKeyType, ItemType> dataSource;
  late final ScrollController _scrollController;

  List<ItemType> get data {
    if (_pagingState is PagingStateData<PageKeyType, ItemType>) {
      return (_pagingState as PagingStateData<PageKeyType, ItemType>).items;
    }
    return <ItemType>[];
  }

  Future loadPage({PageKeyType? nextPageKey, bool isRefresh = false}) async {
    List<ItemType>? items;
    
    if (_pagingState is PagingStateData<PageKeyType, ItemType>) {
      items = (_pagingState as PagingStateData<PageKeyType, ItemType>).items;
    }
    
    await dataSource.loadPage(isRefresh: isRefresh, newKey: nextPageKey).then(
        (value) {
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
        if (_pagingState is PagingStateData<PageKeyType, ItemType>) {
          final stateData = _pagingState as PagingStateData<PageKeyType, ItemType>;
          emit(PagingState<PageKeyType, ItemType>(
              stateData.items, PagingStatus.noItemsFound, true));
        }
      }
    });
  }

  void copyWith(ItemType newItem, int index) {
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

      // Lưu vị trí scroll hiện tại trước khi thêm item
      final scrollPosition = _scrollController.position;
      final currentOffset = scrollPosition.pixels ?? 0;

      var items = widget.reverse
          ? [...value.items, newItem]  // Thêm vào cuối nếu reverse
          : [newItem, ...value.items]; // Thêm vào đầu nếu không reverse

      emit(PagingStateData(items, value.status, value.hasRequestNextPage));

      // Nếu đang ở chế độ reverse, giữ nguyên vị trí scroll sau khi thêm item
      if (widget.reverse && scrollPosition.hasPixels) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollPosition.jumpTo(currentOffset);
        });
      }
    }
  }

  void deleteItem(int index) {
    if (_pagingState is PagingStateData<PageKeyType, ItemType>) {
      final value = _pagingState as PagingStateData<PageKeyType, ItemType>;
      var items = [...value.items];
      items.removeWhere((element) => items.indexOf(element) == index);
      emit(PagingStateData(items, value.status, value.hasRequestNextPage));
    }
  }

  void requestNextPage({bool hasRequestNextPage = true}) {
    if (_pagingState is PagingStateData<PageKeyType, ItemType>) {
      final value = _pagingState as PagingStateData<PageKeyType, ItemType>;
      emit(PagingState<PageKeyType, ItemType>(
          value.items, value.status, hasRequestNextPage));
    }
  }

  void emit(PagingState<PageKeyType, ItemType> state) {
    if (mounted) {
      setState(() {
        _pagingState = state;
      });
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
  Widget build(BuildContext context) {
    Widget child;

    // Thay thế when bằng pattern matching
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
            : ErrorWidget(error);
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

  Widget _buildListItemWidget(
      {required BuildContext context,
      required int index,
      required List<ItemType> itemList,
      required int itemCount}) {
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
        });
      }
    }

    final item = itemList[index];
    return widget.builderDelegate.itemBuilder(context, item, index, (newItem) {
      copyWith(newItem, index);
    }, () => deleteItem(index), itemList);
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
            completedListingBuilder: (_) => _AppendedSliverGrid(
              gridDelegate: widget.gridDelegate,
              itemBuilder: (context, index) => _buildListItemWidget(
                context: context,
                index: index,
                itemList: items,
                itemCount: items.length,
              ),
              itemCount: items.length,
              appendixBuilder: widget.newPageCompletedIndicatorBuilder,
              showAppendixAsGridChild:
                  widget.showNoMoreItemsIndicatorAsGridChild,
              addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
              addSemanticIndexes: widget.addSemanticIndexes,
              addRepaintBoundaries: widget.addRepaintBoundaries,
            ),
            loadingListingBuilder: (_) => _AppendedSliverGrid(
              gridDelegate: widget.gridDelegate,
              itemBuilder: (context, index) => _buildListItemWidget(
                context: context,
                index: index,
                itemList: items,
                itemCount: items.length,
              ),
              itemCount: items.length,
              appendixBuilder: (_) =>
                  (widget.newPageProgressIndicatorBuilder != null)
                      ? widget.newPageProgressIndicatorBuilder!(context)
                      : const NewPageProgressIndicator(),
              showAppendixAsGridChild:
                  widget.showNewPageProgressIndicatorAsGridChild,
              addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
              addSemanticIndexes: widget.addSemanticIndexes,
              addRepaintBoundaries: widget.addRepaintBoundaries,
            ),
            errorListingBuilder: (_) => _AppendedSliverGrid(
              gridDelegate: widget.gridDelegate,
              itemBuilder: (context, index) => _buildListItemWidget(
                context: context,
                index: index,
                itemList: items,
                itemCount: items.length,
              ),
              itemCount: items.length,
              appendixBuilder: widget.newPageErrorIndicatorBuilder,
              showAppendixAsGridChild:
                  widget.showNewPageProgressIndicatorAsGridChild,
              addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
              addSemanticIndexes: widget.addSemanticIndexes,
              addRepaintBoundaries: widget.addRepaintBoundaries,
            ),
            status: status,
            refreshBuilder: (_) => widget.isEnablePullToRefresh
                ? ((widget.refreshBuilder ?? _defaultRefreshBuilder(_))(_))
                : const SliverToBoxAdapter(),
          )
        : (widget.emptyBuilder != null
            ? widget.emptyBuilder!(context)
            : SizedBox());
  }
}

class _AppendedSliverGrid extends StatelessWidget {
  const _AppendedSliverGrid({
    required this.gridDelegate,
    required this.itemBuilder,
    required this.itemCount,
    this.showAppendixAsGridChild = true,
    this.appendixBuilder,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
  });

  final SliverGridDelegate gridDelegate;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final bool showAppendixAsGridChild;
  final WidgetBuilder? appendixBuilder;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  @override
  Widget build(BuildContext context) {
    if (showAppendixAsGridChild == true || appendixBuilder == null) {
      return SliverGrid(
        gridDelegate: gridDelegate,
        delegate: _buildSliverDelegate(
          appendixBuilder: appendixBuilder,
        ),
      );
    } else {
      return MultiSliver(children: [
        SliverGrid(
          gridDelegate: gridDelegate,
          delegate: _buildSliverDelegate(),
        ),
        SliverToBoxAdapter(
          child: appendixBuilder!(context),
        ),
      ]);
    }
  }

  SliverChildBuilderDelegate _buildSliverDelegate({
    WidgetBuilder? appendixBuilder,
  }) =>
      AppendedSliverChildBuilderDelegate(
        builder: itemBuilder,
        childCount: itemCount,
        appendixBuilder: appendixBuilder,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
      );
}
