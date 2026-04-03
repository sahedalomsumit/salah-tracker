import 'package:flutter/material.dart';

// ── Prayer names ─────────────────────────────────────────────────────────────
const List<String> kPrayerNames = [
  'Fajr',
  'Dhuhr',
  'Asr',
  'Maghrib',
  'Isha',
];

const List<String> kPrayerArabic = [
  'الفجر',
  'الظهر',
  'العصر',
  'المغرب',
  'العشاء',
];

// ── Prayer icons (approximate times) ─────────────────────────────────────────
const List<IconData> kPrayerIcons = [
  Icons.nightlight_round,     // Fajr    – pre-dawn
  Icons.wb_sunny_outlined,    // Dhuhr   – midday
  Icons.light_mode_outlined,  // Asr     – afternoon
  Icons.wb_twilight_outlined, // Maghrib – sunset
  Icons.nights_stay_outlined, // Isha    – night
];

// ── Prayer status ─────────────────────────────────────────────────────────────
enum PrayerStatus {
  onTime,
  qaza,
  missed,
  none,
}

extension PrayerStatusX on PrayerStatus {
  String get label {
    switch (this) {
      case PrayerStatus.onTime:
        return 'On Time';
      case PrayerStatus.qaza:
        return 'Qaza';
      case PrayerStatus.missed:
        return 'Missed';
      case PrayerStatus.none:
        return 'Not logged';
    }
  }

  String get key {
    switch (this) {
      case PrayerStatus.onTime:
        return 'onTime';
      case PrayerStatus.qaza:
        return 'qaza';
      case PrayerStatus.missed:
        return 'missed';
      case PrayerStatus.none:
        return 'none';
    }
  }

  Color get color {
    switch (this) {
      case PrayerStatus.onTime:
        return const Color(0xFF4CAF50);
      case PrayerStatus.qaza:
        return const Color(0xFFFF9800);
      case PrayerStatus.missed:
        return const Color(0xFFF44336);
      case PrayerStatus.none:
        return const Color(0xFF444444);
    }
  }

  IconData get icon {
    switch (this) {
      case PrayerStatus.onTime:
        return Icons.check_circle_rounded;
      case PrayerStatus.qaza:
        return Icons.schedule_rounded;
      case PrayerStatus.missed:
        return Icons.cancel_rounded;
      case PrayerStatus.none:
        return Icons.radio_button_unchecked_rounded;
    }
  }
}

PrayerStatus statusFromKey(String? key) {
  switch (key) {
    case 'onTime':
      return PrayerStatus.onTime;
    case 'qaza':
      return PrayerStatus.qaza;
    case 'missed':
      return PrayerStatus.missed;
    default:
      return PrayerStatus.none;
  }
}

// ── App colors ────────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  static const deepGreen   = Color(0xFF1F3D36);
  static const softEmerald = Color(0xFF2E7D6B);
  static const warmBeige   = Color(0xFFF5F3EF);
  static const mutedSand   = Color(0xFFE8E3D9);
  static const darkText    = Color(0xFF1A1A1A);
  static const lightText   = Color(0xFFFFFFFF);
  static const grey        = Color(0xFF8A8A8A);

  // Status
  static const onTime = Color(0xFF4CAF50);
  static const qaza   = Color(0xFFFF9800);
  static const missed = Color(0xFFF44336);

  // Dark surface shades
  static const surface1 = Color(0xFF1E2D28);
  static const surface2 = Color(0xFF243530);
  static const surface3 = Color(0xFF2A3E38);
}
