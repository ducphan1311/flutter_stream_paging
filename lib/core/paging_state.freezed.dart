// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paging_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PagingState<PageKeyType, ItemType> {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PagingState<PageKeyType, ItemType>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PagingState<$PageKeyType, $ItemType>()';
  }
}

/// @nodoc
class $PagingStateCopyWith<PageKeyType, ItemType, $Res> {
  $PagingStateCopyWith(PagingState<PageKeyType, ItemType> _,
      $Res Function(PagingState<PageKeyType, ItemType>) __);
}

/// @nodoc

class PagingStateData<PageKeyType, ItemType>
    implements PagingState<PageKeyType, ItemType> {
  const PagingStateData(
      final List<ItemType> items, this.status, this.hasRequestNextPage)
      : _items = items;

  final List<ItemType> _items;
  List<ItemType> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final PagingStatus status;
  final bool hasRequestNextPage;

  /// Create a copy of PagingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PagingStateDataCopyWith<PageKeyType, ItemType,
          PagingStateData<PageKeyType, ItemType>>
      get copyWith => _$PagingStateDataCopyWithImpl<PageKeyType, ItemType,
          PagingStateData<PageKeyType, ItemType>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PagingStateData<PageKeyType, ItemType> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.hasRequestNextPage, hasRequestNextPage) ||
                other.hasRequestNextPage == hasRequestNextPage));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), status, hasRequestNextPage);

  @override
  String toString() {
    return 'PagingState<$PageKeyType, $ItemType>(items: $items, status: $status, hasRequestNextPage: $hasRequestNextPage)';
  }
}

/// @nodoc
abstract mixin class $PagingStateDataCopyWith<PageKeyType, ItemType, $Res>
    implements $PagingStateCopyWith<PageKeyType, ItemType, $Res> {
  factory $PagingStateDataCopyWith(PagingStateData<PageKeyType, ItemType> value,
          $Res Function(PagingStateData<PageKeyType, ItemType>) _then) =
      _$PagingStateDataCopyWithImpl;
  @useResult
  $Res call(
      {List<ItemType> items, PagingStatus status, bool hasRequestNextPage});
}

/// @nodoc
class _$PagingStateDataCopyWithImpl<PageKeyType, ItemType, $Res>
    implements $PagingStateDataCopyWith<PageKeyType, ItemType, $Res> {
  _$PagingStateDataCopyWithImpl(this._self, this._then);

  final PagingStateData<PageKeyType, ItemType> _self;
  final $Res Function(PagingStateData<PageKeyType, ItemType>) _then;

  /// Create a copy of PagingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? status = null,
    Object? hasRequestNextPage = null,
  }) {
    return _then(PagingStateData<PageKeyType, ItemType>(
      null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ItemType>,
      null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as PagingStatus,
      null == hasRequestNextPage
          ? _self.hasRequestNextPage
          : hasRequestNextPage // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class PagingStateLoading<PageKeyType, ItemType>
    implements PagingState<PageKeyType, ItemType> {
  const PagingStateLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PagingStateLoading<PageKeyType, ItemType>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PagingState<$PageKeyType, $ItemType>.loading()';
  }
}

/// @nodoc

class PagingStateError<PageKeyType, ItemType>
    implements PagingState<PageKeyType, ItemType> {
  const PagingStateError(this.error);

  final dynamic error;

  /// Create a copy of PagingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PagingStateErrorCopyWith<PageKeyType, ItemType,
          PagingStateError<PageKeyType, ItemType>>
      get copyWith => _$PagingStateErrorCopyWithImpl<PageKeyType, ItemType,
          PagingStateError<PageKeyType, ItemType>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PagingStateError<PageKeyType, ItemType> &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(error));

  @override
  String toString() {
    return 'PagingState<$PageKeyType, $ItemType>.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $PagingStateErrorCopyWith<PageKeyType, ItemType, $Res>
    implements $PagingStateCopyWith<PageKeyType, ItemType, $Res> {
  factory $PagingStateErrorCopyWith(
          PagingStateError<PageKeyType, ItemType> value,
          $Res Function(PagingStateError<PageKeyType, ItemType>) _then) =
      _$PagingStateErrorCopyWithImpl;
  @useResult
  $Res call({dynamic error});
}

/// @nodoc
class _$PagingStateErrorCopyWithImpl<PageKeyType, ItemType, $Res>
    implements $PagingStateErrorCopyWith<PageKeyType, ItemType, $Res> {
  _$PagingStateErrorCopyWithImpl(this._self, this._then);

  final PagingStateError<PageKeyType, ItemType> _self;
  final $Res Function(PagingStateError<PageKeyType, ItemType>) _then;

  /// Create a copy of PagingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = freezed,
  }) {
    return _then(PagingStateError<PageKeyType, ItemType>(
      freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

// dart format on
