import 'dart:async';
import 'dart:convert';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/health_inspection_customer.dart';
import 'package:cbsa_mobile_app/scoped_model/health_inspection_model.dart';
import 'package:cbsa_mobile_app/screens/health_inspection/lead_info.dart';
import 'package:cbsa_mobile_app/services/health_inspection_service.dart';
import 'package:cbsa_mobile_app/setup_models.dart/health_inspection_schedule.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';

class HealthInspections extends StatefulWidget {
  @override
  _HealthInspectionsState createState() => _HealthInspectionsState();
}

class _HealthInspectionsState extends State<HealthInspections> {
  List _customerIds = [];
  bool _isLoading = false;

  void initState() {
    super.initState();

    // databaseTest();
    getAllCustomers();
    // getSchedule(1);
  }

  void databaseTest() async {
    var db = new DatabaseHelper();
    var result = await db.getAllHealthInspectionSchedules();
    print(result);
  }

  void getAllCustomers() async {
    var db = DatabaseHelper();
    var result = await db.getAllHICustomers();

    List<int> customerIds = [];
    for(var i in result) {
      customerIds.add(i['id']);
    }

    setState(() {
      this._customerIds = customerIds;
    });
  }

  void getSchedule(int subTerritoryId) async {
    var db = DatabaseHelper();
    var result = await db.getSubterritoryHISchedule(subTerritoryId);
    print(result.id);
    print(result.subTerritoryId);
    print(result.assignedTo);
    print(result.repetitve);
    print(result.interval);
    print(result.inspectionDay);
    print(result.startDate);
    print(result.createdAt);
    print(result.updatedAt);
  }

  Future<HealthInspectionSchedule> getInspectionSchedule(int subTerritoryId) async {
    var db = DatabaseHelper();
    var result = await db.getSubterritoryHISchedule(subTerritoryId);
    return result;
  }

  void refresh() async {
    Fluttertoast.showToast(
      msg: 'Refreshing...',
      toastLength: Toast.LENGTH_SHORT
    );
    setState(() {
      // _isLoading = true;
    });

    var response = await HealthInspectionService.fetchCustomers();
    var decodedResponse = jsonDecode(response.body);
    // print(HICustomer.map(decodedResponse[0]));

    if(response.statusCode == 200) {
      var db = DatabaseHelper();
      for(var i in decodedResponse) {
        _customerIds.contains(i['id'])
        ? await db.updateHICustomer(HICustomer.map(i))
        : await db.saveHICustomer(HICustomer.map(i));
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Could Not Get Customers',
        toastLength: Toast.LENGTH_SHORT
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _customersView(HealthInspectionModel model) {
    return ListView.builder(
      itemCount: model.customers.length,
      itemBuilder: (BuildContext context, int index) {

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LeadInfo(inspectionId: model.customers[index].id, leadId: model.customers[index].id, lead: model.customers[index])),
            );
          },
          child: FutureBuilder(
            future: getInspectionSchedule(model.customers[index].subTerritory),
            builder: (BuildContext context, AsyncSnapshot<HealthInspectionSchedule> snapshot) {
              String initials = model.customers[index].firstName[0] + model.customers[index].lastName[0];
              return Card(
                elevation: 5.0,
                margin: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 5.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Hero(
                                  tag: model.customers[index].id,
                                  child: CircleAvatar(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    child: Text(initials, style: TextStyle(color: Colors.white,fontSize: 25.0),),
                                    radius: 40.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('Name: '),
                                    Text(model.customers[index].firstName + ' ' + model.customers[index].lastName),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  children: <Widget>[
                                    Text('Address: '),
                                    Text(model.customers[index].address),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  children: <Widget>[
                                    Text('Phone Number: '),
                                    Text(model.customers[index].primaryTelephone)
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                Align(
                                  alignment: FractionalOffset.bottomRight,
                                  child: snapshot.data != null
                                    ? Text('Inspection Days: ' + snapshot.data.inspectionDay.toUpperCase() + 's')
                                    : Text(''),
                                ),
                                SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: HealthInspectionModel(),
      child: ScopedModelDescendant<HealthInspectionModel>(
        builder: (context, child, model) {
          model.fetchAllHealthInspectionCustomers();
          return ModalProgressHUD(
            inAsyncCall: _isLoading,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Health Inspections'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      refresh();
                    },
                  )
                ],
              ),
              body: model.customers != null
              ? _customersView(model)
              : Center(
                child: Text('Maintenance & Health Inspections'),
              ),
            ),
          );
        }
      )
    );
  }
}
