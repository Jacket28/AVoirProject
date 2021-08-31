import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Translations {
  Translations(Locale locale) {
    this.locale = locale;
  }

  late Locale locale;
  static Translations? of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  late Map<String, String> _localizedValues;

  Future<void> load() async {
    String jsonStringValues = await rootBundle
        .loadString("lib/locale/i18n_${locale.languageCode}.json");
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return _localizedValues[key] ?? '** $key not found';
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<Translations> delegate =
      _TranslationDelegate();
}

class _TranslationDelegate extends LocalizationsDelegate<Translations> {
  const _TranslationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<Translations> load(Locale locale) async {
    Translations localization = new Translations(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<Translations> old) => false;
}

  /*
  Translations(Locale locale) {
    this.locale = locale;
    _localizedValues = null;
  }

  final Locale locale;
  static Map<dynamic, dynamic>? _localizedValues;

  static Translations? of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  String text(String key) {
    return _localizedValues?[key] ?? '** $key not found';
  }

  static Future<Translations> load(Locale locale) async {
    Translations translations = new Translations(locale);
    String jsonContent = await rootBundle
        .loadString("lib/locale/i18n_${locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);
    return translations;
  }

  get currentLanguage => locale.languageCode;
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) async {
    Translations localization = new Translations(locale);
    await Translations.load(locale);
    return localization;
  }

  @override
  bool shouldReload(TranslationsDelegate old) => false;
  */

