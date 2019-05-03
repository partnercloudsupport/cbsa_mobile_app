import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/payment.dart';
import 'package:scoped_model/scoped_model.dart';

class PaymentModel extends Model {
  List<Payment> _payments = [];
  List<Payment> get payments => _payments;

  fetchAllPayments() async {
    var db = DatabaseHelper();
    List list = await db.getAllPayments();
    _payments = list.map((payment) {
      return Payment.map(payment);
    }).toList();

    notifyListeners();
  }
}