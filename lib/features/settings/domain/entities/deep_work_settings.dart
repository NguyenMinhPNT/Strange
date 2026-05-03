import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/deep_work_constants.dart';

part 'deep_work_settings.freezed.dart';

@freezed
class DeepWorkSettings with _$DeepWorkSettings {
  const factory DeepWorkSettings({
    @Default(DeepWorkConstants.defaultMaxPauseSeconds) int maxPauseSeconds,
  }) = _DeepWorkSettings;
}
