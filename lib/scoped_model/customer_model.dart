import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/complaintModel.dart';
import 'package:cbsa_mobile_app/services/customer_service.dart';
import 'package:dio/dio.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomerModel extends Model {
  List _complaints = [];
  List get complaints => _complaints;

  getComplaints() async {
    var db = DatabaseHelper();
    List a = await db.getComplaints();
    _complaints = a;
    notifyListeners();
  }

  getRemoteComplaints() async {
    var db = new DatabaseHelper();
    Response res = await CustomerService.getComplaints();
    List.from(res.data).forEach((c) async {
      await db.saveComplaint(Complaint.fromMap(c));
    });
  }
}
