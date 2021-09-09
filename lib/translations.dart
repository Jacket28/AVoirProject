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

  //load json file to simplify multiple languages
  Future<void> load() async {
    String jsonStringValues = await rootBundle
        .loadString("lib/locale/i18n_${locale.languageCode}.json");
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  //give the key to find the translated value
  String? translate(String key) {
    return _localizedValues[key];
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<Translations> delegate =
      _TranslationDelegate();
}

class _TranslationDelegate extends LocalizationsDelegate<Translations> {
  const _TranslationDelegate();

  //linked to the supportedLocales
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
