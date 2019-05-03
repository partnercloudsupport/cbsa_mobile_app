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
  String _language = 'Language A';
  List<String> _languageList = ['Language A', 'Language B', 'Language C', 'Language D'];
  String _firstName;
  String _lastName;
  String _subDomain;

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
                        labelText: 'First Name', hasFloatingPlaceholder: true),
                      onChanged: (value) {
                        setState(() {
                          this._firstName = value;
                        });
                      }
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Last Name', hasFloatingPlaceholder: true),
                      onChanged: (value) {
                        setState(() {
                          this._lastName = value;
                        });
                      }
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Organization Name', hasFloatingPlaceholder: true),
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
                        Text('Select Language'),
                        DropdownButton<String>(
                          value: _language,
                          items: _languageList.map((language) {
                            return DropdownMenuItem<String>(
                              value: language,
                              child: Text(language),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              this._language = value;
                            });
                          },
                        )
                      ],
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Sub-Domain Name', hasFloatingPlaceholder: true),
                      onChanged: (value) {
                        setState(() {
                          this._subDomain = value;
                        });
                      }
                    ),
                    Divider(),
                    RaisedButton(
                      child: Text('Submit'),
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