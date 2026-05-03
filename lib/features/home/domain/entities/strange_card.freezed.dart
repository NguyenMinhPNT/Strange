// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'strange_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StrangeCard {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get colorHex => throw _privateConstructorUsedError;
  CardType get type => throw _privateConstructorUsedError;
  CardStatus get status => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of StrangeCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StrangeCardCopyWith<StrangeCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StrangeCardCopyWith<$Res> {
  factory $StrangeCardCopyWith(
          StrangeCard value, $Res Function(StrangeCard) then) =
      _$StrangeCardCopyWithImpl<$Res, StrangeCard>;
  @useResult
  $Res call(
      {int id,
      String name,
      String colorHex,
      CardType type,
      CardStatus status,
      int position,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$StrangeCardCopyWithImpl<$Res, $Val extends StrangeCard>
    implements $StrangeCardCopyWith<$Res> {
  _$StrangeCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StrangeCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? colorHex = null,
    Object? type = null,
    Object? status = null,
    Object? position = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CardType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CardStatus,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StrangeCardImplCopyWith<$Res>
    implements $StrangeCardCopyWith<$Res> {
  factory _$$StrangeCardImplCopyWith(
          _$StrangeCardImpl value, $Res Function(_$StrangeCardImpl) then) =
      __$$StrangeCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String colorHex,
      CardType type,
      CardStatus status,
      int position,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$StrangeCardImplCopyWithImpl<$Res>
    extends _$StrangeCardCopyWithImpl<$Res, _$StrangeCardImpl>
    implements _$$StrangeCardImplCopyWith<$Res> {
  __$$StrangeCardImplCopyWithImpl(
      _$StrangeCardImpl _value, $Res Function(_$StrangeCardImpl) _then)
      : super(_value, _then);

  /// Create a copy of StrangeCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? colorHex = null,
    Object? type = null,
    Object? status = null,
    Object? position = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$StrangeCardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CardType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CardStatus,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$StrangeCardImpl implements _StrangeCard {
  const _$StrangeCardImpl(
      {required this.id,
      required this.name,
      required this.colorHex,
      required this.type,
      required this.status,
      required this.position,
      required this.createdAt,
      required this.updatedAt});

  @override
  final int id;
  @override
  final String name;
  @override
  final String colorHex;
  @override
  final CardType type;
  @override
  final CardStatus status;
  @override
  final int position;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'StrangeCard(id: $id, name: $name, colorHex: $colorHex, type: $type, status: $status, position: $position, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StrangeCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, colorHex, type, status,
      position, createdAt, updatedAt);

  /// Create a copy of StrangeCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StrangeCardImplCopyWith<_$StrangeCardImpl> get copyWith =>
      __$$StrangeCardImplCopyWithImpl<_$StrangeCardImpl>(this, _$identity);
}

abstract class _StrangeCard implements StrangeCard {
  const factory _StrangeCard(
      {required final int id,
      required final String name,
      required final String colorHex,
      required final CardType type,
      required final CardStatus status,
      required final int position,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$StrangeCardImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  String get colorHex;
  @override
  CardType get type;
  @override
  CardStatus get status;
  @override
  int get position;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of StrangeCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StrangeCardImplCopyWith<_$StrangeCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
