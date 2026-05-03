import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/pomodoro_constants.dart';

part 'pomodoro_settings.freezed.dart';

@freezed
class PomodoroSettings with _$PomodoroSettings {
  const factory PomodoroSettings({
    @Default(PomodoroConstants.defaultWorkMinutes) int workDurationMinutes,
    @Default(PomodoroConstants.defaultShortBreakMinutes) int shortBreakMinutes,
    @Default(PomodoroConstants.defaultLongBreakMinutes) int longBreakMinutes,
    @Default(PomodoroConstants.defaultShortBreakInterval)
    int shortBreakInterval,
  }) = _PomodoroSettings;

  const PomodoroSettings._();

  int get workDurationSeconds => workDurationMinutes * 60;
  int get shortBreakSeconds => shortBreakMinutes * 60;
  int get longBreakSeconds => longBreakMinutes * 60;
}
