import 'package:cbsa_mobile_app/app_translations.dart';
import 'package:cbsa_mobile_app/application.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _language;
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList = application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(AppTranslations.of(context).text("selectLanguage")),
                DropdownButton<String>(
                  hint: Text(AppTranslations.of(context).text("language")),
                  value: _language,
                  items: languagesList.map((language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      print(value);
                      this._language = value;
                    });
                    application.onLocaleChanged(Locale(languagesMap[value]));
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}