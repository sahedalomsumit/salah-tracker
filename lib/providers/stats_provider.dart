import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/prayer_record.dart';
import '../data/repositories/prayer_repository.dart';
import '../core/utils/date_utils.dart';
import '../core/utils/calculation_utils.dart';

// ── Stats state model ─────────────────────────────────────────────────────────

class StatsState {
  final int streak;
  final double todayPercent;
  final double weeklyPercent;
  final double monthlyPercent;
  final Map<String, int> weeklyAggregate;   // {onTime, qaza, missed, none}
  final Map<String, int> monthlyAggregate;
  final List<double> weeklyDailyPercents;   // 7 values for bar chart
  final List<String> weeklyLabels;

  const StatsState({
    this.streak = 0,
    this.todayPercent = 0,
    this.weeklyPercent = 0,
    this.monthlyPercent = 0,
    this.weeklyAggregate = const {},
    this.monthlyAggregate = const {},
    this.weeklyDailyPercents = const [],
    this.weeklyLabels = const [],
  });
}

// ── Provider ──────────────────────────────────────────────────────────────────

final statsProvider = AsyncNotifierProvider<StatsNotifier, StatsState>(
  StatsNotifier.new,
);

class StatsNotifier extends AsyncNotifier<StatsState> {
  PrayerRepository get _repo => PrayerRepository.instance;

  @override
  Future<StatsState> build() async {
    return _computeStats();
  }

  Future<StatsState> _computeStats() async {
    final today = DateTime.now();
    final todayKey = SalahDateUtils.toKey(today);

    // Get today's records
    final todayRecords = await _repo.getDayRecords(todayKey);

    // Get weekly records (last 7 days)
    final weekDays = SalahDateUtils.lastNDays(7);
    final weekMap = await _repo.getMultiDayRecords(weekDays);

    // Get monthly records
    final monthDays = SalahDateUtils.currentMonth();
    final monthMap = await _repo.getMultiDayRecords(monthDays);

    // Streak: needs all records
    final allRecords = await _repo.getAllRecords();
    final allGrouped = <String, List<PrayerRecord>>{};
    for (final r in allRecords) {
      allGrouped.putIfAbsent(r.date, () => []).add(r);
    }

    final streak = CalcUtils.calculateStreak(allGrouped);
    final todayPct = CalcUtils.dailyCompletionPercent(todayRecords);
    final weekPct = CalcUtils.overallPercent(weekMap);
    final monthPct = CalcUtils.overallPercent(monthMap);
    final weekAgg = CalcUtils.aggregateStatus(weekMap);
    final monthAgg = CalcUtils.aggregateStatus(monthMap);

    final weekKeys = weekDays.map(SalahDateUtils.toKey).toList();
    final weekDailyPcts = CalcUtils.dailyPercents(weekKeys, weekMap);
    final weekLabels =
        weekDays.map((d) => SalahDateUtils.dayAbbr(d)).toList();

    return StatsState(
      streak: streak,
      todayPercent: todayPct,
      weeklyPercent: weekPct,
      monthlyPercent: monthPct,
      weeklyAggregate: weekAgg,
      monthlyAggregate: monthAgg,
      weeklyDailyPercents: weekDailyPcts,
      weeklyLabels: weekLabels,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_computeStats);
  }
}
