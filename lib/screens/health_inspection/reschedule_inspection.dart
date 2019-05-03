import 'dart:convert';

import 'package:cbsa_mobile_app/models/health_inspection_customer.dart';
import 'package:cbsa_mobile_app/services/health_inspection_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RescheduleInspection extends StatefulWidget {
  final HICustomer lead;
  RescheduleInspection({Key key, this.lead}) : super(key: key);

  @override
  _RescheduleInspectionState createState() => _RescheduleInspectionState();
}

class _RescheduleInspectionState extends State<RescheduleInspection> {
  final _rescheduleInspectionFormKey = GlobalKey<FormState>();
  String _rescheduleInspectionDate;
  TextEditingController _rescheduleInspectionDateController = TextEditingController();
  String _comment;
  TextEditingController _commentController = TextEditingController();

  bool _loading = false;

  void _rescheduleInspection() async {
    if(_rescheduleInspectionFormKey.currentState.validate()) {
      _rescheduleInspectionFormKey.currentState.save();

      setState(() {
        _loading = true;
      });

      Map<String, dynamic> map = {
        'customerid': widget.lead.customerId,
        'duedate': _rescheduleInspectionDate,
        'comment': _comment,
      };

      var response = await HealthInspectionService.rescheduleInspection(map);
      var decodedResponse = jsonDecode(response.body);
      print(response.statusCode);
      print(response.body);

      if(decodedResponse['status'] == 200) {
        Fluttertoast.showToast(
          msg: 'Inspection Rescheduled Successfully',
          toastLength: Toast.LENGTH_SHORT
        );
        setState(() {
          _loading = false;
        });

        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: 'An Error Occured. Inspection Could Not Be Rescheduled',
          toastLength: Toast.LENGTH_SHORT
        );
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reschedule Inspection'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          child: Container(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _rescheduleInspectionFormKey,
              child: ListView(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      DateTime datePicked = await showDatePicker(
                        context: context,
                        firstDate: new DateTime.now(),
                        initialDate: new DateTime.now(),
                        lastDate: new DateTime(2100)
                      );
                      setState(() {
                        _rescheduleInspectionDateController.text = DateFormat.yMMMd().format(datePicked);
                        _rescheduleInspectionDate = datePicked.toString();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 30.0),
                      child: AbsorbPointer(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'Reschedule Inspection Date',
                            hasFloatingPlaceholder: true,
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            )
                          ),
                          controller: _rescheduleInspectionDateController,
                          validator: (value) {
                            if(value.isEmpty) {
                              return 'Required Field';
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Comment', 
                      hasFloatingPlaceholder: true,
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      )
                    ),
                    maxLines: 3,
                    controller: _commentController,
                    onFieldSubmitted: (value) {
                      _commentController.text = value;
                    },
                    onSaved: (value) {
                      setState(() {
                        this._comment = value;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: RaisedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        _rescheduleInspection();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}