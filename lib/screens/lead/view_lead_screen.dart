import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/scoped_model/initial_setup_model.dart';
import 'package:cbsa_mobile_app/screens/follow_ups/followup_screen.dart';
import 'package:cbsa_mobile_app/screens/lead/task_screen.dart';
import 'package:cbsa_mobile_app/screens/lead/update_lead_screen.dart';
import 'package:cbsa_mobile_app/setup_models.dart/block.dart';
import 'package:cbsa_mobile_app/setup_models.dart/sub_territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/toilet_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewLead extends StatefulWidget {
  final Lead lead;
  ViewLead({Key key, this.lead}) : super(key: key);

  @override
  ViewLeadState createState() => ViewLeadState();
}

class ViewLeadState extends State<ViewLead> {
  Territory _territory = Territory.empty();
  SubTerritory _subTerritory = SubTerritory.empty();
  Block _block = Block.empty();
  ToiletType _toiletType = ToiletType.empty();

  void initState() {
    super.initState();
  }

    Widget _displayText(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: TextFormField(
            textAlign: TextAlign.start,
            enabled: false,
            initialValue: value,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Divider(),
      ],
    );
  }


  Future<Territory> getTerritory(int id) async {
    var db = DatabaseHelper();
    Territory territory = await db.getTerritory(id);
    
    return territory;
  }

  Future<SubTerritory> getSubTerritory(int id) async {
    var db = DatabaseHelper();
    SubTerritory subTerritory = await db.getSubTerritory(id);
    
    return subTerritory;
  }

  Future<Block> getBlock(int id) async {
    var db = DatabaseHelper();
    Block block = await db.getBlock(id);
    
    return block;
  }

  Future<ToiletType> getToiletType(int id) async {
    var db = DatabaseHelper();
    ToiletType toiletType = await db.getToiletType(id);
    
    return toiletType;
  }

  Widget _getTerritory(int id) {
    return FutureBuilder(
      future: getTerritory(id),
      builder: (BuildContext context, AsyncSnapshot<Territory> snapshot) {
        if(snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Territory',
                  style: TextStyle(fontSize: 17.0),
                  textAlign: TextAlign.start,
                ),
              ),
              TextFormField(
                textAlign: TextAlign.center,
                enabled: false,
                initialValue: snapshot.data.name,
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(),
            ],
          );
        } else {
          return Text('');
        }
      },
    );
  }

  Widget _getSubTerritory(int id) {
    return FutureBuilder(
      future: getSubTerritory(id),
      builder: (BuildContext context, AsyncSnapshot<SubTerritory> snapshot) {
        if(snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  ' Sub-Territory',
                  style: TextStyle(fontSize: 17.0),
                  textAlign: TextAlign.start,
                ),
              ),
              TextFormField(
                textAlign: TextAlign.center,
                enabled: false,
                initialValue: snapshot.data.name,
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(),
            ],
          );
        } else {
          return Text('');
        }
      },
    );
  }

  Widget _getBlock(int id) {
    return FutureBuilder(
      future: getBlock(id),
      builder: (BuildContext context, AsyncSnapshot<Block> snapshot) {
        if(snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Block',
                  style: TextStyle(fontSize: 17.0),
                  textAlign: TextAlign.start,
                ),
              ),
              TextFormField(
                textAlign: TextAlign.center,
                enabled: false,
                initialValue: snapshot.data.name,
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(),
            ],
          );
        } else {
          return Text('');
        }
      },
    );
  }

  Widget _getToiletType(int id) {
    return FutureBuilder(
      future: getToiletType(id),
      builder: (BuildContext context, AsyncSnapshot<ToiletType> snapshot) {
        if(snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Toilet Type',
                  style: TextStyle(fontSize: 17.0),
                  textAlign: TextAlign.start,
                ),
              ),
              TextFormField(
                textAlign: TextAlign.center,
                enabled: false,
                initialValue: snapshot.data.name,
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(),
            ],
          );
        } else {
          return Text('');
        }
      },
    );
  }

  // Widget _displayText(String title, String value) {
  //   String val = value == '' ? 'NULL' : value;

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Padding(
  //         padding: EdgeInsets.only(left: 15.0),
  //         child: Text(
  //           title,
  //           style: TextStyle(fontSize: 17.0),
  //           textAlign: TextAlign.start,
  //         ),
  //       ),
  //       TextFormField(
  //         textAlign: TextAlign.center,
  //         enabled: false,
  //         initialValue: value,
  //       ),
  //       SizedBox(
  //         height: 10.0,
  //       ),
  //       Divider(),
  //     ],
  //   );
  // }

  Widget _displayNumber(String title, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 17.0),
            textAlign: TextAlign.start,
          ),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          enabled: false,
          initialValue: value.toString(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Divider(),
      ],
    );
  }

  Widget _locationCoordinates(double latitude, double longitude) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(
            'Location',
            style: TextStyle(fontSize: 17.0),
            textAlign: TextAlign.start,
          ),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          enabled: false,
          initialValue: 'Latitude : $latitude, Longitude : $longitude',
        ),
        SizedBox(
          height: 10.0,
        ),
        Divider(),
      ],
    );
  }

  Widget _displayStringArray(String title, List<String> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 17.0),
            textAlign: TextAlign.start,
          ),
        ),
        // Wrap(
        //   children: <Widget>[
        //     ListView.builder(
        //       itemCount: list.length,
        //       itemBuilder: (BuildContext context,int index){
        //         return Text('jj');
        //       },
        //     )
        //   ],
        // )
      ],
    );
  }

  Widget _displayDate(String title, String date) {
    String dDate = DateFormat.yMMMd().format(DateTime.parse(date));

    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('$title:'),
          Text(
            '$dDate',
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> views = ['Tasks', 'Follow Ups', 'Edit'];
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 60.0,
                            child: Text(
                              widget.lead.firstName.substring(0, 1).toUpperCase() +
                              widget.lead.lastName.substring(0, 1).toUpperCase(),
                              style: TextStyle(fontSize: 25.0),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            widget.lead.firstName + ' ' + widget.lead.lastName,
                            style: TextStyle(fontSize: 25.0),
                          ),
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.cyan,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async{
                                    var url = 'tel:${widget.lead.primaryTelephone}';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.cyan,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateLead(lead: widget.lead),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.cyan,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0)),
                                child: Text('Tasks'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Task(lead: widget.lead),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                width: 6.0,
                              ),
                              RaisedButton(
                                color: Colors.cyan,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0)),
                                child: Text('Follow Ups'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Followups(
                                            initials: widget.lead.firstName
                                                    .substring(0, 1)
                                                    .toUpperCase() +
                                                widget.lead.lastName
                                                    .substring(0, 1)
                                                    .toUpperCase(),
                                            fullName: widget.lead.firstName +
                                                ' ' +
                                                widget.lead.lastName,
                                            id: widget.lead.id,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    // _getTerritory(widget.lead.territory),
                    // _getSubTerritory(widget.lead.subTerritory),
                    // _getBlock(widget.lead.block),
                    _displayText('Territory', _getTerritory(widget.lead.territory).toString()),
                    _displayText('Sub Territory', _getSubTerritory(widget.lead.subTerritory).toString()),
                    _displayText('Block', _getBlock(widget.lead.block).toString()),
                    _displayText('Address', widget.lead.address),
                    _displayText('Gender', widget.lead.gender),
                    _displayText('Primary Telephone', widget.lead.primaryTelephone),
                    _displayText('Secondary Telephone', widget.lead.secondaryTelephone),
                    _getToiletType(widget.lead.toiletType),
                    _displayNumber('Number of Toilets', widget.lead.noOfToilets),
                    _displayNumber('Number of Male Adults', widget.lead.noOfMaleAdults),
                    _displayNumber('Number of Female Adults', widget.lead.noOfFemaleAdults),
                    _displayNumber('Number of Male Children', widget.lead.noOfMaleChildren),
                    _displayNumber('Number of Female Children', widget.lead.noOfFemaleChildren),
                    _locationCoordinates(widget.lead.latitude, widget.lead.longitude),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Card(
        //   // color: Colors.transparent,
        //   child: Column(
        //     children: <Widget>[
        //       Expanded(
        //         flex: 1,
        //         child: Container(
        //           color: Colors.red,
        //         ),
        //       ),
        //       Expanded(
        //         flex: 5,
        //         child: Padding(
        //           padding: EdgeInsets.only(top: 20.0),
        //           child: ListView(
        //             children: <Widget>[
        //               // _displayText('First Name', widget.lead.firstName),
        //               // _displayText('Last Name', widget.lead.lastName),
        //               _displayText('Territory', widget.lead.territory),
        //               _displayText('Sub-Territory', widget.lead.subTerritory),
        //               _displayText('Block', widget.lead.block),
        //               _displayText('Address', widget.lead.address),
        //               _displayText('Gender', widget.lead.gender),
        //               _displayText(
        //                   'Primary Telephone', widget.lead.primaryTelephone),
        //               _displayText('Secondary Telephone',
        //                   widget.lead.secondaryTelephone),
        //               _displayText('Toilet Type', widget.lead.toiletType),
        //               _displayNumber(
        //                   'Number of Toilets', widget.lead.noOfToilets),
        //               _displayNumber(
        //                   'Number of Male Adults', widget.lead.noOfMaleAdults),
        //               _displayNumber('Number of Female Adults',
        //                   widget.lead.noOfFemaleAdults),
        //               _displayNumber('Number of Male Children',
        //                   widget.lead.noOfMaleChildren),
        //               _displayNumber('Number of Female Children',
        //                   widget.lead.noOfFemaleChildren),
        //               _locationCoordinates(
        //                   widget.lead.latitude, widget.lead.longitude),
        //               // _displayStringArray('Information Sources',
        //               //     widget.lead.infoSourceSelected),
        //               // _displayText('Lead Type', widget.lead.leadType),
        //               // _displayText('Disability', widget.lead.disability),
        //               // _displayStringArray(
        //               //     'Enrollment Reasons', widget.lead.reasonsSelected),
        //               // _displayText('Status', widget.lead.status),
        //               // _displayText('Comments', widget.lead.comments),
        //               // _displayText('Network Service Provider',
        //               //     widget.lead.serviceProvider),
        //               // _displayText('Phone Type', widget.lead.telephoneType),
        //               // _displayText(
        //               //     'Salaried Worker', widget.lead.salariedWorker),
        //               // _displayStringArray(
        //               //     'Other Paid Services', widget.lead.servicesSelected),
        //               // _displayStringArray(
        //               //     'Toilet Type', widget.lead.typeSelected),
        //               // _displayStringArray(
        //               //     'Toilet Security', widget.lead.securitySelected),
        //               // _displayStringArray(
        //               //     'Toilet Privacy', widget.lead.privacySelected),
        //               // _displayDate('Follow Up Date', widget.lead.followupDate),
        //               // _displayText('Site Inspection Date',
        //               //     widget.lead.siteInspectionDate),
        //               // _displayText(
        //               //     'Toilet Installation Date', widget.lead.installDate),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      )
    );
  }

  _itemSelected(String item) {
    if (item == 'Tasks') {
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => Task(lead: widget.lead)));
    } else if (item == 'Follow Ups') {
      String initials = widget.lead.firstName.substring(0, 1).toUpperCase() +
          widget.lead.lastName.substring(0, 1).toUpperCase();
      String fullName = widget.lead.firstName + ' ' + widget.lead.lastName;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Followups(
                initials: initials,
                fullName: fullName,
                id: widget.lead.id,
              ),
        ),
      );
    } else if (item == 'Edit') {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => UpdateLead(
      //               lead: widget.lead,
      //             )));
    }
  }
}


