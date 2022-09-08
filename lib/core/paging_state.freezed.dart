// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'paging_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PagingStateTearOff {
  const _$PagingStateTearOff();

  PagingStateData<PageKeyType, ItemType> call<PageKeyType, ItemType>(
      PageKeyType? nextPageKey,
      List<ItemType> items,
      PagingStatus status,
      bool hasRequestNextPage) {
    return PagingStateData<PageKeyType, ItemType>(
      nextPageKey,
      items,
      status,
      hasRequestNextPage,
    );
  }

  PagingStateLoading<PageKeyType, ItemType> loading<PageKeyType, ItemType>() {
    return PagingStateLoading<PageKeyType, ItemType>();
  }

  PagingStateError<PageKeyType, ItemType> error<PageKeyType, ItemType>(
      dynamic error) {
    return PagingStateError<PageKeyType, ItemType>(
      error,
    );
  }
}

/// @nodoc
const $PagingState = _$PagingStateTearOff();

/// @nodoc
mixin _$PagingState<PageKeyType, ItemType> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(PageKeyType? nextPageKey, List<ItemType> items,
            PagingStatus status, bool hasRequestNextPage)
        $default, {
    required TResult Function() loading,
    required TResult Function(dynamic error) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(PageKeyType? nextPageKey, List<ItemType> items,
            PagingStatus status, bool hasRequestNextPage)?
        $default, {
    TResult Function()? loading,
    TResult Function(dynamic error)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(PagingStateData<PageKeyType, ItemType> value) $default, {
    required TResult Function(PagingStateLoading<PageKeyType, ItemType> value)
        loading,
    required TResult Function(PagingStateError<PageKeyType, ItemType> value)
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(PagingStateData<PageKeyType, ItemType> value)? $default, {
    TResult Function(PagingStateLoading<PageKeyType, ItemType> value)? loading,
    TResult Function(PagingStateError<PageKeyType, ItemType> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagingStateCopyWith<PageKeyType, ItemType, $Res> {
  factory $PagingStateCopyWith(PagingState<PageKeyType, ItemType> value,
          $Res Function(PagingState<PageKeyType, ItemType>) then) =
      _$PagingStateCopyWithImpl<PageKeyType, ItemType, $Res>;
}

/// @nodoc
class _$PagingStateCopyWithImpl<PageKeyType, ItemType, $Res>
    implements $PagingStateCopyWith<PageKeyType, ItemType, $Res> {
  _$PagingStateCopyWithImpl(this._value, this._then);

  final PagingState<PageKeyType, ItemType> _value;
  // ignore: unused_field
  final $Res Function(PagingState<PageKeyType, ItemType>) _then;
}

/// @nodoc
abstract class $PagingStateDataCopyWith<PageKeyType, ItemType, $Res> {
  factory $PagingStateDataCopyWith(PagingStateData<PageKeyType, ItemType> value,
          $Res Function(PagingStateData<PageKeyType, ItemType>) then) =
      _$PagingStateDataCopyWithImpl<PageKeyType, ItemType, $Res>;
  $Res call(
      {PageKeyType? nextPageKey,
      List<ItemType> items,
      PagingStatus status,
      bool hasRequestNextPage});
}

/// @nodoc
class _$PagingStateDataCopyWithImpl<PageKeyType, ItemType, $Res>
    extends _$PagingStateCopyWithImpl<PageKeyType, ItemType, $Res>
    implements $PagingStateDataCopyWith<PageKeyType, ItemType, $Res> {
  _$PagingStateDataCopyWithImpl(PagingStateData<PageKeyType, ItemType> _value,
      $Res Function(PagingStateData<PageKeyType, ItemType>) _then)
      : super(
            _value, (v) => _then(v as PagingStateData<PageKeyType, ItemType>));

  @override
  PagingStateData<PageKeyType, ItemType> get _value =>
      super._value as PagingStateData<PageKeyType, ItemType>;

  @override
  $Res call({
    Object? nextPageKey = freezed,
    Object? items = freezed,
    Object? status = freezed,
    Object? hasRequestNextPage = freezed,
  }) {
    return _then(PagingStateData<PageKeyType, ItemType>(
      nextPageKey == freezed
          ? _value.nextPageKey
          : nextPageKey // ignore: cast_nullable_to_non_nullable
              as PageKeyType?,
      items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ItemType>,
      status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PagingStatus,
      hasRequestNextPage == freezed
          ? _value.hasRequestNextPage
          : hasRequestNextPage // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
class _$PagingStateData<PageKeyType, ItemType>
    implements PagingStateData<PageKeyType, ItemType> {
  const _$PagingStateData(
      this.nextPageKey, this.items, this.status, this.hasRequestNextPage);

  @override
  final PageKeyType? nextPageKey;
  @override
  final List<ItemType> items;
  @override
  final PagingStatus status;
  @override
  final bool hasRequestNextPage;

  @override
  String toString() {
    return 'PagingState<$PageKeyType, $ItemType>(nextPageKey: $nextPageKey, items: $items, status: $status, hasRequestNextPage: $hasRequestNextPage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is PagingStateData<PageKeyType, ItemType> &&
            (identical(other.nextPageKey, nextPageKey) ||
                const DeepCollectionEquality()
                    .equals(other.nextPageKey, nextPageKey)) &&
            (identical(other.items, items) ||
                const DeepCollectionEquality().equals(other.items, items)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.hasRequestNextPage, hasRequestNextPage) ||
                const DeepCollectionEquality()
                    .equals(other.hasRequestNextPage, hasRequestNextPage)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(nextPageKey) ^
      const DeepCollectionEquality().hash(items) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(hasRequestNextPage);

  @JsonKey(ignore: true)
  @override
  $PagingStateDataCopyWith<PageKeyType, ItemType,
          PagingStateData<PageKeyType, ItemType>>
      get copyWith => _$PagingStateDataCopyWithImpl<PageKeyType, ItemType,
          PagingStateData<PageKeyType, ItemType>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(PageKeyType? nextPageKey, List<ItemType> items,
            PagingStatus status, bool hasRequestNextPage)
        $default, {
    required TResult Function() loading,
    required TResult Function(dynamic error) error,
  }) {
    return $default(nextPageKey, items, status, hasRequestNextPage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(PageKeyType? nextPageKey, List<ItemType> items,
            PagingStatus status, bool hasRequestNextPage)?
        $default, {
    TResult Function()? loading,
    TResult Function(dynamic error)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(nextPageKey, items, status, hasRequestNextPage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(PagingStateData<PageKeyType, ItemType> value) $default, {
    required TResult Function(PagingStateLoading<PageKeyType, ItemType> value)
        loading,
    required TResult Function(PagingStateError<PageKeyType, ItemType> value)
        error,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(PagingStateData<PageKeyType, ItemType> value)? $default, {
    TResult Function(PagingStateLoading<PageKeyType, ItemType> value)? loading,
    TResult Function(PagingStateError<PageKeyType, ItemType> value)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class PagingStateData<PageKeyType, ItemType>
    implements PagingState<PageKeyType, ItemType> {
  const factory PagingStateData(
      PageKeyType? nextPageKey,
      List<ItemType> items,
      PagingStatus status,
      bool hasRequestNextPage) = _$PagingStateData<PageKeyType, ItemType>;

  PageKeyType? get nextPageKey => throw _privateConstructorUsedError;
  List<ItemType> get items => throw _privateConstructorUsedError;
  PagingStatus get status => throw _privateConstructorUsedError;
  bool get hasRequestNextPage => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PagingStateDataCopyWith<PageKeyType, ItemType,
          PagingStateData<PageKeyType, ItemType>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagingStateLoadingCopyWith<PageKeyType, ItemType, $Res> {
  factory $PagingStateLoadingCopyWith(
          PagingStateLoading<PageKeyType, ItemType> value,
          $Res Function(PagingStateLoading<PageKeyType, ItemType>) then) =
      _$PagingStateLoadingCopyWithImpl<PageKeyType, ItemType, $Res>;
}

/// @nodoc
class _$PagingStateLoadingCopyWithImpl<PageKeyType, ItemType, $Res>
    extends _$PagingStateCopyWithImpl<PageKeyType, ItemType, $Res>
    implements $PagingStateLoadingCopyWith<PageKeyType, ItemType, $Res> {
  _$PagingStateLoadingCopyWithImpl(
      PagingStateLoading<PageKeyType, ItemType> _value,
      $Res Function(PagingStateLoading<PageKeyType, ItemType>) _then)
      : super(_value,
            (v) => _then(v as PagingStateLoading<PageKeyType, ItemType>));

  @override
  PagingStateLoading<PageKeyType, ItemType> get _value =>
      super._value as PagingStateLoading<PageKeyType, ItemType>;
}

/// @nodoc
class _$PagingStateLoading<PageKeyType, ItemType>
    implements PagingStateLoading<PageKeyType, ItemType> {
  const _$PagingStateLoading();

  @override
  String toString() {
    return 'PagingState<$PageKeyType, $ItemType>.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is PagingStateLoading<PageKeyType, ItemType>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(PageKeyType? nextPageKey, List<ItemType> items,
            PagingStatus status, bool hasRequestNextPage)
        $default, {
    required TResult Function() loading,
    required TResult Function(dynamic error) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(PageKeyType? nextPageKey, List<ItemType> items,
            PagingStatus status, bool hasRequestNextPage)?
        $default, {
    TResult Function()? loading,
    TResult Function(dynamic error)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(PagingStateData<PageKeyType, ItemType> value) $default, {
    required TResult Function(PagingStateLoading<PageKeyType, ItemType> value)
        loading,
    required TResult Function(PagingStateError<PageKeyType, ItemType> value)
        error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(PagingStateData<PageKeyType, ItemType> value)? $default, {
    TResult Function(PagingStateLoading<PageKeyType, ItemType> value)? loading,
    TResult Function(PagingStateError<PageKeyType, ItemType> value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class PagingStateLoading<PageKeyType, ItemType>
    implements PagingState<PageKeyType, ItemType> {
  const factory PagingStateLoading() =
      _$PagingStateLoading<PageKeyType, ItemType>;
}

/// @nodoc
abstract class $PagingStateErrorCopyWith<PageKeyType, ItemType, $Res> {
  factory $PagingStateErrorCopyWith(
          PagingStateError<PageKeyType, ItemType> value,
          $Res Function(PagingStateError<PageKeyType, ItemType>) then) =
      _$PagingStateErrorCopyWithImpl<PageKeyType, ItemType, $Res>;
  $Res call({dynamic error});
}

/// @nodoc
class _$PagingStateErrorCopyWithImpl<PageKeyType, ItemType, $Res>
    extends _$PagingStateCopyWithImpl<PageKeyType, ItemType, $Res>
    implements $PagingStateErrorCopyWith<PageKeyType, ItemType, $Res> {
  _$PagingStateErrorCopyWithImpl(PagingStateError<PageKeyType, ItemType> _value,
      $Res Function(PagingStateError<PageKeyType, ItemType>) _then)
      : super(
            _value, (v) => _then(v as PagingStateError<PageKeyType, ItemType>));

  @override
  PagingStateError<PageKeyType, ItemType> get _value =>
      super._value as PagingStateError<PageKeyType, ItemType>;

  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(PagingStateError<PageKeyType, ItemType>(
      error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
class _$PagingStateError<PageKeyType, ItemType>
    implements PagingStateError<PageKeyType, ItemType> {
  const _$PagingStateError(this.error);

  @override
  final dynamic error;

  @override
  String toString() {
    return 'PagingState<$PageKeyType, $ItemType>.error(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is PagingStateError<PageKeyType, ItemType> &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  $PagingStateErrorCopyWith<PageKeyType, ItemType,
          PagingStateError<PageKeyType, ItemType>>
      get copyWith => _$PagingStateErrorCopyWithImpl<PageKeyType, ItemType,
          PagingStateError<PageKeyType, ItemType>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(PageKeyType? nextPageKey, List<ItemType> items,
            PagingStatus status, bool hasRequestNextPage)
        $default, {
    required TResult Function() loading,
    required TResult Function(dynamic error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(PageKeyType? nextPageKey, List<ItemType> items,
            PagingStatus status, bool hasRequestNextPage)?
        $default, {
    TResult Function()? loading,
    TResult Function(dynamic error)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(PagingStateData<PageKeyType, ItemType> value) $default, {
    required TResult Function(PagingStateLoading<PageKeyType, ItemType> value)
        loading,
    required TResult Function(PagingStateError<PageKeyType, ItemType> value)
        error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(PagingStateData<PageKeyType, ItemType> value)? $default, {
    TResult Function(PagingStateLoading<PageKeyType, ItemType> value)? loading,
    TResult Function(PagingStateError<PageKeyType, ItemType> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class PagingStateError<PageKeyType, ItemType>
    implements PagingState<PageKeyType, ItemType> {
  const factory PagingStateError(dynamic error) =
      _$PagingStateError<PageKeyType, ItemType>;

  dynamic get error => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PagingStateErrorCopyWith<PageKeyType, ItemType,
          PagingStateError<PageKeyType, ItemType>>
      get copyWith => throw _privateConstructorUsedError;
}
