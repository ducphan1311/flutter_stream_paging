import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_stream_paging/fl_stream_paging.dart';
import 'package:sliver_tools/sliver_tools.dart';

class PagingGridView<PageKeyType, ItemType>
    extends BaseWidget<PageKeyType, ItemType> {
  static const path = '/paging_grid_view';
  const PagingGridView({
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
    this.showNewPageProgressIndicatorAsGridChild = true,
    this.showNewPageErrorIndicatorAsGridChild = true,
    this.showNoMoreItemsIndicatorAsGridChild = true,
    this.invisibleItemsThreshold = 3,
    this.newPageErrorIndicatorBuilder,
    this.newPageCompletedIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.addItemBuilder,
    required PagedChildBuilderDelegate<ItemType> builderDelegate,
    required DataSource<PageKeyType, ItemType> pageDataSource,
    required this.gridDelegate,
    WidgetBuilder? emptyBuilder,
    WidgetBuilder? loadingBuilder,
    ErrorBuilder? errorBuilder,
    WidgetBuilder? refreshBuilder,
  }) : super(
          builderDelegate: builderDelegate,
          emptyBuilder: emptyBuilder,
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
          pageDataSource: pageDataSource,
          refreshBuilder: refreshBuilder,
          key: key,
        );

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
  final AddItemWidgetBuilder? addItemBuilder;

  @override
  State<PagingGridView<PageKeyType, ItemType>> createState() =>
      _PagingGridViewState<PageKeyType, ItemType>();
}

class _PagingGridViewState<PageKeyType, ItemType>
    extends State<PagingGridView<PageKeyType, ItemType>> {
  PagingState<PageKeyType, ItemType> _pagingState = const PagingState.loading();

  void emit(PagingState<PageKeyType, ItemType> state) {
    if (mounted) {
      setState(() {
        _pagingState = state;
      });
    }
  }

  late DataSource<PageKeyType, ItemType> dataSource;

  Future loadPage({PageKeyType? nextPageKey, bool isRefresh = false}) async {
    print('loadPage:grid');

    var items = _pagingState.maybeMap((value) => value.items, orElse: () => null);
    await dataSource.loadPage(isRefresh: isRefresh).then((value) {
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
      var items = [...value.items, newItem];
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
  Widget build(BuildContext context) {
    return _pagingState.when((items, status, hasRequestNextPage) {
      return widget.addItemBuilder != null
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child:
            _pagingSilverBuilder(items: items, status: status),
          ),
          if (widget.addItemBuilder != null)
            widget.addItemBuilder!(
                context, (newItem) => addItem(newItem))
        ],
      )
          : _pagingSilverBuilder(items: items, status: status);
    },
        loading: () => (widget.loadingBuilder != null)
            ? widget.loadingBuilder!(context)
            : const PagingDefaultLoading(),
        error: (error) => widget.errorBuilder != null
            ? widget.errorBuilder!(context, error)
            : ErrorWidget(error));
  }

  Widget _buildListItemWidget(
      {required BuildContext context,
      required int index,
      required List<ItemType> itemList,
      required int itemCount}) {
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
          await loadPage();
          // _pagingController.notifyPageRequestListeners(_nextKey!);
        });
      }
    }

    final item = itemList[index];
    return widget.builderDelegate.itemBuilder(context, item, index, (newItem) {
      copyWith(newItem, index);
    }, () => deleteItem(index));
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
        showAppendixAsGridChild: widget.showNoMoreItemsIndicatorAsGridChild,
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
        appendixBuilder: (_) => (widget.newPageProgressIndicatorBuilder != null)
            ? widget.newPageProgressIndicatorBuilder!(context)
            : const NewPageProgressIndicator(),
        showAppendixAsGridChild: widget.showNewPageProgressIndicatorAsGridChild,
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
        showAppendixAsGridChild: widget.showNewPageProgressIndicatorAsGridChild,
        addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
        addSemanticIndexes: widget.addSemanticIndexes,
        addRepaintBoundaries: widget.addRepaintBoundaries,
      ),
      status: status,
      refreshBuilder: (_) => widget.isEnablePullToRefresh
          ? ((widget.refreshBuilder ?? _defaultRefreshBuilder(_))(_))
          : const SliverToBoxAdapter(),
    );
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
    Key? key,
  }) : super(key: key);

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
