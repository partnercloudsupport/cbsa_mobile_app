import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/direct_order.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/lead_conversion.dart';
import 'package:cbsa_mobile_app/scoped_model/lead_model.dart';
import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
import 'package:cbsa_mobile_app/screens/direct_order/view_direct_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class DirectOrderList extends StatefulWidget {
  @override
  _DirectOrderListState createState() => _DirectOrderListState();
}

class _DirectOrderListState extends State<DirectOrderList> {

  void initState() {
    super.initState();

    // testDirectOrders();
  }

  // void testDirectOrders() async {
  //   var db = DatabaseHelper();
  //   // var result = await db.getAllLeadConversions();

  //   LeadConversion leadConversion = new LeadConversion(
  //     35, // _leadId, 
  //     '2019-03-24 15:16:32.262672', 
  //     '_mobileMoneyCode', 
  //     '_payerFirstName', 
  //     '_payerLastName', 
  //     '_relationship', 
  //     '_payerPrimaryPhoneNumber', 
  //     '_payerSecondaryPhoneNumber', 
  //     '_payerOccupation', 
  //     '_paymentMethodSelected', 
  //     1, // _createdBy, 
  //     '_householdSavings', 
  //     '_payerOccupation', 
  //     '', // _secondaryOccupation, 
  //     '_homeOwnership', 
  //     '/storage/sdcard/Android/data/com.cbsa.mobile/files/Pictures/325163fc-c7dc-4dee-b077-793b98c23b691956494628.jpg', 
  //     '/storage/sdcard/Android/data/com.cbsa.mobile/files/Pictures/325163fc-c7dc-4dee-b077-793b98c23b691956494628.jpg',
  //     '/storage/sdcard/Android/data/com.cbsa.mobile/files/Pictures/325163fc-c7dc-4dee-b077-793b98c23b691956494628.jpg',
  //     1, // _status, 
  //     '_endTime', 
  //     null
  //   );

  //   var x = await db.getAllLeadConversions();


  //   print(x.length);
  // }

  // void showAlertDialog(String message, TaskModel model, int index) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: message == 'archive' ? Text('Archive Record') : Text(''),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Yes'),
  //             onPressed: () {
  //               model.archiveDirectOrder(model.directOrders[index]['id']);
  //               // model.fetchDirectOrders();
  //               // Navigator.of(context).pop();
  //             },
  //           ),
  //           FlatButton(
  //             child: Text('No'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  buildListView(LeadModel model, int index) {
    String firstName = model.directOrders[index]['fname'].toString() ;
    String lastName = model.directOrders[index]['lname'].toString();
    String initials =  firstName.substring(0, 1).toUpperCase() + lastName.substring(0, 1).toUpperCase();

    return GestureDetector(
      onTap: () {
        Lead lead = Lead.map(model.directOrders[index]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewDirectOrder(lead: lead),
          ),
        );
      },
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.fromLTRB(7.0, 7.0, 7.0, 0.0),
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
                          tag: model.directOrders[index]['id'],
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(initials),
                            radius: 30.0,
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
                        Text(model.directOrders[index]['pritelephone']),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(model.directOrders[index]['address']),
                      ],
                    ),
                  ),
              ],
              ),
            ),
            // Container(
            //   alignment: FractionalOffset.bottomRight,
            //   child: FlatButton(
            //   child: Text('Archive'),
            //   onPressed: () {
            //     showAlertDialog('archive', model, index);
            //   },
            // ),
            // )
            // Expanded(
            //   flex: 7,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: <Widget>[
            //       FlatButton(
            //         child: Text('Archive'),
            //         onPressed: () {
            //           showAlertDialog('archive', model, index);
            //         },
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Direct Orders'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/newdirectorder');
        },
      ),
      body: ScopedModel(
        model: LeadModel(),
        child: ScopedModelDescendant<LeadModel>(
          builder: (context, child, model) {
            model.fetchAllDirectOrders();
            return model.directOrders.length == 0
              ? Center(child: Text('No Direct Orders Available', style: TextStyle(fontSize: 18.0),))
              : Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: model.directOrders.length,
                      itemBuilder: (BuildContext context, index) {
                        return buildListView(model, index);
                      },
                    ),
                  ),
                ],
              );
          },
        ),
      ),
    );
  }
}