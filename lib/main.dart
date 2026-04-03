import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'services/notification_service.dart';
import 'data/repositories/prayer_repository.dart';

const _supabaseUrl = 'https://xpnsoabfznjlwiwcmrlf.supabase.co';
const _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
    'eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhwbnNvYWJmem5qbHdpd2NtcmxmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUxNjgyNTIsImV4cCI6MjA5MDc0NDI1Mn0.'
    'DDImy4LDepikeoYKTPhHmNaDHjfnFSJCX8LvBSvrjb4';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase initialization
  await Supabase.initialize(
    url: _supabaseUrl,
    anonKey: _supabaseAnonKey,
  );

  // Notification service initialization
  await NotificationService.instance.initialize();

  // Background sync: pull latest 30 days from Supabase into local DB
  // Fire-and-forget; errors are silently swallowed inside the repo.
  PrayerRepository.instance.syncFromRemote().ignore();

  runApp(
    const ProviderScope(
      child: SalahTrackerApp(),
    ),
  );
}
