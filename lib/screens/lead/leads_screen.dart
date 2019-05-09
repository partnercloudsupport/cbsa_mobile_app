import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/app_translations.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/scoped_model/lead_model.dart';
import 'package:cbsa_mobile_app/screens/lead/view_lead_screen.dart';
import 'package:cbsa_mobile_app/screens/lead_conversion/lead_conversion_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LeadsScreen extends StatefulWidget {
  @override
  _LeadsScreenState createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {

  Widget _followUpsView(LeadModel model) {
    return ListView.builder(
      itemCount: model.openLeads.length,
      itemBuilder: (BuildContext context, int index) {
        String firstName = model.openLeads[index]['fname'];
        String lastName = model.openLeads[index]['lname'];
        String initials = firstName.substring(0, 1).toUpperCase() + lastName.substring(0, 1).toUpperCase();
        String primaryPhoneNumber = model.openLeads[index]['pritelephone'];
        String address = model.openLeads[index]['address'];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewLead(lead: Lead.map(model.openLeads[index])),
              ),
            );
          },
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
        String initials = firstName.substring(0, 1).toUpperCase() + lastName.substring(0, 1).toUpperCase();
        String primaryPhoneNumber = model.readyLeads[index]['pritelephone'];
        String address = model.readyLeads[index]['address'];
        List<int> leadConversions = new List();
        for(var i in model.leadConversions) {
          leadConversions.add(i['leadid']);
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewLead(lead: Lead.map(model.readyLeads[index])),
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
                              tag: model.readyLeads[index]['id'],
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
                            leadConversions.contains(model.readyLeads[index]['id'])
                            ? Align(
                              alignment: FractionalOffset.bottomRight,
                              child: Text('Pending Toilet Installation'),
                            )
                            : GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => NewLeadConversion(lead: Lead.map(model.readyLeads[index]))
                                ));
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
    return ScopedModel(
      model: LeadModel(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppTranslations.of(context).text("leads")),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: AppTranslations.of(context).text("followUps"),
                  icon: Icon(Icons.insert_drive_file),
                ),
                Tab(
                  text: AppTranslations.of(context).text("orders"),
                  icon: Icon(Icons.shopping_basket),
                )
              ],
            ),
          ),
          body: ScopedModelDescendant<LeadModel>(
            builder: (context, child, model) {
              model.fetchAllOpenLeads();
              model.fetchAllReadyLeads();
              model.fetchAllLeadConversions();

              return TabBarView(
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
                  )
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.cyan.shade300,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/newlead');
            },
          ),
        ),
      ),
    );
  }
}








