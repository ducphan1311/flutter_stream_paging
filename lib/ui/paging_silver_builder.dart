import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_stream_paging/model/paging_status.dart';
import 'package:flutter_stream_paging/utils/paged_child_builder_delegate.dart';
import 'package:sliver_tools/sliver_tools.dart';

class PagingSilverBuilder<PageKeyType, ItemType> extends CustomScrollView {
  const PagingSilverBuilder({
    Key? key,
    this.padding = EdgeInsets.zero,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    this.addRepaintBoundaries = true,
    this.addAutomaticKeepAlives = true,
    this.addSemanticIndexes = true,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    required this.builderDelegate,
    // Corresponds to [ScrollView.restorationId]
    String? restorationId,
    // Corresponds to [ScrollView.clipBehavior]
    Clip clipBehavior = Clip.hardEdge,
    required this.loadingListingBuilder,
    required this.errorListingBuilder,
    required this.completedListingBuilder,
    required this.refreshBuilder,
    required this.status,
  }) : super(
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );
  final widgets.EdgeInsets padding;

  ///In Android pull to refresh only work
  /// if total height height  < height of screen => physics = [AlwaysScrollableScrollPhysics]
  /// if total height of item > height of screen => physics = [BouncingScrollPhysics] || [AlwaysScrollableScrollPhysics]
  /// default physics = [AlwaysScrollableScrollPhysics]
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  /// Signature for a function that creates a widget for item
  final PagedChildBuilderDelegate<ItemType> builderDelegate;

  /// The builder for an in-progress listing.
  final WidgetBuilder loadingListingBuilder;

  /// The builder for an in-progress listing with a failed request.
  final WidgetBuilder errorListingBuilder;

  /// The builder for a completed listing.
  final WidgetBuilder completedListingBuilder;

  final WidgetBuilder refreshBuilder;

  final PagingStatus status;

  @override
  List<Widget> buildSlivers(BuildContext context) {
    Widget child;
    switch (status) {
      case PagingStatus.ongoing:
        child = loadingListingBuilder(context);
        break;
      case PagingStatus.completed:
        child = completedListingBuilder(context);

        break;
      default:
        child = errorListingBuilder(context);
    }
    if (scrollDirection == Axis.horizontal) {
      return [
        SliverToBoxAdapter(
          child: Container(
            padding: padding,
          ),
        ),
        (builderDelegate.animateTransitions)
            ? SliverAnimatedSwitcher(
                duration: builderDelegate.transitionDuration,
                child: child,
              )
            : child,
      ];
    }
    return [
      !(reverse || Platform.isAndroid)
          ? refreshBuilder(context)
          : const SliverToBoxAdapter(
              child: SizedBox(),
            ),
      SliverToBoxAdapter(
        child: Container(
          padding: padding,
        ),
      ),
      (builderDelegate.animateTransitions)
          ? SliverAnimatedSwitcher(
              duration: builderDelegate.transitionDuration,
              child: child,
            )
          : child,
    ];
  }
}
