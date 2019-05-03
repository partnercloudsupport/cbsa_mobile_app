import 'dart:convert';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/toilet_servicing.dart';
import 'package:cbsa_mobile_app/services/toiletServicing_service.dart';
import 'package:http/http.dart';
import 'package:scoped_model/scoped_model.dart';

class ToiletServicingsModel extends Model {
  List _records = [];
  List get records => _records;
  List _barrelcounts = [];
  List get barrelcounts => _barrelcounts;
  List _interruptionTypes = [];
  List get interruptionTypes => _interruptionTypes;
  int _id ;
  int get id => _id;
  BarrelCountModel _barrelcount;
  BarrelCountModel get barrelcount => _barrelcount;

  fetchServicedToilets(int id) async {
    Response response = await ToiletServicingService.fetchServicedToilets(id);
    _records = List.from(jsonDecode(response.body));
    notifyListeners();
  }

  saveBarrelCount(BarrelCountModel barrelcount) async {
    var db = new DatabaseHelper();
    int a = await db.saveBarrelCount(barrelcount);
    notifyListeners();
    return a;
  }

  getBarrelCounts() async {
    var db = new DatabaseHelper();
    _barrelcounts = await db.getBarrelCount();
    notifyListeners();
  }

  getInterruptionTypes() async {
    var db = new DatabaseHelper();
    _interruptionTypes = await db.getInterruptionTypes();
    notifyListeners();
  }

  updateBarrelCounts(BarrelCountModel barrelcount) async {
    var db = new DatabaseHelper();
    int a = await db.updateBarrelCount(barrelcount);
    notifyListeners();
  }

  deleteBarrelCounts(int id) async {
    var db = new DatabaseHelper();
    int a = await db.deleteBarrelCount(id);
    notifyListeners();
  }

  codeDetailsExist(String code){
    var b =_barrelcounts.where((b) => b['wastecolid'] == int.parse(code));
    if(b.length>0){
      return true;
    }else{
      return false;
    }
  }

   getCodeDetails(bool scanned, String code) {
    if (scanned) {
      BarrelCountModel a = BarrelCountModel.fromMap(_barrelcounts.where((b) => b['wastecolid'] == int.parse(code)).first);
      _barrelcount=a;
      _id=a.id;
      return a;
    }

  }

}
