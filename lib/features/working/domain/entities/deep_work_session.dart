import 'package:freezed_annotation/freezed_annotation.dart';

part 'deep_work_session.freezed.dart';

@freezed
class DeepWorkSession with _$DeepWorkSession {
  const factory DeepWorkSession({
    required int cardId,
    required int elapsedWorkSeconds,
    required int pauseElapsedSeconds,
    required int totalPauseSeconds,
    required int maxPauseSeconds,
    required DateTime startedAt,
    required bool isPaused,
  }) = _DeepWorkSession;
}
