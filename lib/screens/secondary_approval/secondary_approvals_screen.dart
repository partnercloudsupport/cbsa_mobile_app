import 'dart:convert';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/sa_work_order.dart';
import 'package:cbsa_mobile_app/scoped_model/lead_model.dart';
import 'package:cbsa_mobile_app/screens/secondary_approval/sa_work_order_screen.dart';
import 'package:cbsa_mobile_app/services/secondary_approvals_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';

class SecondaryApprovalsScreen extends StatefulWidget {
  @override
  _SecondaryApprovalsScreenState createState() => _SecondaryApprovalsScreenState();
}

class _SecondaryApprovalsScreenState extends State<SecondaryApprovalsScreen> {
  bool _isLoading = false;
  List<int> _leadIds = [];

  void initState() {
    super.initState();

    testTest();
    getAllLeads();
  }

  void testTest() async {
    var db = DatabaseHelper();

    // var result = await db.getAllSAWorkOrders();
    var result = await db.getAllApprovedOpportunityLeads();
    print(result);
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
    print(this._leadIds);
  }

  Widget _pendingApprovalsView(LeadModel model) {
    return ListView.builder(
      itemCount: model.pendingLeads.length,
      itemBuilder: (BuildContext context, int index) {
        String firstName = model.pendingLeads[index]['fname'];
        String lastName = model.pendingLeads[index]['lname'];
        String initials = firstName.substring(0, 1).toUpperCase() + lastName.substring(0, 1).toUpperCase();
        String primaryPhoneNumber = model.pendingLeads[index]['pritelephone'];
        String address = model.pendingLeads[index]['address'];

        return GestureDetector(
          onTap: () {},
          child: Card(
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
                              tag: initials,
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

  Widget _approvedLeadsView(LeadModel model) {
    return ListView.builder(
      itemCount: model.approvedLeads.length,
      itemBuilder: (BuildContext context, int index) {
        String firstName = model.approvedLeads[index]['fname'];
        String lastName = model.approvedLeads[index]['lname'];
        String initials = firstName.substring(0, 1).toUpperCase() + lastName.substring(0, 1).toUpperCase();
        String primaryPhoneNumber = model.approvedLeads[index]['pritelephone'];
        String address = model.approvedLeads[index]['address'];

        return GestureDetector(
          onTap: () async {
            var db = DatabaseHelper();
            var result = await db.getSAWorkOrder(model.approvedLeads[index]['id']);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SAWorkOrderView(
                  workOrder: result,
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
                              tag: initials,
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

  void _refresh() async {
    setState(() {
      _isLoading = true;
    });

    var response = await SecondaryApprovalsService.getApprovedLeads();
    var decodedResponse = jsonDecode(response.body);

    print(response.body);
    
    if(response.statusCode == 200) {
      var db = DatabaseHelper();
      db.clearSAWorkOrdersTable();

      for(var i in decodedResponse) {
        var incl = _leadIds.contains(i['lead']['id']);
        if(incl == false) {
          await db.saveLead(Lead.map(i['lead']));
        } else {
          await db.updateLead(Lead.map(i['lead']));
        }

        Map map = Map.from(i['lead']);
        map['workorderid'] = i['workorderid'];
        map['transportdate'] = i['transportdate'];

        await db.saveSAWorkOrder(SAWorkOrderModel.map(map));
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
    return ScopedModel(
      model: LeadModel(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Secondary Approvals'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  _refresh();
                },
              )
            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: 'Pending Approval Leads',
                  icon: Icon(Icons.hourglass_full),
                ),
                Tab(
                  text: 'Approved Leads',
                  icon: Icon(Icons.done_outline),
                )
              ],
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: _isLoading,
            child: ScopedModelDescendant<LeadModel>(
              builder: (context, child, model) {
                model.fetchAllPendingLeads();
                model.fetchAllApprovedLeads();

                return TabBarView(
                  children: <Widget>[
                    model.pendingLeads.length > 0
                    ? Column(
                      children: <Widget>[
                        Expanded(
                          child: _pendingApprovalsView(model),
                        ),
                      ],
                    )
                    : Center(
                      child: Text('No Pending Approvals'),
                    ),
                    model.approvedLeads.length > 0
                    ? Column(
                      children: <Widget>[
                        Expanded(
                          child: _approvedLeadsView(model),
                        ),
                      ],
                    )
                    : Center(
                      child: Text('No Approved Leads'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}