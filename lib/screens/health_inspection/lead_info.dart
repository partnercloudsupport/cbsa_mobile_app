import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/health_inspection_customer.dart';
import 'package:cbsa_mobile_app/screens/health_inspection/perform_inspection_screen.dart';
import 'package:cbsa_mobile_app/screens/health_inspection/reschedule_inspection.dart';
import 'package:cbsa_mobile_app/setup_models.dart/sub_territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/toilet_type.dart';
import 'package:flutter/material.dart';

class LeadInfo extends StatefulWidget {
  final HICustomer lead;
  final int leadId, inspectionId;
  LeadInfo({Key key, this.inspectionId, this.leadId, this.lead}) : super(key: key);

  @override
  _LeadInfoState createState() => _LeadInfoState();
}

class _LeadInfoState extends State<LeadInfo> {
  Widget _getLeadName() {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Name:'),
          Text(widget.lead.firstName + ' ' + widget.lead.lastName)
        ],
      ),
    );
  }

  Future<Territory> getTerritory(int id) async {
    var db = DatabaseHelper();
    Territory territory = await db.getTerritory(id);
    
    return territory;
  }

  Widget _getTerritory() {
    return FutureBuilder(
      future: getTerritory(widget.lead.territory),
      builder: (BuildContext context, AsyncSnapshot<Territory> snapshot) {
        return Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Territory:'),
              snapshot.hasData
              ? Text(snapshot.data.name)
              : Text('')
            ],
          ),
        );
      },
    );
  }

  Future<SubTerritory> getSubTerritory(int id) async {
    var db = DatabaseHelper();
    SubTerritory subTerritory = await db.getSubTerritory(id);
    
    return subTerritory;
  }

  Widget _getSubTerritory() {
    return FutureBuilder(
      future: getSubTerritory(widget.lead.subTerritory),
      builder: (BuildContext context, AsyncSnapshot<SubTerritory> snapshot) {
        return Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Sub-Territory:'),
              snapshot.hasData
              ? Text(snapshot.data.name)
              : Text('')
            ],
          ),
        );
      },
    );
  }

  Widget _getAddress() {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Address:'),
          Text(widget.lead.address)
        ],
      ),
    );
  }

  Widget _getPrimaryPhoneNumber() {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Primary Phone Number:'),
          Text(widget.lead.primaryTelephone)
        ],
      ),
    );
  }

  Widget _getSecondaryPhoneNumber() {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Secondary Phone Number:'),
          widget.lead.secondaryTelephone != null
          ? Text(widget.lead.secondaryTelephone)
          : Text('NULL')
        ],
      ),
    );
  }

  Future<ToiletType> getToiletType(int id) async {
    var db = DatabaseHelper();
    ToiletType toiletType = await db.getToiletType(id);
    
    return toiletType;
  }

  Widget _getToiletType() {
    return FutureBuilder(
      future: getToiletType(widget.lead.toiletType),
      builder: (BuildContext context, AsyncSnapshot<ToiletType> snapshot) {
        return Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Toilet Type:'),
              snapshot.hasData
              ? Text(snapshot.data.name)
              : Text('')
            ],
          ),
        );
      },
    );
  }

  Widget _getNumberOfToilets() {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Number of Toilets:'),
          widget.lead.noOfToilets != null
          ? Text(widget.lead.noOfToilets.toString())
          : Text('NULL')
        ],
      ),
    );
  }

  Widget _actions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RaisedButton(
          child: Text('Perform Inspection'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PerformInspection(leadId: widget.leadId, inspectionId: widget.inspectionId)));
          },
        ),
        RaisedButton(
          child: Text('Reschedule Inspection'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RescheduleInspection(lead: widget.lead,)));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lead Information'),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getLeadName(),
            _getTerritory(),
            _getSubTerritory(),
            _getAddress(),
            _getPrimaryPhoneNumber(),
            _getSecondaryPhoneNumber(),
            _getToiletType(),
            _getNumberOfToilets(),
            _actions(),
          ],
        )
      )
    );
  }
}