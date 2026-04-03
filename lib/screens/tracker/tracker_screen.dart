import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/prayer_record.dart';
import '../../providers/prayer_provider.dart';

class TrackerScreen extends ConsumerWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final prayersAsync = ref.watch(dayPrayersProvider);
    final notifier = ref.read(dayPrayersProvider.notifier);
    final isToday = SalahDateUtils.isToday(SalahDateUtils.toKey(selectedDate));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Date Header ──────────────────────────────────────────────────
            _DateHeader(
              date: selectedDate,
              isToday: isToday,
              onPrev: notifier.previousDay,
              onNext: notifier.nextDay,
              onToday: notifier.goToToday,
            ),

            const SizedBox(height: 8),

            // ── Prayer Cards ─────────────────────────────────────────────────
            Expanded(
              child: prayersAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.softEmerald),
                ),
                error: (e, _) => Center(
                  child: Text('Error loading prayers: $e'),
                ),
                data: (records) => ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final record = records[i];
                    return _PrayerCard(
                      index: i,
                      record: record,
                      onTap: () => _showStatusSheet(context, ref, record),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusSheet(
      BuildContext context, WidgetRef ref, PrayerRecord record) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _StatusSheet(record: record, ref: ref),
    );
  }
}

// ── Date Header Widget ────────────────────────────────────────────────────────

class _DateHeader extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToday;

  const _DateHeader({
    required this.date,
    required this.isToday,
    required this.onPrev,
    required this.onNext,
    required this.onToday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 28),
                color: AppColors.lightText,
                onPressed: onPrev,
                tooltip: 'Previous day',
              ),
              GestureDetector(
                onTap: isToday ? null : onToday,
                child: Column(
                  children: [
                    Text(
                      isToday ? 'Today' : SalahDateUtils.shortDate(date),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: isToday
                            ? AppColors.softEmerald
                            : AppColors.lightText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      SalahDateUtils.displayDate(date),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right_rounded,
                  size: 28,
                  color: isToday ? AppColors.grey : AppColors.lightText,
                ),
                onPressed: isToday ? null : onNext,
                tooltip: 'Next day',
              ),
            ],
          ),
          if (!isToday) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onToday,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.softEmerald.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.softEmerald.withValues(alpha: 0.4)),
                ),
                child: Text(
                  'Back to Today',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.softEmerald,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Prayer Card ───────────────────────────────────────────────────────────────

class _PrayerCard extends StatelessWidget {
  final int index;
  final PrayerRecord record;
  final VoidCallback onTap;

  const _PrayerCard({
    required this.index,
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = record.status;
    final statusColor = status.color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: status == PrayerStatus.none
              ? AppColors.surface3
              : statusColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: statusColor.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                // Prayer icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.deepGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    kPrayerIcons[index],
                    color: AppColors.softEmerald,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Prayer name + arabic
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.prayerName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        kPrayerArabic[index],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status pill
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(status.icon, color: statusColor, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        status.label,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: statusColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Status Bottom Sheet ───────────────────────────────────────────────────────

class _StatusSheet extends ConsumerWidget {
  final PrayerRecord record;
  final WidgetRef ref;

  const _StatusSheet({required this.record, required this.ref});

  static const _statuses = [
    PrayerStatus.onTime,
    PrayerStatus.qaza,
    PrayerStatus.missed,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            record.prayerName,
            style: theme.textTheme.headlineMedium,
          ),
          Text(
            'Select prayer status',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          ...List.generate(_statuses.length, (i) {
            final s = _statuses[i];
            final isSelected = record.status == s;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _StatusOption(
                status: s,
                isSelected: isSelected,
                onTap: () async {
                  await ref
                      .read(dayPrayersProvider.notifier)
                      .updateStatus(record.prayerName, s);
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  final PrayerStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusOption({
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = status.color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.2) : AppColors.surface3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? color : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(status.icon, color: color, size: 22),
                const SizedBox(width: 16),
                Text(
                  status.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isSelected ? color : AppColors.lightText,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(Icons.check_rounded, color: color, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
