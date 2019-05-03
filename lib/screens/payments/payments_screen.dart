import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/scoped_model/payment_model.dart';
import 'package:cbsa_mobile_app/screens/payments/cash_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class Payments extends StatefulWidget {
  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {

  Future<Lead> _getLeadData(int id) async {
    var db = DatabaseHelper();
    var result = await db.getLead(id);

    return result;
  }

  Widget _paymentsView(PaymentModel model) {
    return ListView.builder(
      itemCount: model.payments.length,
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: _getLeadData(model.payments[index].customerId),
          builder: (BuildContext context, AsyncSnapshot<Lead> snapshot) {
            return Card(
              elevation: 5.0,
              margin: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 5.0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 5), 
                      child: Text('Account ID: ' + model.payments[index].accountID),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: snapshot.hasData ? Text('Name: ' + snapshot.data.firstName + ' ' + snapshot.data.lastName) : Text('Name: '),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text('Date: ' + DateFormat.yMMMMEEEEd().format(DateTime.parse(model.payments[index].dateOfPayment))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text('Amount: GHC' + model.payments[index].amount),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text('Payment Type: ' + model.payments[index].paymentType),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: PaymentModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Payments'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('New Payment'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CashPayment()));
          },
        ),
        body: ScopedModelDescendant<PaymentModel>(
          builder: (context, child, model) {
            model.fetchAllPayments();
            return Container(
              child: model.payments.length > 0
              ? _paymentsView(model)
              : Center(
                child: Text('No Payments Recieved'),
              ),
            );
          },
        ),
      ),
    );
  }
}
