import '../../core/constants/app_constants.dart';

class PrayerRecord {
  final String? id;
  final String date;        // 'yyyy-MM-dd'
  final String prayerName;  // e.g. 'Fajr'
  final PrayerStatus status;

  const PrayerRecord({
    this.id,
    required this.date,
    required this.prayerName,
    required this.status,
  });

  PrayerRecord copyWith({
    String? id,
    String? date,
    String? prayerName,
    PrayerStatus? status,
  }) {
    return PrayerRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      prayerName: prayerName ?? this.prayerName,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'date': date,
        'prayerName': prayerName,
        'status': status.key,
      };

  factory PrayerRecord.fromMap(Map<String, dynamic> map) => PrayerRecord(
        id: map['id']?.toString(),
        date: map['date'] as String,
        prayerName: map['prayerName'] as String,
        status: statusFromKey(map['status'] as String?),
      );

  @override
  String toString() =>
      'PrayerRecord(date: $date, prayer: $prayerName, status: ${status.key})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerRecord &&
          date == other.date &&
          prayerName == other.prayerName;

  @override
  int get hashCode => date.hashCode ^ prayerName.hashCode;
}
