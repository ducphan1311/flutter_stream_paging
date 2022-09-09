import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_stream_paging/core/paging_bloc.dart';
import 'package:flutter_stream_paging/core/paging_state.dart';
import 'package:flutter_stream_paging/data_source/data_source.dart';
import 'package:flutter_stream_paging/ui/base_widget.dart';
import 'package:flutter_stream_paging/ui/paging_silver_builder.dart';
import 'package:flutter_stream_paging/ui/widgets/new_page_progress_indicator.dart';
import 'package:flutter_stream_paging/ui/widgets/paging_default_error_widget.dart';
import 'package:flutter_stream_paging/ui/widgets/paging_default_loading.dart';
import 'package:flutter_stream_paging/utils/appended_sliver_child_builder_delegate.dart';
import 'package:flutter_stream_paging/utils/paged_child_builder_delegate.dart';

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
    required IndexedWidgetBuilder separatorBuilder,
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
  final IndexedWidgetBuilder? _separatorBuilder;
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
  final WidgetBuilder? newPageProgressIndicatorBuilder;

  @override
  PagingListViewState<PageKeyType, ItemType> createState() =>
      PagingListViewState<PageKeyType, ItemType>();
}

class PagingListViewState<PageKeyType, ItemType>
    extends State<PagingListView<PageKeyType, ItemType>> {
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
              completedListingBuilder: (_) => _buildSliverList(
                (context, index) => _buildListItemWidget(
                  context: context,
                  index: index,
                  itemList: items,
                  itemCount: items.length,
                ),
                items.length,
                statusIndicatorBuilder: widget.newPageCompletedIndicatorBuilder,
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
                        ? widget.newPageProgressIndicatorBuilder!(context)
                        : const NewPageProgressIndicator(),
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
                  : PagingDefaultErrorWidget(
                      errorMessage: error,
                      onPressed: () async {
                        await _pagingBloc.loadPage(isRefresh: true);
                      },
                    ));
        },
      ),
    );
  }

  Widget _buildListItemWidget({
    required BuildContext context,
    required int index,
    required List<ItemType> itemList,
    required int itemCount,
  }) {
    var hasRequestedNextPage = context
        .watch<PagingBloc<PageKeyType, ItemType>>()
        .state
        .maybeMap((value) => value.hasRequestNextPage, orElse: () => false);
    if (!hasRequestedNextPage) {
      final newPageRequestTriggerIndex =
          max(0, itemCount - widget.invisibleItemsThreshold);

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
    return widget.builderDelegate.itemBuilder(context, item, index);
  }

  SliverMultiBoxAdaptorWidget _buildSliverList(
    IndexedWidgetBuilder itemBuilder,
    int itemCount, {
    WidgetBuilder? statusIndicatorBuilder,
  }) {
    final delegate = _buildSliverDelegate(
      itemBuilder,
      itemCount,
      statusIndicatorBuilder: statusIndicatorBuilder,
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
  }) {
    final separatorBuilder = widget._separatorBuilder;
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
            await _pagingBloc.loadPage(isRefresh: true);
          },
        );
  }
}
