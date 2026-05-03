// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Session {
  int get id => throw _privateConstructorUsedError;
  int get cardId => throw _privateConstructorUsedError;
  TimerType get timerType => throw _privateConstructorUsedError;
  SessionStatus get status => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime get endedAt => throw _privateConstructorUsedError;
  int get totalWorkSeconds => throw _privateConstructorUsedError;
  int get totalBreakSeconds => throw _privateConstructorUsedError;
  int get pomodoroRoundsCompleted => throw _privateConstructorUsedError;
  int get deepWorkPauseSeconds => throw _privateConstructorUsedError;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionCopyWith<Session> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionCopyWith<$Res> {
  factory $SessionCopyWith(Session value, $Res Function(Session) then) =
      _$SessionCopyWithImpl<$Res, Session>;
  @useResult
  $Res call(
      {int id,
      int cardId,
      TimerType timerType,
      SessionStatus status,
      DateTime startedAt,
      DateTime endedAt,
      int totalWorkSeconds,
      int totalBreakSeconds,
      int pomodoroRoundsCompleted,
      int deepWorkPauseSeconds});
}

/// @nodoc
class _$SessionCopyWithImpl<$Res, $Val extends Session>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cardId = null,
    Object? timerType = null,
    Object? status = null,
    Object? startedAt = null,
    Object? endedAt = null,
    Object? totalWorkSeconds = null,
    Object? totalBreakSeconds = null,
    Object? pomodoroRoundsCompleted = null,
    Object? deepWorkPauseSeconds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as int,
      timerType: null == timerType
          ? _value.timerType
          : timerType // ignore: cast_nullable_to_non_nullable
              as TimerType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SessionStatus,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: null == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalWorkSeconds: null == totalWorkSeconds
          ? _value.totalWorkSeconds
          : totalWorkSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      totalBreakSeconds: null == totalBreakSeconds
          ? _value.totalBreakSeconds
          : totalBreakSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      pomodoroRoundsCompleted: null == pomodoroRoundsCompleted
          ? _value.pomodoroRoundsCompleted
          : pomodoroRoundsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      deepWorkPauseSeconds: null == deepWorkPauseSeconds
          ? _value.deepWorkPauseSeconds
          : deepWorkPauseSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionImplCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$$SessionImplCopyWith(
          _$SessionImpl value, $Res Function(_$SessionImpl) then) =
      __$$SessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int cardId,
      TimerType timerType,
      SessionStatus status,
      DateTime startedAt,
      DateTime endedAt,
      int totalWorkSeconds,
      int totalBreakSeconds,
      int pomodoroRoundsCompleted,
      int deepWorkPauseSeconds});
}

/// @nodoc
class __$$SessionImplCopyWithImpl<$Res>
    extends _$SessionCopyWithImpl<$Res, _$SessionImpl>
    implements _$$SessionImplCopyWith<$Res> {
  __$$SessionImplCopyWithImpl(
      _$SessionImpl _value, $Res Function(_$SessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cardId = null,
    Object? timerType = null,
    Object? status = null,
    Object? startedAt = null,
    Object? endedAt = null,
    Object? totalWorkSeconds = null,
    Object? totalBreakSeconds = null,
    Object? pomodoroRoundsCompleted = null,
    Object? deepWorkPauseSeconds = null,
  }) {
    return _then(_$SessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as int,
      timerType: null == timerType
          ? _value.timerType
          : timerType // ignore: cast_nullable_to_non_nullable
              as TimerType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SessionStatus,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: null == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalWorkSeconds: null == totalWorkSeconds
          ? _value.totalWorkSeconds
          : totalWorkSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      totalBreakSeconds: null == totalBreakSeconds
          ? _value.totalBreakSeconds
          : totalBreakSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      pomodoroRoundsCompleted: null == pomodoroRoundsCompleted
          ? _value.pomodoroRoundsCompleted
          : pomodoroRoundsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      deepWorkPauseSeconds: null == deepWorkPauseSeconds
          ? _value.deepWorkPauseSeconds
          : deepWorkPauseSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SessionImpl implements _Session {
  const _$SessionImpl(
      {required this.id,
      required this.cardId,
      required this.timerType,
      required this.status,
      required this.startedAt,
      required this.endedAt,
      required this.totalWorkSeconds,
      required this.totalBreakSeconds,
      required this.pomodoroRoundsCompleted,
      required this.deepWorkPauseSeconds});

  @override
  final int id;
  @override
  final int cardId;
  @override
  final TimerType timerType;
  @override
  final SessionStatus status;
  @override
  final DateTime startedAt;
  @override
  final DateTime endedAt;
  @override
  final int totalWorkSeconds;
  @override
  final int totalBreakSeconds;
  @override
  final int pomodoroRoundsCompleted;
  @override
  final int deepWorkPauseSeconds;

  @override
  String toString() {
    return 'Session(id: $id, cardId: $cardId, timerType: $timerType, status: $status, startedAt: $startedAt, endedAt: $endedAt, totalWorkSeconds: $totalWorkSeconds, totalBreakSeconds: $totalBreakSeconds, pomodoroRoundsCompleted: $pomodoroRoundsCompleted, deepWorkPauseSeconds: $deepWorkPauseSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.timerType, timerType) ||
                other.timerType == timerType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.totalWorkSeconds, totalWorkSeconds) ||
                other.totalWorkSeconds == totalWorkSeconds) &&
            (identical(other.totalBreakSeconds, totalBreakSeconds) ||
                other.totalBreakSeconds == totalBreakSeconds) &&
            (identical(
                    other.pomodoroRoundsCompleted, pomodoroRoundsCompleted) ||
                other.pomodoroRoundsCompleted == pomodoroRoundsCompleted) &&
            (identical(other.deepWorkPauseSeconds, deepWorkPauseSeconds) ||
                other.deepWorkPauseSeconds == deepWorkPauseSeconds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      cardId,
      timerType,
      status,
      startedAt,
      endedAt,
      totalWorkSeconds,
      totalBreakSeconds,
      pomodoroRoundsCompleted,
      deepWorkPauseSeconds);

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      __$$SessionImplCopyWithImpl<_$SessionImpl>(this, _$identity);
}

abstract class _Session implements Session {
  const factory _Session(
      {required final int id,
      required final int cardId,
      required final TimerType timerType,
      required final SessionStatus status,
      required final DateTime startedAt,
      required final DateTime endedAt,
      required final int totalWorkSeconds,
      required final int totalBreakSeconds,
      required final int pomodoroRoundsCompleted,
      required final int deepWorkPauseSeconds}) = _$SessionImpl;

  @override
  int get id;
  @override
  int get cardId;
  @override
  TimerType get timerType;
  @override
  SessionStatus get status;
  @override
  DateTime get startedAt;
  @override
  DateTime get endedAt;
  @override
  int get totalWorkSeconds;
  @override
  int get totalBreakSeconds;
  @override
  int get pomodoroRoundsCompleted;
  @override
  int get deepWorkPauseSeconds;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
