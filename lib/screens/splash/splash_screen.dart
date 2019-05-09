import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/setup.dart';
import 'package:cbsa_mobile_app/scoped_model/initial_setup_model.dart';
import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
import 'package:cbsa_mobile_app/screens/home/home_screen.dart';
import 'package:cbsa_mobile_app/screens/login/login_screen.dart';
import 'package:cbsa_mobile_app/screens/login/set_up_screen.dart';
import 'package:cbsa_mobile_app/setup_models.dart/user.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Map _currentUser;
  SharedPreferences prefs;

  Future<Setups> _fetchUser() async {
    var db = new DatabaseHelper();
    var setup = await db.getSetup();
    
    return setup;
  }

  void initState() {
    super.initState();
    
    _initSharedPreferences();
  }

  _initSharedPreferences() async{
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchUser(),
      builder: (BuildContext context, AsyncSnapshot<Setups> snapshot) {
        return SplashScreen(
          seconds: 4,
          navigateAfterSeconds: snapshot.data!= null? (((prefs.getBool('isloggedin') == null) || (prefs.getBool('isloggedin') == false)) ?  Login() : Home()) : SetUp(),
          image: Image.asset('assets/logo.jpg'),
          photoSize: 150.0,
          loadingText: Text('Loading'),
          loaderColor: Colors.cyan.shade300,
          styleTextUnderTheLoader: TextStyle(fontSize: 25.0),
        );
      },
    );
  }
}

