import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

const _supportedLocales = [Locale('en'), Locale('bn')];

List<Locale> get appSupportedLocales => _supportedLocales;

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() => const Locale('en');

  Future<void> setLocale(BuildContext context, Locale locale) async {
    state = locale;
    await context.setLocale(locale);
  }
}
