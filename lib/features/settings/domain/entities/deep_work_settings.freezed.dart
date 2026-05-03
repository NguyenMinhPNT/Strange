// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deep_work_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DeepWorkSettings {
  int get maxPauseSeconds => throw _privateConstructorUsedError;

  /// Create a copy of DeepWorkSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeepWorkSettingsCopyWith<DeepWorkSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeepWorkSettingsCopyWith<$Res> {
  factory $DeepWorkSettingsCopyWith(
          DeepWorkSettings value, $Res Function(DeepWorkSettings) then) =
      _$DeepWorkSettingsCopyWithImpl<$Res, DeepWorkSettings>;
  @useResult
  $Res call({int maxPauseSeconds});
}

/// @nodoc
class _$DeepWorkSettingsCopyWithImpl<$Res, $Val extends DeepWorkSettings>
    implements $DeepWorkSettingsCopyWith<$Res> {
  _$DeepWorkSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeepWorkSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxPauseSeconds = null,
  }) {
    return _then(_value.copyWith(
      maxPauseSeconds: null == maxPauseSeconds
          ? _value.maxPauseSeconds
          : maxPauseSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeepWorkSettingsImplCopyWith<$Res>
    implements $DeepWorkSettingsCopyWith<$Res> {
  factory _$$DeepWorkSettingsImplCopyWith(_$DeepWorkSettingsImpl value,
          $Res Function(_$DeepWorkSettingsImpl) then) =
      __$$DeepWorkSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int maxPauseSeconds});
}

/// @nodoc
class __$$DeepWorkSettingsImplCopyWithImpl<$Res>
    extends _$DeepWorkSettingsCopyWithImpl<$Res, _$DeepWorkSettingsImpl>
    implements _$$DeepWorkSettingsImplCopyWith<$Res> {
  __$$DeepWorkSettingsImplCopyWithImpl(_$DeepWorkSettingsImpl _value,
      $Res Function(_$DeepWorkSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeepWorkSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxPauseSeconds = null,
  }) {
    return _then(_$DeepWorkSettingsImpl(
      maxPauseSeconds: null == maxPauseSeconds
          ? _value.maxPauseSeconds
          : maxPauseSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DeepWorkSettingsImpl implements _DeepWorkSettings {
  const _$DeepWorkSettingsImpl(
      {this.maxPauseSeconds = DeepWorkConstants.defaultMaxPauseSeconds});

  @override
  @JsonKey()
  final int maxPauseSeconds;

  @override
  String toString() {
    return 'DeepWorkSettings(maxPauseSeconds: $maxPauseSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeepWorkSettingsImpl &&
            (identical(other.maxPauseSeconds, maxPauseSeconds) ||
                other.maxPauseSeconds == maxPauseSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, maxPauseSeconds);

  /// Create a copy of DeepWorkSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeepWorkSettingsImplCopyWith<_$DeepWorkSettingsImpl> get copyWith =>
      __$$DeepWorkSettingsImplCopyWithImpl<_$DeepWorkSettingsImpl>(
          this, _$identity);
}

abstract class _DeepWorkSettings implements DeepWorkSettings {
  const factory _DeepWorkSettings({final int maxPauseSeconds}) =
      _$DeepWorkSettingsImpl;

  @override
  int get maxPauseSeconds;

  /// Create a copy of DeepWorkSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeepWorkSettingsImplCopyWith<_$DeepWorkSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
