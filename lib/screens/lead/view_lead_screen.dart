import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/app_translations.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/screens/follow_ups/followup_screen.dart';
import 'package:cbsa_mobile_app/screens/lead/task_screen.dart';
import 'package:cbsa_mobile_app/screens/lead/update_lead_screen.dart';
import 'package:cbsa_mobile_app/setup_models.dart/block.dart';
import 'package:cbsa_mobile_app/setup_models.dart/sub_territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/toilet_type.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewLead extends StatefulWidget {
  final Lead lead;
  ViewLead({Key key, this.lead}) : super(key: key);

  @override
  ViewLeadState createState() => ViewLeadState();
}

class ViewLeadState extends State<ViewLead> {
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
                  AppTranslations.of(context).text("territory"),
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
                  AppTranslations.of(context).text("subTerritory"),
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
                  AppTranslations.of(context).text("block"),
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
                  AppTranslations.of(context).text("toiletType"),
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

  Widget _displayText(String title, String value) {
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
          initialValue: value,
        ),
        SizedBox(
          height: 10.0,
        ),
        Divider(),
      ],
    );
  }

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

  @override
  Widget build(BuildContext context) {
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
                    _getTerritory(widget.lead.territory),
                    _getSubTerritory(widget.lead.subTerritory),
                    _getBlock(widget.lead.block),
                    _displayText(AppTranslations.of(context).text("address"), widget.lead.address),
                    _displayText(AppTranslations.of(context).text("gender"), widget.lead.gender),
                    _displayText(AppTranslations.of(context).text("primaryPhoneNumber"), widget.lead.primaryTelephone),
                    _displayText(AppTranslations.of(context).text("secondaryPhoneNumber"), widget.lead.secondaryTelephone),
                    _getToiletType(widget.lead.toiletType),
                    _displayNumber(AppTranslations.of(context).text("numberOfToilets"), widget.lead.noOfToilets),
                    _displayNumber(AppTranslations.of(context).text("numberOfMaleAdults"), widget.lead.noOfMaleAdults),
                    _displayNumber(AppTranslations.of(context).text("numberOfFemaleAdults"), widget.lead.noOfFemaleAdults),
                    _displayNumber(AppTranslations.of(context).text("numberOfMaleChildren"), widget.lead.noOfMaleChildren),
                    _displayNumber(AppTranslations.of(context).text("numberOfFemaleChildren"), widget.lead.noOfFemaleChildren),
                    _locationCoordinates(widget.lead.latitude, widget.lead.longitude),
                  ],
                ),
              ),
            ),
          ],
        ),
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


