import 'package:injectable/injectable.dart';

import '../../../../core/database/daos/card_dao.dart';
import '../../../../core/database/daos/session_dao.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/domain/entities/enums/card_type.dart';
import '../../domain/entities/stats_card.dart';
import '../../domain/entities/column_data.dart';
import '../../domain/entities/day_stat.dart';
import '../../domain/entities/pie_slice.dart';

@lazySingleton
class StatsLocalDatasource {
  const StatsLocalDatasource(this._sessionDao, this._cardDao);

  final SessionDao _sessionDao;
  final CardDao _cardDao;

  Future<List<DayStat>> getHeatmapData(DateTime start, DateTime end,
      [int? cardId]) async {
    final sessions = await _sessionDao.getSessionsInRange(start, end);
    final Map<DateTime, int> byDay = {};

    for (final s in sessions) {
      if (cardId != null && s.cardId != cardId) continue;
      final day = DateTime(
        s.startedAt.year,
        s.startedAt.month,
        s.startedAt.day,
      );
      byDay[day] = (byDay[day] ?? 0) + s.totalWorkSeconds;
    }

    return byDay.entries
        .map((e) => DayStat(date: e.key, totalSeconds: e.value))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<List<ColumnData>> getColumnData(DateTime start, DateTime end,
      [int? cardId]) async {
    final sessions = await _sessionDao.getSessionsInRange(start, end);
    final allCards = await _cardDao.getAllCards();
    final cardTypeMap = {
      for (final c in allCards) c.id: CardType.fromString(c.type),
    };

    final Map<DateTime, _TypeBucket> byDay = {};

    for (final s in sessions) {
      if (cardId != null && s.cardId != cardId) continue;
      final day = DateTime(
        s.startedAt.year,
        s.startedAt.month,
        s.startedAt.day,
      );
      final bucket = byDay.putIfAbsent(day, _TypeBucket.new);
      final type = cardTypeMap[s.cardId] ?? CardType.learning;
      switch (type) {
        case CardType.learning:
          bucket.learningSeconds += s.totalWorkSeconds;
        case CardType.project:
          bucket.projectSeconds += s.totalWorkSeconds;
        case CardType.habit:
          bucket.habitSeconds += s.totalWorkSeconds;
      }
    }

    return byDay.entries
        .map(
          (e) => ColumnData(
            date: e.key,
            learningSeconds: e.value.learningSeconds,
            projectSeconds: e.value.projectSeconds,
            habitSeconds: e.value.habitSeconds,
          ),
        )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<List<PieSlice>> getPieData(DateTime start, DateTime end,
      [int? cardId]) async {
    final sessions = await _sessionDao.getSessionsInRange(start, end);
    final allCards = await _cardDao.getAllCards();
    final cardTypeMap = {
      for (final c in allCards) c.id: CardType.fromString(c.type),
    };

    int learningTotal = 0;
    int projectTotal = 0;
    int habitTotal = 0;

    for (final s in sessions) {
      if (cardId != null && s.cardId != cardId) continue;
      final type = cardTypeMap[s.cardId] ?? CardType.learning;
      switch (type) {
        case CardType.learning:
          learningTotal += s.totalWorkSeconds;
        case CardType.project:
          projectTotal += s.totalWorkSeconds;
        case CardType.habit:
          habitTotal += s.totalWorkSeconds;
      }
    }

    return [
      PieSlice(
        label: CardType.learning.displayName,
        totalSeconds: learningTotal,
        color: AppColors.chartLearning,
      ),
      PieSlice(
        label: CardType.project.displayName,
        totalSeconds: projectTotal,
        color: AppColors.chartProject,
      ),
      PieSlice(
        label: CardType.habit.displayName,
        totalSeconds: habitTotal,
        color: AppColors.chartHabit,
      ),
    ];
  }

  Future<List<StatsCard>> getAllCards() async {
    final allCards = await _cardDao.getAllCards();
    return allCards
        .map((card) => StatsCard(id: card.id, name: card.name))
        .toList();
  }
}

class _TypeBucket {
  int learningSeconds = 0;
  int projectSeconds = 0;
  int habitSeconds = 0;
}
