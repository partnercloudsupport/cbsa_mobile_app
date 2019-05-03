import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/lead_conversion.dart';
import 'package:flutter/material.dart';

class SummaryInfo extends StatefulWidget {
  final Lead lead;

  SummaryInfo({Key key, this.lead}) : super(key: key);

  @override
  _SummaryInfoState createState() => _SummaryInfoState();
}

class _SummaryInfoState extends State<SummaryInfo> {
  void initState() {
    super.initState();
  }

  void testTest() async {
    var db = DatabaseHelper();
    var result = await db.getAllCustomers();

    print(result);
  }

  Future<LeadConversion> _getLeadConversionObject() async {
    var db = DatabaseHelper();
    var result = await db.getLeadConversion(widget.lead.id);

    return result;
  }

  Widget _customerImage() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.all(10),
          child: snapshot.hasData
              ? CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data.customerImageUrl),
                  radius: 60.0,
                )
              : CircleAvatar(
                  backgroundImage: AssetImage('assets/profile-placeholder.png'),
                ),
        );
      },
    );
  }

  Future _getCustomer() async {
    var db = DatabaseHelper();
    var result = db.getCustomer(widget.lead.id);

    return result;
  }

  Widget _accountId() {
    return FutureBuilder(
      future: _getCustomer(),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('Account Id'),
          subtitle: snapshot.hasData
              ? Text(snapshot.data.accountNumber)
              : Text('N/A'),
        );
      },
    );
  }

  Widget _firstName() {
    return ListTile(
      title: Text('First Name'),
      subtitle: widget.lead.firstName == null
          ? Text('N/A')
          : Text(widget.lead.firstName),
    );
  }

  Widget _lastName() {
    return ListTile(
      title: Text('Last Name'),
      subtitle: widget.lead.firstName == null
          ? Text('N/A')
          : Text(widget.lead.lastName),
    );
  }

  Widget _otherNames() {
    return ListTile(
      title: Text('Other Names'),
      subtitle: widget.lead.otherNames == null
          ? Text('N/A')
          : Text(widget.lead.otherNames,textAlign: TextAlign.center),
    );
  }

  Future _getTerritory() async {
    var db = DatabaseHelper();
    var result = db.getTerritory(widget.lead.territory);

    return result;
  }

  Widget _territory() {
    return FutureBuilder(
      future: _getTerritory(),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('Territory'),
          subtitle: snapshot.hasData ? Text(snapshot.data.name,textAlign: TextAlign.center) : Text('N/A'),
        );
      },
    );
  }

  Future _getSubTerritory() async {
    var db = DatabaseHelper();
    var result = db.getSubTerritory(widget.lead.subTerritory);

    return result;
  }

  Widget _subTerritory() {
    return FutureBuilder(
      future: _getSubTerritory(),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('Sub Territory'),
          subtitle: snapshot.hasData ? Text(snapshot.data.name,textAlign: TextAlign.center) : Text('N/A'),
        );
      },
    );
  }

  Future _getBlock() async {
    var db = DatabaseHelper();
    var result = db.getBlock(widget.lead.block);

    return result;
  }

  Widget _block() {
    return FutureBuilder(
      future: _getBlock(),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('Block'),
          subtitle: snapshot.hasData ? Text(snapshot.data.name,textAlign: TextAlign.center) : Text('N/A'),
        );
      },
    );
  }

  Widget _address() {
    return ListTile(
      title: Text('Address'),
      subtitle:
          widget.lead.address == null ? Text('N/A') : Text(widget.lead.address,textAlign: TextAlign.center),
    );
  }

  Widget _gender() {
    return ListTile(
      title: Text('Gender'),
      subtitle:
          widget.lead.gender == null ? Text('N/A') : Text(widget.lead.gender,textAlign: TextAlign.center),
    );
  }

  Widget _primaryTelephone() {
    return ListTile(
      title: Text('Primary Telephone'),
      subtitle: widget.lead.primaryTelephone == null
          ? Text('N/A')
          : Text(widget.lead.primaryTelephone,textAlign: TextAlign.center),
    );
  }

  Widget _secondaryTelephone() {
    return ListTile(
      title: Text('Secondary Telephone'),
      subtitle: widget.lead.secondaryTelephone == null
          ? Text('N/A')
          : Text(widget.lead.secondaryTelephone,textAlign: TextAlign.center),
    );
  }

  Future _getToiletType() async {
    var db = DatabaseHelper();
    var result = db.getToiletType(widget.lead.toiletType);

    return result;
  }

  Widget _toiletType() {
    return FutureBuilder(
      future: _getToiletType(),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('Toilet Type'),
          subtitle: snapshot.hasData ? Text(snapshot.data.name) : Text('N/A',textAlign: TextAlign.center),
        );
      },
    );
  }

  Widget _numberOfToilets() {
    return ListTile(
      title: Text('Number of Toilets'),
      subtitle: widget.lead.noOfToilets == null
          ? Text('N/A')
          : Text(widget.lead.toiletType.toString(),textAlign: TextAlign.center),
    );
  }

  Widget _createdBy() {
    return ListTile(
      title: Text('Created By'),
      subtitle: widget.lead.createdBy == null
          ? Text('N/A')
          : Text(widget.lead.createdBy.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary Information'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250.0,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _customerImage(),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _accountId(),
                      _firstName(),
                      _lastName(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                _otherNames(),
                Container(
                  height: 2.0,
                  color: Colors.black,
                  margin: EdgeInsets.fromLTRB(13.0, 2.0, 13.0, 5.0),
                ),
                _territory(),
                Container(
                  height: 2.0,
                  color: Colors.black,
                  margin: EdgeInsets.fromLTRB(13.0, 2.0, 13.0, 5.0),
                ),
                _subTerritory(),
                Container(
                  height: 2.0,
                  color: Colors.black,
                  margin: EdgeInsets.fromLTRB(13.0, 2.0, 13.0, 5.0),
                ),
                _block(),
                Container(
                  height: 2.0,
                  color: Colors.black,
                  margin: EdgeInsets.fromLTRB(13.0, 2.0, 13.0, 5.0),
                ),
                _address(),
                Container(
                  height: 2.0,
                  color: Colors.black,
                  margin: EdgeInsets.fromLTRB(13.0, 2.0, 13.0, 5.0),
                ),
                _gender(),
                Container(
                  height: 2.0,
                  color: Colors.black,
                  margin: EdgeInsets.fromLTRB(13.0, 2.0, 13.0, 5.0),
                ),
                _primaryTelephone(),
                Container(
                  height: 2.0,
                  color: Colors.black,
                  margin: EdgeInsets.fromLTRB(13.0, 2.0, 13.0, 5.0),
                ),
                _secondaryTelephone(),
                Container(
                  height: 2.0,
                  color: Colors.black,
                  margin: EdgeInsets.fromLTRB(13.0, 2.0, 13.0, 5.0),
                ),
                _toiletType(),
                Container(
                  height: 2.0,
                  color: Colors.black,
                  margin: EdgeInsets.fromLTRB(13.0, 2.0, 13.0, 5.0),
                ),
                _numberOfToilets(),
                Container(
                  height: 2.0,
                  color: Colors.black,
                  margin: EdgeInsets.fromLTRB(13.0, 2.0, 13.0, 5.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
