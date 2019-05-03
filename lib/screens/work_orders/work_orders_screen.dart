import 'dart:convert';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/work_order.dart';
import 'package:cbsa_mobile_app/scoped_model/toilet_installation_model.dart';
import 'package:cbsa_mobile_app/screens/work_orders/work_order_screen.dart';
import 'package:cbsa_mobile_app/services/work_order_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';

class WorkOrders extends StatefulWidget {
  @override
  _WorkOrdersState createState() => _WorkOrdersState();
}

class _WorkOrdersState extends State<WorkOrders> {
  bool _isLoading = false;
  List<int> _leadIds = [];

  void initState() {
    super.initState();

    getAllLeads();
  }

  void getAllLeads() async {
    var db = DatabaseHelper();
    var result = await db.getAllLeads();

    List<int> leadIds = [];
    for(var i in result) {
      leadIds.add(i['id']);
    }

    setState(() {
      this._leadIds = leadIds;
    });
  }

  Widget _workOrdersView(ToiletInstallationModel model) {
    return ListView.builder(
      itemCount: model.uncompletedToiletInstallations.length,
      itemBuilder: (BuildContext context, int index) {
        String firstName = model.uncompletedToiletInstallations[index]['fname'];
        String lastName = model.uncompletedToiletInstallations[index]['lname'];
        String initials = firstName.substring(0, 1).toUpperCase() + lastName.substring(0, 1).toUpperCase();
        String primaryPhoneNumber = model.uncompletedToiletInstallations[index]['pritelephone'];
        String address = model.uncompletedToiletInstallations[index]['address'];
        String installationDate = model.uncompletedToiletInstallations[index]['installationdate'];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkOrderView(
                  workOrder: WorkOrderModel.map(model.uncompletedToiletInstallations[index]),
                ),
              ),
            );
          },
          child: Card(
            elevation: 5.0,
            margin: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 5.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Hero(
                              tag: model.uncompletedToiletInstallations[index]['id'],
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(initials,style: TextStyle(color: Colors.white,fontSize: 25.0),),
                                radius: 40.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(firstName + ' ' + lastName),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(primaryPhoneNumber),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(address),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text('Toilet Installation Date: ' + DateFormat.yMMMd().format(DateTime.parse(installationDate))),
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

  void fetchWorkOrders() async {
    setState(() {
      _isLoading = true;
    });

    var response = await WorkOrderService.fetchWorkOrders();
    print(response.statusCode);
    print(response.body);
    var decodedResponse = jsonDecode(response.body);
    
    if(response.statusCode == 200) {
      var db = DatabaseHelper();
      db.clearAssignedWorkOrdersTable();

      for(var i in decodedResponse) {
        bool incl = _leadIds.contains(i['lead']['id']);
        if(incl == false) {
          await db.saveLead(Lead.map(i['lead']));
        }

        Map map = Map.from(i['lead']);
        map['workorderid'] = i['workorderid'];
        map['installationdate'] = i['installationdate'];

        await db.saveAssignedWorkOrder(WorkOrderModel.map(map));
        // print(x);
      }
      Fluttertoast.showToast(
        msg: 'Refreshed',
        toastLength: Toast.LENGTH_SHORT,
      );
      setState(() {
        _isLoading = false;
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Could Not Refresh',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: ScopedModel(
        model: ToiletInstallationModel(),
        child: ScopedModelDescendant<ToiletInstallationModel>(
          builder: (context, child, model) {
            model.fetchUncompletedToiletInstallations();

            return Scaffold(
              appBar: AppBar(
                title: Text('Work Orders'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      fetchWorkOrders();
                    },
                  )
                ],
              ),
              body: model.uncompletedToiletInstallations.length > 0
              ? _workOrdersView(model)
              : Center(
                child: Text('No Work Orders Available'),
              ),
            );
          },
        ),
      ),
    );
  }
}