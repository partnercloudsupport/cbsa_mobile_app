import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/setup.dart';

class BaseService {
  static Future<String> fetchSubDomain() async{
    var db = new DatabaseHelper();
    Setups mysetup = await db.getSetup();
    return "http://${mysetup.subDomain}.verisan.app/api/";
  }

  static Map<String,String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  };
}