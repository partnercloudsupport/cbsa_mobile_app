import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/toilet_installation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToiletInfo extends StatefulWidget {
  final Lead lead;

  ToiletInfo({Key key, this.lead}) : super(key: key);

  @override
  _ToiletInfoState createState() => _ToiletInfoState();
}

class _ToiletInfoState extends State<ToiletInfo> {
  void initState() {
    super.initState();

    testTest();
  }

  void testTest() async {
    var db = DatabaseHelper();
    var result = await db.getAllToiletInstallations();

    print(result);
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
          subtitle: snapshot.hasData ? Text(snapshot.data.name) : Text('N/A'),
        );
      },
    );
  }

  Widget _numberOfToilets() {
    return ListTile(
      title: Text('Number Of Toilets'),
      subtitle: widget.lead.noOfToilets == null ? Text('N/A') : Text(widget.lead.noOfToilets.toString()),
    );
  }

  Future<ToiletInstallationModel> _getToiletInstallationData() async {
    var db = DatabaseHelper();
    var result = db.getToiletInstallation(widget.lead.id);
    
    return result;
  }

  Widget _toiletQRCode() {
    return FutureBuilder(
      future: _getToiletInstallationData(),
      builder: (context, AsyncSnapshot<ToiletInstallationModel> snapshot) {
        return ListTile(
          title: Text('Toilet QR Code'),
          subtitle: snapshot.hasData ? Text(snapshot.data.qrCode) : Text('N/A'),
        );
      },
    );
  }

  Widget _toiletInstallationDate() {
    return FutureBuilder(
      future: _getToiletInstallationData(),
      builder: (context, AsyncSnapshot<ToiletInstallationModel> snapshot) {
        return ListTile(
          title: Text('Toilet Installation Date'),
          subtitle: snapshot.hasData ? Text(DateFormat.yMMMd().format(DateTime.parse(snapshot.data.toiletInstallationDate))) : Text('N/A'),
        );
      },
    );
  }

  Widget _toiletImage() {
    return FutureBuilder(
      future: _getToiletInstallationData(),
      builder: (context, AsyncSnapshot<ToiletInstallationModel> snapshot) {
        return ListTile(
          title: Text('Toilet Image'),
          subtitle: Container(
            padding: EdgeInsets.all(20),
            child: snapshot.data.toiletImage != null
            ? Image.network(snapshot.data.toiletImage, scale: 1.5,)
            : Image.asset('assets/landmark-placeholder.png'),
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toilet Information'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _toiletType(),
            _numberOfToilets(),
            _toiletQRCode(),
            _toiletInstallationDate(),
            _toiletImage(),
          ],
        ),
      ),
    );
  }
}