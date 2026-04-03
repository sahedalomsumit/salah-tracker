import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../services/notification_service.dart';

// ── Settings providers ────────────────────────────────────────────────────────

final notificationsEnabledProvider =
    StateNotifierProvider<NotifToggleNotifier, Map<String, bool>>((ref) {
  return NotifToggleNotifier();
});

class NotifToggleNotifier extends StateNotifier<Map<String, bool>> {
  NotifToggleNotifier() : super({}) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, bool>{};
    for (final name in kPrayerNames) {
      map[name] = prefs.getBool('notif_$name') ?? true;
    }
    state = map;
  }

  Future<void> toggle(String prayerName) async {
    final current = state[prayerName] ?? true;
    final updated = {...state, prayerName: !current};
    state = updated;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_$prayerName', !current);

    final index = kPrayerNames.indexOf(prayerName);
    if (!current) {
      // Enabling — schedule a placeholder daily notification
      await NotificationService.instance.schedulePrayerReminder(
        id: index,
        prayerName: prayerName,
        hour: 6 + index * 3, // placeholder hours
        minute: 0,
      );
    } else {
      // Disabling
      await NotificationService.instance.cancelReminder(index);
    }
  }
}

// ── Settings Screen ───────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifMap = ref.watch(notificationsEnabledProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Prayer Reminders Section ──────────────────────────────────────
          const _SectionHeader(label: 'Prayer Reminders'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface1,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: List.generate(kPrayerNames.length, (i) {
                final name = kPrayerNames[i];
                final enabled = notifMap[name] ?? true;
                return Column(
                  children: [
                    _ReminderTile(
                      prayerName: name,
                      arabicName: kPrayerArabic[i],
                      icon: kPrayerIcons[i],
                      enabled: enabled,
                      onToggle: () => ref
                          .read(notificationsEnabledProvider.notifier)
                          .toggle(name),
                    ),
                    if (i < kPrayerNames.length - 1)
                      const Divider(
                        indent: 20,
                        endIndent: 20,
                        height: 1,
                      ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 24),

          // ── About Card ────────────────────────────────────────────────────
          const _SectionHeader(label: 'About'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface1,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // App logo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.deepGreen, AppColors.softEmerald],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.mosque_rounded,
                      color: AppColors.lightText, size: 34),
                ),
                const SizedBox(height: 12),
                Text(
                  'Salah Tracker',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Track your 5 daily prayers and build consistency '
                  'through simple, mindful logging.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Supabase badge ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface1,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.cloud_done_rounded,
                      color: Color(0xFF3ECF8E), size: 20),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cloud Sync', style: theme.textTheme.titleMedium),
                    Text(
                      'Powered by Supabase',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF3ECF8E), size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
    );
  }
}

// ── Reminder Tile ─────────────────────────────────────────────────────────────

class _ReminderTile extends StatelessWidget {
  final String prayerName;
  final String arabicName;
  final IconData icon;
  final bool enabled;
  final VoidCallback onToggle;

  const _ReminderTile({
    required this.prayerName,
    required this.arabicName,
    required this.icon,
    required this.enabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.deepGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.softEmerald, size: 20),
      ),
      title: Text(prayerName, style: theme.textTheme.titleMedium),
      subtitle: Text(arabicName,
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 13)),
      trailing: Switch(
        value: enabled,
        onChanged: (_) => onToggle(),
      ),
    );
  }
}
