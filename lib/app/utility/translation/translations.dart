import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_artist_demo/app/utility/constant.dart';
import 'package:my_artist_demo/app/utility/shared_prefs.dart';


class Translations {
  Translations(this.locale) {
    _localizedValues = {};
  }

  late Locale locale;
  static Map<dynamic, dynamic> _localizedValues = {};

  static Translations? of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  String text(String key) {
    return _localizedValues[key] ?? '** $key not found';
  }

  static Future<Translations> load(Locale locale) async {
    Translations translations = Translations(locale);
    String? localeName = "en";
    if (SharedPrefs.instance.getString(Constants.LANGUAGE_ISO_CODE) != null) {
      localeName = SharedPrefs.instance.getString(Constants.LANGUAGE_ISO_CODE);
    }
    String jsonContent =
        await rootBundle.loadString("locale/i18n_$localeName.json");
    _localizedValues = json.decode(jsonContent);
    return translations;
  }

  get currentLanguage => locale.languageCode;
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'hi', 'gu'].contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) => Translations.load(locale);

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}
