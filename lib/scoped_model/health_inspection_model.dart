import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/health_inspection_customer.dart';
import 'package:scoped_model/scoped_model.dart';

class HealthInspectionModel extends Model {
  List<HICustomer> _customers = [];

  List<HICustomer> get customers => _customers;

  void fetchAllHealthInspectionCustomers() async {
    var dbClient = new DatabaseHelper();
    List list = await dbClient.getAllHICustomers();
    List<HICustomer> customersList;
    if(list.length > 0) {
      customersList = list.map((item) {
        return HICustomer.map(item);
      }).toList();
    }

    this._customers = customersList;

    notifyListeners();
  }
}