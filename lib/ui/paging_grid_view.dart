import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_bloc/flutter_bloc.dart';
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
    this.newPageErrorIndicatorBuilder, this.newPageCompletedIndicatorBuilder, this.newPageProgressIndicatorBuilder,
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

  @override
  State<PagingGridView<PageKeyType, ItemType>> createState() =>
      _PagingGridViewState<PageKeyType, ItemType>();
}

class _PagingGridViewState<PageKeyType, ItemType>
    extends State<PagingGridView<PageKeyType, ItemType>> {
  late PagingBloc<PageKeyType, ItemType> _pagingBloc;

  @override
  void initState() {
    super.initState();
    _pagingBloc =
        PagingBloc<PageKeyType, ItemType>(dataSource: widget.pageDataSource)
          ..loadPage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PagingBloc<PageKeyType, ItemType>>.value(
      value: _pagingBloc,
      child: BlocBuilder<PagingBloc<PageKeyType, ItemType>,
          PagingState<PageKeyType, ItemType>>(
        builder: (context, state) {
          return state.when((items, status, hasRequestNextPage) {
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
                    itemCount: items.length,),
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
                    itemCount: items.length,),
                itemCount: items.length,
                appendixBuilder: (_) => (widget.newPageProgressIndicatorBuilder != null)
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
                  itemCount: items.length,),
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
            );
          },
              loading: () => (widget.loadingBuilder != null)
                  ? widget.loadingBuilder!(context)
                  : const PagingDefaultLoading(),
              error: (error) => widget.errorBuilder != null
                  ? widget.errorBuilder!(context, error)
                  : ErrorWidget(error));
        },
      ),
    );
  }

  Widget _buildListItemWidget(
      {required BuildContext context,
      required int index,
      required List<ItemType> itemList,
      required int itemCount}) {
    var hasRequestedNextPage = context
        .watch<PagingBloc<PageKeyType, ItemType>>()
        .state
        .maybeMap((value) => value.hasRequestNextPage, orElse: () => false);
    if (!hasRequestedNextPage) {
      final newPageRequestTriggerIndex = max(0, itemCount - widget.invisibleItemsThreshold);

      final isBuildingTriggerIndexItem = index == newPageRequestTriggerIndex;

      if (!_pagingBloc.dataSource.isEndList && isBuildingTriggerIndexItem) {
        // Schedules the request for the end of this frame.
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _pagingBloc.loadPage();
          // _pagingController.notifyPageRequestListeners(_nextKey!);
        });
        _pagingBloc.requestNextPage();
      }
    }

    final item = itemList[index];
    return widget.builderDelegate.itemBuilder(context, item, index, (newItem){
      _pagingBloc.copyWith(newItem, index);
    });
  }

  WidgetBuilder _defaultRefreshBuilder(BuildContext context) {
    return (context) => CupertinoSliverRefreshControl(
          refreshTriggerPullDistance: 100.0,
          refreshIndicatorExtent: 60.0,
          onRefresh: () async {
            await _pagingBloc.loadPage(isRefresh: true);
          },
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
