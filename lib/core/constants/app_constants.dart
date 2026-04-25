import 'package:flutter/material.dart';

// ── Prayer names ─────────────────────────────────────────────────────────────
const List<String> kPrayerKeys = [
  'prayer_fajr',
  'prayer_dhuhr',
  'prayer_asr',
  'prayer_maghrib',
  'prayer_isha',
];

const List<String> kPrayerNames = [
  'Fajr',
  'Dhuhr',
  'Asr',
  'Maghrib',
  'Isha',
];

const List<String> kPrayerArabic = [
  'الفجر',
  'الظهر', // Or 'الجمعة' on Fridays
  'العصر',
  'المغرب',
  'العشاء',
];

const String kJummahArabic = 'الجمعة';

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
  String get labelKey {
    switch (this) {
      case PrayerStatus.onTime: return 'status_on_time';
      case PrayerStatus.qaza:   return 'status_qaza';
      case PrayerStatus.missed: return 'status_missed';
      case PrayerStatus.none:   return 'status_none';
    }
  }

  // Fallback English label (used where BuildContext isn't available)
  String get label {
    switch (this) {
      case PrayerStatus.onTime: return 'On Time';
      case PrayerStatus.qaza:   return 'Qaza';
      case PrayerStatus.missed: return 'Missed';
      case PrayerStatus.none:   return 'Not logged';
    }
  }

  String get key {
    switch (this) {
      case PrayerStatus.onTime: return 'onTime';
      case PrayerStatus.qaza:   return 'qaza';
      case PrayerStatus.missed: return 'missed';
      case PrayerStatus.none:   return 'none';
    }
  }

  Color get color {
    switch (this) {
      case PrayerStatus.onTime: return AppColors.onTime;
      case PrayerStatus.qaza:   return AppColors.qaza;
      case PrayerStatus.missed: return AppColors.missed;
      case PrayerStatus.none:   return AppColors.statusNone;
    }
  }

  IconData get icon {
    switch (this) {
      case PrayerStatus.onTime: return Icons.check_circle_rounded;
      case PrayerStatus.qaza:   return Icons.schedule_rounded;
      case PrayerStatus.missed: return Icons.cancel_rounded;
      case PrayerStatus.none:   return Icons.radio_button_unchecked_rounded;
    }
  }
}

PrayerStatus statusFromKey(String? key) {
  switch (key) {
    case 'onTime': return PrayerStatus.onTime;
    case 'qaza':   return PrayerStatus.qaza;
    case 'missed': return PrayerStatus.missed;
    default:       return PrayerStatus.none;
  }
}

// ── App colors ────────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // Brand
  static const softEmerald = Color(0xFF2E9C7E);
  static const deepGreen   = Color(0xFF1B3B34);
  static const emeraldGlow = Color(0xFF3DBFA0);

  // Text
  static const darkText    = Color(0xFF1A1A1A);
  static const lightText   = Color(0xFFFFFFFF);
  static const grey        = Color(0xFF8A9A96);

  // Status
  static const onTime     = Color(0xFF4CAF50);
  static const qaza       = Color(0xFFFF9800);
  static const missed     = Color(0xFFF44336);
  static const statusNone = Color(0xFF546E65);

  // ── Dark theme surfaces ───────────────────────────────────────────────────
  static const darkBackground = Color(0xFF0A0F0D);
  static const surface1Dark   = Color(0xFF111A17);
  static const surface2Dark   = Color(0xFF182420);
  static const surface3Dark   = Color(0xFF1F2E29);
  // Glass card: semi-transparent + blur
  static const glassCard      = Color(0x1AFFFFFF); // white 10%
  static const glassBorder    = Color(0x33FFFFFF); // white 20%

  // ── Light theme surfaces ──────────────────────────────────────────────────
  static const lightBackground = Color(0xFFF4F7F5);
  static const surface1Light   = Color(0xFFFFFFFF);
  static const surface2Light   = Color(0xFFEDF4F1);
  static const surface3Light   = Color(0xFFDCEDE8);
  static const lightGlassCard  = Color(0xB3FFFFFF); // white 70%
  static const lightGlassBorder = Color(0x66FFFFFF); // white 40%

  // Warm beige accents (light)
  static const warmBeige  = Color(0xFFF5F3EF);
  static const mutedSand  = Color(0xFFE8E3D9);
}
