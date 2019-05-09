import 'dart:async';
import 'dart:convert';
import 'package:cbsa_mobile_app/app_translations.dart';
import 'package:cbsa_mobile_app/models/login.dart' as login;
import 'package:cbsa_mobile_app/models/setup.dart';
import 'package:cbsa_mobile_app/models/toilet_installation.dart';
import 'package:cbsa_mobile_app/models/user.dart';
import 'package:cbsa_mobile_app/scoped_model/initial_setup_model.dart';
import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
import 'package:cbsa_mobile_app/services/user_service.dart';
import 'package:cbsa_mobile_app/setup_models.dart/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Response;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var _email;
  var _password;
  bool _showPassword = false;
  SharedPreferences prefs;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Widget _emailTextField() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.email,
          ),
          labelText: AppTranslations.of(context).text("email"),
          hasFloatingPlaceholder: true,
          contentPadding: EdgeInsets.all(15.0),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return AppTranslations.of(context).text("required");
          }
        },
        onSaved: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _passwordTextField() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            child: (_showPassword ? Icon(Icons.lock_open) : Icon(Icons.lock)),
            onTap: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
          ),
          labelText: AppTranslations.of(context).text("password"),
          hasFloatingPlaceholder: true,
          contentPadding: EdgeInsets.all(15),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return AppTranslations.of(context).text("required");
          }
        },
        onSaved: (value) {
          _password = value;
        },
        obscureText: (_showPassword ? false : true),
      ),
    );
  }

  Widget _forgotPassword() {
    return GestureDetector(
      child: Text(AppTranslations.of(context).text("forgotPassword")),
      onTap: () {
        Navigator.pushNamed(context, '/forgotpassword');
      },
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text('$message'),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _loginButton(InitialSetupModel model) {
    return RaisedButton(
      child: Text(
        'LOG IN',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
      padding: EdgeInsets.all(13.0),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8.0)),
      onPressed: () async {
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          isloading = true;
        });
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          try{
            var user = login.LoginModel(email: this._email, password: this._password,device_token: prefs.getString('firebase_token'));
            print('Request' + user.toMap().toString());
            Response response = await UserService.login(user);
            var decodedJson = jsonDecode(response.body);
            var status = decodedJson['status'];
            
            print(decodedJson);

            if(status == 200) {
              
              UserObject userObject = UserObject.map(decodedJson['user']);
              prefs.setInt('id', userObject.userId);
              int userResult = await model.saveUserObject(userObject);
              
              model.saveTerritories(decodedJson['Territory']);
              
              model.saveSubTerritories(decodedJson['SubTerritory']);

              model.saveBlocks(decodedJson['Block']);
              
              model.saveLeadTypes(decodedJson['LeadType']);

              model.saveInformationSources(decodedJson['SourceOfInfo']);

              model.saveToiletTypes(decodedJson['ToiletType']);
              
              model.saveEnrollmentReasons(decodedJson['EnrollmentReason']);

              model.saveServiceProviders(decodedJson['TelephoneServerProvider']);
              
              model.saveTelephoneTypes(decodedJson['TelephoneType']);
              
              model.savePaidServices(decodedJson['PaidServices']);
              
              model.saveToiletPrivacy(decodedJson['ToiletPrivacy']);

              model.saveToiletTypesCA(decodedJson['ToiletTypeAccess']);
              
              model.saveToiletSecurity(decodedJson['ToiletSecurity']);

              model.saveItems(decodedJson['Items']);

              model.saveWorkOrders(decodedJson['WorkOrders']);

              model.saveWorkOrderItems(decodedJson['WorkOrderItems']);

              model.saveLeads(decodedJson['leads']);

              model.saveHealthInspectionSchedules(decodedJson['healthinspectionschedule']);

              model.saveLeadConversions(decodedJson['leadconversion']);

              model.saveCustomers(decodedJson['Customers']);

              model.saveToiletInstallations(decodedJson['Toiletinstall']);

              if(userResult == 1) {
                setState(() {
                  isloading = false;
                });
                prefs.setBool('isloggedin', true);
                Navigator.pushReplacementNamed(context, '/home');
              }
            } else {
              setState(() {
                isloading = false;
              });
              _showDialog('', 'Login Failed');
            }
          }catch(e){
            setState(() {
              isloading=false;
            });
          }
        }
      },
      color: Colors.cyan.shade300,
    );
  }

  Widget _faqLink() {
    return Padding(
      child: GestureDetector(
        child: Text(
          AppTranslations.of(context).text("faqs"),
          style: TextStyle(color: Colors.black),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/faq');
        },
      ),
      padding: EdgeInsets.fromLTRB(0, 0, 40, 10),
    );
  }

  Widget _termsOfUse() {
    return Padding(
      child: GestureDetector(
        child: Text(
          AppTranslations.of(context).text("termsOfUse"),
          style: TextStyle(color: Colors.black),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/termsofuse');
        },
      ),
      padding: EdgeInsets.fromLTRB(40, 0, 0, 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: new ScopedModel<InitialSetupModel>(
        model: new InitialSetupModel(),
        child: Scaffold(
          body: ModalProgressHUD(
            inAsyncCall: isloading,
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new ScopedModelDescendant<InitialSetupModel>(
                    builder: (context, child, model) {
                  return Form(
                    key: _formKey,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(40),
                      child: ListView(
                        padding: EdgeInsets.only(top: 100),
                        children: <Widget>[
                          Text(
                            'CBSA',
                            style: TextStyle(
                                fontSize: 45.0, color: Colors.cyan.shade300),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          _emailTextField(),
                          _passwordTextField(),
                          SizedBox(
                            height: 30.0,
                          ),
                          Row(
                            children: <Widget>[
                              Spacer(),
                              _forgotPassword(),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          _loginButton(model),
                        ],
                      ),
                    ),
                  );
                }),
                Positioned(
                    child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: _termsOfUse(),
                )),
                Positioned(
                    child: Align(
                  alignment: FractionalOffset.bottomRight,
                  child: _faqLink(),
                )),
              ],
            ),
          )
        )
      ),
    );
  }
}
