import 'package:flutter/material.dart';
import 'package:flutter_stream_paging/data_source/data_source.dart';
import 'package:flutter_stream_paging/utils/paged_child_builder_delegate.dart';

typedef ValueIndexWidgetBuilder<T> = Widget Function(
    BuildContext context, T value, int index);

typedef PaginationBuilder<T> = Future<List<T>> Function(int page);

typedef ErrorBuilder<T> = T Function(BuildContext context, Object error);

typedef SeparatorBuilder<ItemType> = Widget Function(
  BuildContext context,
  int index,
  ItemType item,
  List<ItemType> items,
);

abstract class BaseWidget<PageKeyType, ItemType> extends StatefulWidget {
  /// Signature for a function that creates a widget empty
  final WidgetBuilder? emptyBuilder;

  /// Signature for a function that creates a widget loading
  final WidgetBuilder? loadingBuilder;

  /// Signature for a function that creates a widget Error
  final ErrorBuilder? errorBuilder;

  final WidgetBuilder? refreshBuilder;

  /// Signature for a function that creates a widget for item
  final PagedChildBuilderDelegate<ItemType> builderDelegate;

  /// DataSource for current ScrollView [ListView - GridView]
  final DataSource<PageKeyType, ItemType> pageDataSource;

  /// Signature for a function that creates a widget for separator item
  final SeparatorBuilder<ItemType>? separatorBuilder;

  const BaseWidget(
      {Key? key,
      this.emptyBuilder,
      this.loadingBuilder,
      this.errorBuilder,
      required this.builderDelegate,
      required this.pageDataSource,
      this.refreshBuilder,
      this.separatorBuilder})
      : super(key: key);
}
