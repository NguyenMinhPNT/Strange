// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pomodoro_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PomodoroSettings {
  int get workDurationMinutes => throw _privateConstructorUsedError;
  int get shortBreakMinutes => throw _privateConstructorUsedError;
  int get longBreakMinutes => throw _privateConstructorUsedError;
  int get shortBreakInterval => throw _privateConstructorUsedError;

  /// Create a copy of PomodoroSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PomodoroSettingsCopyWith<PomodoroSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PomodoroSettingsCopyWith<$Res> {
  factory $PomodoroSettingsCopyWith(
          PomodoroSettings value, $Res Function(PomodoroSettings) then) =
      _$PomodoroSettingsCopyWithImpl<$Res, PomodoroSettings>;
  @useResult
  $Res call(
      {int workDurationMinutes,
      int shortBreakMinutes,
      int longBreakMinutes,
      int shortBreakInterval});
}

/// @nodoc
class _$PomodoroSettingsCopyWithImpl<$Res, $Val extends PomodoroSettings>
    implements $PomodoroSettingsCopyWith<$Res> {
  _$PomodoroSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PomodoroSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workDurationMinutes = null,
    Object? shortBreakMinutes = null,
    Object? longBreakMinutes = null,
    Object? shortBreakInterval = null,
  }) {
    return _then(_value.copyWith(
      workDurationMinutes: null == workDurationMinutes
          ? _value.workDurationMinutes
          : workDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      shortBreakMinutes: null == shortBreakMinutes
          ? _value.shortBreakMinutes
          : shortBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      longBreakMinutes: null == longBreakMinutes
          ? _value.longBreakMinutes
          : longBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      shortBreakInterval: null == shortBreakInterval
          ? _value.shortBreakInterval
          : shortBreakInterval // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PomodoroSettingsImplCopyWith<$Res>
    implements $PomodoroSettingsCopyWith<$Res> {
  factory _$$PomodoroSettingsImplCopyWith(_$PomodoroSettingsImpl value,
          $Res Function(_$PomodoroSettingsImpl) then) =
      __$$PomodoroSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int workDurationMinutes,
      int shortBreakMinutes,
      int longBreakMinutes,
      int shortBreakInterval});
}

/// @nodoc
class __$$PomodoroSettingsImplCopyWithImpl<$Res>
    extends _$PomodoroSettingsCopyWithImpl<$Res, _$PomodoroSettingsImpl>
    implements _$$PomodoroSettingsImplCopyWith<$Res> {
  __$$PomodoroSettingsImplCopyWithImpl(_$PomodoroSettingsImpl _value,
      $Res Function(_$PomodoroSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PomodoroSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workDurationMinutes = null,
    Object? shortBreakMinutes = null,
    Object? longBreakMinutes = null,
    Object? shortBreakInterval = null,
  }) {
    return _then(_$PomodoroSettingsImpl(
      workDurationMinutes: null == workDurationMinutes
          ? _value.workDurationMinutes
          : workDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      shortBreakMinutes: null == shortBreakMinutes
          ? _value.shortBreakMinutes
          : shortBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      longBreakMinutes: null == longBreakMinutes
          ? _value.longBreakMinutes
          : longBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      shortBreakInterval: null == shortBreakInterval
          ? _value.shortBreakInterval
          : shortBreakInterval // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PomodoroSettingsImpl extends _PomodoroSettings {
  const _$PomodoroSettingsImpl(
      {this.workDurationMinutes = PomodoroConstants.defaultWorkMinutes,
      this.shortBreakMinutes = PomodoroConstants.defaultShortBreakMinutes,
      this.longBreakMinutes = PomodoroConstants.defaultLongBreakMinutes,
      this.shortBreakInterval = PomodoroConstants.defaultShortBreakInterval})
      : super._();

  @override
  @JsonKey()
  final int workDurationMinutes;
  @override
  @JsonKey()
  final int shortBreakMinutes;
  @override
  @JsonKey()
  final int longBreakMinutes;
  @override
  @JsonKey()
  final int shortBreakInterval;

  @override
  String toString() {
    return 'PomodoroSettings(workDurationMinutes: $workDurationMinutes, shortBreakMinutes: $shortBreakMinutes, longBreakMinutes: $longBreakMinutes, shortBreakInterval: $shortBreakInterval)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PomodoroSettingsImpl &&
            (identical(other.workDurationMinutes, workDurationMinutes) ||
                other.workDurationMinutes == workDurationMinutes) &&
            (identical(other.shortBreakMinutes, shortBreakMinutes) ||
                other.shortBreakMinutes == shortBreakMinutes) &&
            (identical(other.longBreakMinutes, longBreakMinutes) ||
                other.longBreakMinutes == longBreakMinutes) &&
            (identical(other.shortBreakInterval, shortBreakInterval) ||
                other.shortBreakInterval == shortBreakInterval));
  }

  @override
  int get hashCode => Object.hash(runtimeType, workDurationMinutes,
      shortBreakMinutes, longBreakMinutes, shortBreakInterval);

  /// Create a copy of PomodoroSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PomodoroSettingsImplCopyWith<_$PomodoroSettingsImpl> get copyWith =>
      __$$PomodoroSettingsImplCopyWithImpl<_$PomodoroSettingsImpl>(
          this, _$identity);
}

abstract class _PomodoroSettings extends PomodoroSettings {
  const factory _PomodoroSettings(
      {final int workDurationMinutes,
      final int shortBreakMinutes,
      final int longBreakMinutes,
      final int shortBreakInterval}) = _$PomodoroSettingsImpl;
  const _PomodoroSettings._() : super._();

  @override
  int get workDurationMinutes;
  @override
  int get shortBreakMinutes;
  @override
  int get longBreakMinutes;
  @override
  int get shortBreakInterval;

  /// Create a copy of PomodoroSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PomodoroSettingsImplCopyWith<_$PomodoroSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
