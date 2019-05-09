import 'package:cbsa_mobile_app/Utils/connectivity_helper.dart';
import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/scoped_model/lead_model.dart';
import 'package:cbsa_mobile_app/screens/lead/view_lead_screen.dart';
import 'package:cbsa_mobile_app/screens/lead_conversion/lead_conversion_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flushbar/flushbar.dart';

class LeadsScreen extends StatefulWidget {
  @override
  _LeadsScreenState createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  bool isloading = false;

  Widget _followUpsView(LeadModel model) {
    return ListView.builder(
      itemCount: model.openLeads.length,
      itemBuilder: (BuildContext context, int index) {
        String firstName = model.openLeads[index]['fname'];
        String lastName = model.openLeads[index]['lname'];
        String initials = firstName.substring(0, 1).toUpperCase() +
            lastName.substring(0, 1).toUpperCase();
        String primaryPhoneNumber = model.openLeads[index]['pritelephone'];
        String address = model.openLeads[index]['address'];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ViewLead(lead: Lead.map(model.openLeads[index])),
              ),
            );
          },
          child: Card(
            color: model.openLeads[index]['serverId'] == null
                ? Colors.grey.shade300
                : Colors.white,
            elevation: 5.0,
            margin: EdgeInsets.fromLTRB(7.0, 6.0, 7.0, 0.0),
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
                              tag: initials,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  initials,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25.0),
                                ),
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

  Widget _ordersView(LeadModel model) {
    return ListView.builder(
      itemCount: model.readyLeads.length,
      itemBuilder: (BuildContext context, int index) {
        String firstName = model.readyLeads[index]['fname'];
        String lastName = model.readyLeads[index]['lname'];
        String initials = firstName.substring(0, 1).toUpperCase() +
            lastName.substring(0, 1).toUpperCase();
        String primaryPhoneNumber = model.readyLeads[index]['pritelephone'];
        String address = model.readyLeads[index]['address'];
        List<int> leadConversions = new List();
        for (var i in model.leadConversions) {
          leadConversions.add(i['leadid']);
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ViewLead(lead: Lead.map(model.readyLeads[index])),
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
                                child: Text(
                                  initials,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25.0),
                                ),
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
                            leadConversions
                                    .contains(model.readyLeads[index]['id'])
                                ? Align(
                                    alignment: FractionalOffset.bottomRight,
                                    child: Text('Pending Toilet Installation'),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NewLeadConversion(
                                                      lead: Lead.map(
                                                          model.readyLeads[
                                                              index]))));
                                    },
                                    child: Align(
                                      alignment: FractionalOffset.bottomRight,
                                      child: Text('Convert Lead'),
                                    ),
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

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: ScopedModel(
        model: LeadModel(),
        child: ScopedModelDescendant<LeadModel>(
          builder: (context, child, model) {
            model.fetchAllLeads();
            model.fetchAllOpenLeads();
            model.fetchAllReadyLeads();
            model.fetchAllLeadConversions();
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Leads'),
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(
                        text: 'Follow Ups',
                        icon: Icon(Icons.insert_drive_file),
                      ),
                      Tab(
                        text: 'Orders',
                        icon: Icon(Icons.shopping_basket),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () async {
                            setState(() {
                              isloading = true;
                            });
                            var isconnected = await Connectivity.isOnline();
                            if (isconnected) {
                              model.syncLeads(model.localLeads);
                              setState(() {
                               isloading=false; 
                              });
                            } else {
                              setState(() {
                                isloading = false;
                              });
                              Flushbar(
                                flushbarStyle: FlushbarStyle.FLOATING,
                                aroundPadding: EdgeInsets.all(8),
                                borderRadius: 8,
                                messageText:
                                    Text("You are not connected to the internet",style: TextStyle(fontSize: 16.0,color: Colors.white),textAlign: TextAlign.center,),
                                    duration: Duration(seconds: 3),
                                backgroundColor: Colors.red,
                              )..show(context);
                            }
                          },
                        )),
                  ],
                ),
                body: TabBarView(
                  children: <Widget>[
                    model.openLeads.length > 0
                        ? Column(
                            children: <Widget>[
                              Expanded(
                                child: _followUpsView(model),
                              ),
                            ],
                          )
                        : Center(
                            child: Text('No Open Leads Available'),
                          ),
                    model.readyLeads.length > 0
                        ? Column(
                            children: <Widget>[
                              Expanded(
                                child: _ordersView(model),
                              ),
                            ],
                          )
                        : Center(
                            child: Text('No Orders Available'),
                          ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.cyan.shade300,
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.pushNamed(context, '/newlead');
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
