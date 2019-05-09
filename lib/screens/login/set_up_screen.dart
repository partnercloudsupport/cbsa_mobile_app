import 'package:cbsa_mobile_app/app_translations.dart';
import 'package:cbsa_mobile_app/application.dart';
import 'package:cbsa_mobile_app/models/setup.dart';
import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
import 'package:cbsa_mobile_app/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SetUp extends StatefulWidget {
  @override
  _SetUpState createState() => _SetUpState();
}

class _SetUpState extends State<SetUp> {
  String _organizationName;
  String _language;
  String _firstName;
  String _lastName;
  String _subDomain;

  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList = application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: ScopedModel<TaskModel>(
          model: TaskModel(),
          child: ScopedModelDescendant<TaskModel>(
            builder: (context, child, model) {
              // model.fetchSetup();
              return Container(
                padding: EdgeInsets.all(30),
                child: ListView(
                  children: <Widget>[
                    Container(
                      alignment: FractionalOffset.center,
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
                      child: Text('Set Up', style: TextStyle(fontSize: 18),),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppTranslations.of(context).text("firstName"), hasFloatingPlaceholder: true),
                      onChanged: (value) {
                        setState(() {
                          this._firstName = value;
                        });
                      }
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppTranslations.of(context).text("lastName"), hasFloatingPlaceholder: true),
                      onChanged: (value) {
                        setState(() {
                          this._lastName = value;
                        });
                      }
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppTranslations.of(context).text("organizationName"), hasFloatingPlaceholder: true),
                      onChanged: (value) {
                        setState(() {
                          this._organizationName = value;
                        });
                      }
                    ),
                    Divider(),
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
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppTranslations.of(context).text("subDomainName"), hasFloatingPlaceholder: true),
                      onChanged: (value) {
                        setState(() {
                          this._subDomain = value;
                        });
                      }
                    ),
                    Divider(),
                    RaisedButton(
                      child: Text(AppTranslations.of(context).text("submit")),
                      onPressed: () async {
                        Setups setup = Setups(_firstName, _lastName, _organizationName, _language, _subDomain);
                        await model.addSetup(setup);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                        // print({'First Name': _firstName, 'Last Name': _lastName, 'Organization': _organizationName, 'Language': _language, 'Sub-Domain': _subDomain});
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}