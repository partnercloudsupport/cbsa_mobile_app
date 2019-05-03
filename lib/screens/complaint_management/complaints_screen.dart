import 'dart:convert';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/scoped_model/customer_model.dart';
import 'package:cbsa_mobile_app/scoped_model/lead_model.dart';
import 'package:cbsa_mobile_app/screens/lead/view_lead_screen.dart';
import 'package:cbsa_mobile_app/screens/lead_conversion/lead_conversion_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';

class Complaints extends StatefulWidget {
  @override
  _ComplaintsState createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  bool isloading = false;

  void initState() {
    super.initState();
  }

  Widget _complaintsView(CustomerModel model) {
    return ListView.builder(
      itemCount: model.complaints.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {},
          child: Card(
            elevation: 5.0,
            margin: EdgeInsets.fromLTRB(7.0, 6.0, 7.0, 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(model.complaints[index]['complain'],style: TextStyle(fontSize: 16.0),),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(DateFormat.yMMMd().format(DateTime.parse(model.complaints[index]['created_at'])),style: TextStyle(fontSize: 15.0),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: ScopedModel(
        model: CustomerModel(),
        child: ScopedModelDescendant<CustomerModel>(
          builder: (context, child, model) {
            model.getComplaints();
            return Scaffold(
              appBar: AppBar(
                title: Text('Complaints'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {
                       isloading=true; 
                      });
                      model.getRemoteComplaints();
                      model.getComplaints();
                      setState(() {
                       isloading=false; 
                      });
                    },
                  )
                ],
              ),
              body: model.complaints.length > 0
                  ? Column(
                      children: <Widget>[
                        Expanded(
                          child: _complaintsView(model),
                        ),
                      ],
                    )
                  : Center(
                      child: Text('No Complaints Available'),
                    ),
            );
          },
        ),
      ),
    );
  }
}
