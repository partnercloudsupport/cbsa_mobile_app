import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/lead_conversion.dart';
import 'package:flutter/material.dart';

class AdditionalInfo extends StatefulWidget {
  final Lead lead;

  AdditionalInfo({Key key, this.lead}) : super(key : key);

  @override
  _AdditionalInfoState createState() => _AdditionalInfoState();
}

class _AdditionalInfoState extends State<AdditionalInfo> {
  Future _getTelephoneServiceProvider() async {
    var db = DatabaseHelper();
    var result = db.getServiceProvider(widget.lead.serviceProvider);
    
    return result;
  }

  Widget _telephoneServiceProvider() {
    return FutureBuilder(
      future: _getTelephoneServiceProvider(),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('Telephone Service Provider'),
          subtitle: snapshot.hasData ? Text(snapshot.data.name) : Text('N/A'),
        );
      },
    );
  }

  Future _getTelephoneType() async {
    var db = DatabaseHelper();
    var result = db.getTelephoneType(widget.lead.telephoneType);
    
    return result;
  }

  Widget _telephoneType() {
    return FutureBuilder(
      future: _getTelephoneType(),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('Telephone Type'),
          subtitle: snapshot.hasData ? Text(snapshot.data.name) : Text('N/A'),
        );
      },
    );
  }

  Widget _salaryWorker() {
    return ListTile(
      title: Text('Salary Worker'),
      subtitle: widget.lead.salariedWorker == null ? Text('N/A') : Text(widget.lead.salariedWorker),
    );
  }

  Widget _paymentDay() {
    return ListTile(
      title: Text('Payment Day'),
      subtitle: widget.lead.paymentDate == null ? Text('N/A') : Text(widget.lead.paymentDate),
    );
  }

  Future<List> _getOtherPaidServices(String paidServices) async {
    if(paidServices == null) {
      return [];
    } else {
      List<int> servicesIds = new List();
      List<String> _servicesNames = new List();

      servicesIds = paidServices.split(',').map((id) => int.parse(id)).toList();
      
      var db = DatabaseHelper();
      for(var i in servicesIds) {
        var result = await db.getPaidService(i);
        _servicesNames.add(result.name);
      }

      return _servicesNames;
    }
  }

  Widget _otherPaidServices() {
    return FutureBuilder(
      future: _getOtherPaidServices(widget.lead.servicesSelected),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('Other Paid Services'),
          subtitle: snapshot.hasData ? Text(snapshot.data.join(' ')) : Text('N/A'),
        );
      },
    );
  }

  Future<List> _getToiletPrivacy(String toiletPrivacy) async {
    if(toiletPrivacy == null) {
      return [];
    } else {
      List<int> privacyIds = new List();
      List<String> _privacyNames = new List();

      privacyIds = toiletPrivacy.split(',').map((id) => int.parse(id)).toList();
      
      var db = DatabaseHelper();
      for(var i in privacyIds) {
        var result = await db.getToiletPrivacy(i);
        _privacyNames.add(result.name);
      }

      return _privacyNames;
    }
  }

  Widget _toiletPrivacy() {
    return FutureBuilder(
      future: _getToiletPrivacy(widget.lead.privacySelected),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('Current Access To Toilet - Privacy'),
          subtitle: snapshot.hasData ? Text(snapshot.data.join(' ')) : Text('N/A'),
        );
      },
    );
  }

  Future<List> _getToiletType(String toiletType) async {
    if(toiletType == null) {
      return [];
    } else {
      List<int> typeIds = new List();
      List<String> _typeNames = new List();

      typeIds = toiletType.split(',').map((id) => int.parse(id)).toList();
      
      var db = DatabaseHelper();
      for(var i in typeIds) {
        var result = await db.getToiletTypeCA(i);
        _typeNames.add(result.name);
      }

      return _typeNames;
    }
  }

  Widget _toiletType() {
    return FutureBuilder(
      future: _getToiletType(widget.lead.typeSelected),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('Current Access To Toilet - Type'),
          subtitle: snapshot.hasData ? Text(snapshot.data.join(' ')) : Text('N/A'),
        );
      },
    );
  }

  Future<List> _getToiletSecurity(String toiletSecurity) async {
    if(toiletSecurity == null) {
      return [];
    } else {
      List<int> securityIds = new List();
      List<String> _securityNames = new List();

      securityIds = toiletSecurity.split(',').map((id) => int.parse(id)).toList();
      
      var db = DatabaseHelper();
      for(var i in securityIds) {
        var result = await db.getToiletSecurity(i);
        _securityNames.add(result.name);
      }

      return _securityNames;
    }
  }

  Widget _toiletToiletSecurity() {
    return FutureBuilder(
      future: _getToiletSecurity(widget.lead.securitySelected),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('Current Access To Toilet - Security'),
          subtitle: snapshot.hasData ? Text(snapshot.data.join(' ')) : Text('N/A'),
        );
      },
    );
  }

  Future<List> _getReasonOfEnrollment(String reasons) async {
    if(reasons == null) {
      return [];
    } else {
      List<int> reasonIds = new List();
      List<String> _reasonNames = new List();

      reasonIds = reasons.split(',').map((id) => int.parse(id)).toList();
      
      var db = DatabaseHelper();
      for(var i in reasonIds) {
        var result = await db.getEnrollmentReason(i);
        _reasonNames.add(result.name);
      }

      return _reasonNames;
    }
  }

  Widget _reasonsOfEnrollment() {
    return FutureBuilder(
      future: _getReasonOfEnrollment(widget.lead.reasonsSelected),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('Reason of Enrollment'),
          subtitle: snapshot.hasData ? Text(snapshot.data.join(' ')) : Text('N/A'),
        );
      },
    );
  }

  Future<LeadConversion> _getLeadConversionObject() async {
    var db = DatabaseHelper();
    var result = db.getLeadConversion(widget.lead.id);
    
    return result;
  }

  Widget _householdSavings() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return ListTile(
          title: Text('Household Savings'),
          subtitle: snapshot.hasData ? Text(snapshot.data.householdSavings) : Text('N/A'),
        );
      },
    );
  }

  Widget _primaryOccupation() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return ListTile(
          title: Text('Primary Occupation'),
          subtitle: snapshot.hasData ? Text(snapshot.data.primaryOccupation) : Text('N/A'),
        );
      },
    );
  }

  Widget _secondaryOccupation() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return ListTile(
          title: Text('Secondary Occupation'),
          subtitle: snapshot.hasData ? Text(snapshot.data.secondaryOccupation) : Text('N/A'),
        );
      },
    );
  }

  Widget _homeOwnership() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return ListTile(
          title: Text('Home Ownership'),
          subtitle: snapshot.hasData ? Text(snapshot.data.homeOwnership) : Text('N/A'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Additional Information'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _telephoneServiceProvider(),
            _telephoneType(),
            _salaryWorker(),
            // widget.lead.salariedWorker == 'Yes'
            // ? _paymentDay()
            // : Container,
            _otherPaidServices(),
            _toiletPrivacy(),
            _toiletType(),
            _toiletToiletSecurity(),
            _reasonsOfEnrollment(),
            _householdSavings(),
            _primaryOccupation(),
            _secondaryOccupation(),
            _homeOwnership(),
          ],
        ),
      ),
    );
  }
}