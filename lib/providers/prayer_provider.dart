import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/prayer_record.dart';
import '../data/repositories/prayer_repository.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/date_utils.dart';

/// State: map of prayerName → PrayerRecord for the selected day
typedef DayPrayerState = AsyncValue<List<PrayerRecord>>;

/// Currently viewed date
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// Prayer records for the selected date
final dayPrayersProvider =
    AsyncNotifierProvider<DayPrayersNotifier, List<PrayerRecord>>(
  DayPrayersNotifier.new,
);

class DayPrayersNotifier extends AsyncNotifier<List<PrayerRecord>> {
  PrayerRepository get _repo => PrayerRepository.instance;

  @override
  Future<List<PrayerRecord>> build() async {
    // Watch selected date so we reload when it changes
    final date = ref.watch(selectedDateProvider);
    return _loadDay(SalahDateUtils.toKey(date));
  }

  Future<List<PrayerRecord>> _loadDay(String dateKey) =>
      _repo.getDayRecords(dateKey);

  /// Update a prayer's status for the current day
  Future<void> updateStatus(String prayerName, PrayerStatus status) async {
    final date = SalahDateUtils.toKey(ref.read(selectedDateProvider));

    // Optimistic update
    final current = state.valueOrNull ?? [];
    state = AsyncData(
      current.map((r) {
        if (r.prayerName == prayerName) return r.copyWith(status: status);
        return r;
      }).toList(),
    );

    // Persist
    await _repo.updateStatus(
      date: date,
      prayerName: prayerName,
      status: status,
    );
  }

  /// Navigate to previous day
  void previousDay() {
    ref.read(selectedDateProvider.notifier).update(
          (d) => d.subtract(const Duration(days: 1)),
        );
  }

  /// Navigate to next day (can't go beyond today)
  void nextDay() {
    ref.read(selectedDateProvider.notifier).update((d) {
      final next = d.add(const Duration(days: 1));
      if (next.isAfter(DateTime.now())) return d;
      return next;
    });
  }

  /// Go back to today
  void goToToday() {
    ref.read(selectedDateProvider.notifier).state = DateTime.now();
  }
}
