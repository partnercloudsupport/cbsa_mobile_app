import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:scoped_model/scoped_model.dart';

class ToiletInstallationModel extends Model {
  List _installations = [];
  List _uncompletedToiletInstallations = [];

  List get installations => _installations;
  List get uncompletedToiletInstallations => _uncompletedToiletInstallations;

  void fetchInstallations() async {
    var db = new DatabaseHelper();
    List installations = await db.getAllToiletInstallations();
    this._installations = installations;
    notifyListeners();
  }

  void fetchUncompletedToiletInstallations() async {
    var db = new DatabaseHelper();
    List list = await db.getUncompletedWorkOrders();
    this._uncompletedToiletInstallations = list;
    notifyListeners();
  }
}