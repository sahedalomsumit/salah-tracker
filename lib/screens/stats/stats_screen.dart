import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/stats_provider.dart';
import '../../providers/prayer_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(statsProvider.notifier).refresh();
              // ignore: unused_result
              ref.refresh(dayPrayersProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: statsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.softEmerald),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (stats) => RefreshIndicator(
          color: AppColors.softEmerald,
          backgroundColor: AppColors.surface1,
          onRefresh: () => ref.read(statsProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              // ── Streak Card ─────────────────────────────────────────────
              _StreakCard(streak: stats.streak),
              const SizedBox(height: 16),

              // ── Daily / Weekly / Monthly ─────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _StatMiniCard(
                      label: 'Today',
                      percent: stats.todayPercent,
                      color: AppColors.softEmerald,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatMiniCard(
                      label: 'This Week',
                      percent: stats.weeklyPercent,
                      color: const Color(0xFF5C9BD6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatMiniCard(
                      label: 'This Month',
                      percent: stats.monthlyPercent,
                      color: const Color(0xFFAB7EDB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Weekly Bar Chart ──────────────────────────────────────────
              _WeeklyBarChart(
                percents: stats.weeklyDailyPercents,
                labels: stats.weeklyLabels,
              ),
              const SizedBox(height: 20),

              // ── Status Pie Chart ──────────────────────────────────────────
              _StatusPieChart(aggregate: stats.weeklyAggregate),
              const SizedBox(height: 20),

              // ── Monthly Summary ────────────────────────────────────────────
              _MonthlySummaryCard(aggregate: stats.monthlyAggregate),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Streak Card ───────────────────────────────────────────────────────────────

class _StreakCard extends StatelessWidget {
  final int streak;
  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.deepGreen, AppColors.softEmerald],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.softEmerald.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Streak',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightText.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$streak',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        color: AppColors.lightText,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        streak == 1 ? 'day' : 'days',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.lightText.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  streak == 0
                      ? 'Start logging prayers to build your streak!'
                      : 'No missed prayers — keep it up! 💪',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.lightText.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.orangeAccent,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mini Stat Card ────────────────────────────────────────────────────────────

class _StatMiniCard extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;

  const _StatMiniCard({
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            '${percent.toStringAsFixed(0)}%',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Weekly Bar Chart ──────────────────────────────────────────────────────────

class _WeeklyBarChart extends StatelessWidget {
  final List<double> percents;
  final List<String> labels;

  const _WeeklyBarChart({required this.percents, required this.labels});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('7-Day Overview', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Daily completion percentage',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: percents.isEmpty
                ? const Center(
                    child: Text('No data yet',
                        style: TextStyle(color: AppColors.grey)))
                : BarChart(
                    BarChartData(
                      maxY: 100,
                      minY: 0,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipPadding: const EdgeInsets.all(8),
                          tooltipMargin: 6,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${rod.toY.toStringAsFixed(0)}%',
                              const TextStyle(
                                color: AppColors.lightText,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                            interval: 50,
                            getTitlesWidget: (value, _) => Text(
                              '${value.toInt()}%',
                              style: const TextStyle(
                                  color: AppColors.grey, fontSize: 10),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              final i = value.toInt();
                              if (i < 0 || i >= labels.length) {
                                return const SizedBox();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  labels[i],
                                  style: const TextStyle(
                                      color: AppColors.grey, fontSize: 11),
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 50,
                        getDrawingHorizontalLine: (_) => const FlLine(
                          color: AppColors.surface3,
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(percents.length, (i) {
                        final pct = percents[i];
                        Color barColor;
                        if (pct >= 80) {
                          barColor = AppColors.softEmerald;
                        } else if (pct >= 40) {
                          barColor = AppColors.qaza;
                        } else {
                          barColor = pct == 0
                              ? AppColors.grey.withValues(alpha: 0.3)
                              : AppColors.missed;
                        }
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: pct,
                              color: barColor,
                              width: 22,
                              borderRadius: BorderRadius.circular(6),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 100,
                                color: barColor.withValues(alpha: 0.08),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Pie Chart ─────────────────────────────────────────────────────────────────

class _StatusPieChart extends StatefulWidget {
  final Map<String, int> aggregate;
  const _StatusPieChart({required this.aggregate});

  @override
  State<_StatusPieChart> createState() => _StatusPieChartState();
}

class _StatusPieChartState extends State<_StatusPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onTime = widget.aggregate['onTime'] ?? 0;
    final qaza = widget.aggregate['qaza'] ?? 0;
    final missed = widget.aggregate['missed'] ?? 0;
    final total = onTime + qaza + missed;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Distribution', style: theme.textTheme.titleMedium),
          Text('Prayer status breakdown', style: theme.textTheme.bodySmall),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: total == 0
                    ? const Center(
                        child: Text('No data',
                            style: TextStyle(color: AppColors.grey)))
                    : PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  _touchedIndex = -1;
                                  return;
                                }
                                _touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 3,
                          centerSpaceRadius: 38,
                          sections: [
                            _pieSection(
                                onTime, total, AppColors.onTime, 'On Time', 0),
                            _pieSection(qaza, total, AppColors.qaza, 'Qaza', 1),
                            _pieSection(
                                missed, total, AppColors.missed, 'Missed', 2),
                          ],
                        ),
                      ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LegendItem(
                        color: AppColors.onTime,
                        label: 'On Time',
                        count: onTime),
                    const SizedBox(height: 12),
                    _LegendItem(
                        color: AppColors.qaza, label: 'Qaza', count: qaza),
                    const SizedBox(height: 12),
                    _LegendItem(
                        color: AppColors.missed,
                        label: 'Missed',
                        count: missed),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PieChartSectionData _pieSection(
      int value, int total, Color color, String title, int index) {
    final isTouched = index == _touchedIndex;
    final radius = isTouched ? 55.0 : 46.0;
    final pct = total == 0 ? 0.0 : (value / total * 100);
    return PieChartSectionData(
      color: color,
      value: value.toDouble(),
      radius: radius,
      title: pct >= 10 ? '${pct.toStringAsFixed(0)}%' : '',
      titleStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;

  const _LegendItem(
      {required this.color, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: theme.textTheme.bodyMedium),
        ),
        Text(
          '$count',
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}

// ── Monthly Summary Card ──────────────────────────────────────────────────────

class _MonthlySummaryCard extends StatelessWidget {
  final Map<String, int> aggregate;
  const _MonthlySummaryCard({required this.aggregate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onTime = aggregate['onTime'] ?? 0;
    final qaza = aggregate['qaza'] ?? 0;
    final missed = aggregate['missed'] ?? 0;
    final total = onTime + qaza + missed;
    final pct = total == 0 ? 0.0 : (onTime / total * 100);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Monthly Summary', style: theme.textTheme.titleMedium),
          Text('Current calendar month', style: theme.textTheme.bodySmall),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MonthStat(
                  value: onTime, label: 'On Time', color: AppColors.onTime),
              _MonthStat(value: qaza, label: 'Qaza', color: AppColors.qaza),
              _MonthStat(
                  value: missed, label: 'Missed', color: AppColors.missed),
              _MonthStat(
                  value: total, label: 'Total', color: AppColors.softEmerald),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Completion rate',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct / 100,
              backgroundColor: AppColors.softEmerald.withValues(alpha: 0.15),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.softEmerald),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${pct.toStringAsFixed(1)}% prayers on time',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.softEmerald,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthStat extends StatelessWidget {
  final int value;
  final String label;
  final Color color;

  const _MonthStat(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          '$value',
          style: theme.textTheme.headlineLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
