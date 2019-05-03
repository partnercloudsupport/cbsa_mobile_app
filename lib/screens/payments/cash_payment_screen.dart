import 'dart:convert';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/payment.dart';
import 'package:cbsa_mobile_app/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CashPayment extends StatefulWidget {
  @override
  _CashPaymentState createState() => _CashPaymentState();
}

class _CashPaymentState extends State<CashPayment> {
  final _formKey = GlobalKey<FormState>();

  String _customerAccountId, _amount, _date, _paymentType, _dropdownError;
  List<String> _paymentTypes = ['Deposit', 'Service Fee', 'Installation Fee'];
  TextEditingController _customerAccountIdController = new TextEditingController();
  TextEditingController _amountController = new TextEditingController();

  Map _user;
  bool _isLoading = false;

  void initState() {
    super.initState();

    fetchUserObject();
  }

  void fetchUserObject() async {
    var dbClient = DatabaseHelper();
    Map user = await dbClient.getUserObject();
    setState(() {
     this._user = user; 
    });
  }

  Widget _getCustomerAccountId() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Customer Account ID', hasFloatingPlaceholder: true),
      controller: _customerAccountIdController,
      onFieldSubmitted: (value) {
        _customerAccountIdController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Required Field';
        }
      },
      onSaved: (value) {
        setState(() {
          this._customerAccountId = value;
        });
      },
    );
  }

  Widget _getPaymentType() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Payment Type'),
            DropdownButton(
              hint: Text('Payment Type'),
              value: _paymentType,
              items: _paymentTypes.map((type) {
                return new DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) async {
                setState(() {
                  _paymentType = value;
                });
              },
            )
          ],
        ),
        _dropdownError == null
          ? SizedBox.shrink()
          : Text(
            _dropdownError ?? '', 
            style: TextStyle(color: Colors.red),
        )

      ],
    );
  }

  Widget _getAmount() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Amount', hasFloatingPlaceholder: true),
      controller: _amountController,
      onFieldSubmitted: (value) {
        _amountController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Required Field';
        }
      },
      onSaved: (value) {
        setState(() {
          this._amount = value;
        });
      },
    );
  }

  Widget _submit() {
    return RaisedButton(
      child: Text('Submit'),
      onPressed: () async {
        FocusScope.of(context).requestFocus(new FocusNode());
        bool isValid = _formKey.currentState.validate();

        if(_paymentType == null) {
          setState(() {
            _dropdownError = 'Select An Option';
          });
          isValid = false;
        }

        if(isValid) {
          _formKey.currentState.save();

          setState(() {
            _date = DateTime.now().toString();
            _dropdownError = null;
            _isLoading = true;
          });

          Map<String, dynamic> map = {
            'customerid': _customerAccountId,
            'paymenttype': _paymentType,
            'amount': _amount,
            'date': _date,
            'userid': _user['user_id']
          };
          
          var response = await PaymentService.makePayment(map);

          if(response.statusCode == 200) {
            var decodedResponse = jsonDecode(response.body);
            var paymentMap = {
              'customerId': decodedResponse['data']['leadid'],
              'accountId': decodedResponse['data']['accountnumber'],
              'dateOfPayment': decodedResponse['data']['date'],
              'amount': decodedResponse['data']['amount'].toString(),
              'paymentType': decodedResponse['data']['type']
            };
            Payment payment = Payment.map(paymentMap);
            var db = DatabaseHelper();
            int savePayment = await db.savePayment(payment);
            if(savePayment > 0) {
              Fluttertoast.showToast(
                msg: 'Payment Made Successfully',
                toastLength: Toast.LENGTH_SHORT,
              );
              setState(() {
                _isLoading = false;
              });
              Navigator.pop(context);
            } else {
              Fluttertoast.showToast(
                msg: 'Could Not Save To Local DB',
                toastLength: Toast.LENGTH_SHORT,
              );
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).pop();
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Payment'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            padding: EdgeInsets.all(40),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  _getCustomerAccountId(),
                  Divider(),
                  _getPaymentType(),
                  Divider(),
                  _getAmount(),
                  Divider(),
                  _submit()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}