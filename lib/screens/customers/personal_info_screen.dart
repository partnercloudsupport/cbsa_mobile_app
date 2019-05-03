import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/lead_conversion.dart';
import 'package:cbsa_mobile_app/setup_models.dart/lead_type.dart';
import 'package:flutter/material.dart';

class PersonalInfo extends StatefulWidget {
  final Lead lead;

  PersonalInfo({Key key, this.lead}) : super(key: key);

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  void initState() {
    super.initState();
    _getSourceofInformation(widget.lead.infoSourceSelected);
  }

  void testTest() async {
    var db = DatabaseHelper();
    var result = await db.getAllLeads();

    print(result.first);
  }

  Widget _noOfAdults() {
    return ListTile(
      title: Text('Number of Adults Served By Toilet'),
      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Males: '),
              widget.lead.noOfMaleAdults == null
                  ? Text('N/A')
                  : Text(widget.lead.noOfMaleAdults.toString())
            ],
          ),
          Row(
            children: <Widget>[
              Text('Females: '),
              widget.lead.noOfFemaleAdults == null
                  ? Text('N/A')
                  : Text(widget.lead.noOfFemaleAdults.toString())
            ],
          ),
        ],
      ),
    );
  }

  Widget _noOfChildren() {
    return ListTile(
      title: Text('Number of Children Served By Toilet'),
      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Males: '),
              widget.lead.noOfMaleChildren == null
                  ? Text('N/A')
                  : Text(widget.lead.noOfMaleChildren.toString())
            ],
          ),
          Row(
            children: <Widget>[
              Text('Females: '),
              widget.lead.noOfFemaleChildren == null
                  ? Text('N/A')
                  : Text(widget.lead.noOfFemaleChildren.toString())
            ],
          ),
        ],
      ),
    );
  }

  // map

  Future<List> _getSourceofInformation(String sources) async {
    if (sources == null) {
      return [];
    } else {
      List<int> sourceIds = new List();
      List<String> _sourceNames = new List();

      sourceIds = sources.split(',').map((id) => int.parse(id)).toList();

      var db = DatabaseHelper();
      for (var i in sourceIds) {
        var result = await db.getInformationSource(i);
        _sourceNames.add(result.name);
      }

      return _sourceNames;
    }
  }

  Widget _sourceOfInformation() {
    return FutureBuilder(
      future: _getSourceofInformation(widget.lead.infoSourceSelected),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('Source(s) of Information'),
          subtitle:
              snapshot.hasData ? Text(snapshot.data.join(' ')) : Text('N/A'),
        );
      },
    );
  }

  Future<LeadType> _getLeadType() async {
    var db = DatabaseHelper();
    var result = await db.getLeadType(widget.lead.leadType);
    return result;
  }

  Widget _leadType() {
    return FutureBuilder(
      future: _getLeadType(),
      builder: (context, snapshot) {
        return ListTile(
          title: Text('Lead Type'),
          subtitle: snapshot.hasData ? Text(snapshot.data.name) : Text('N/A'),
        );
      },
    );
  }

  Widget _disability() {
    return ListTile(
      title: Text('Disability'),
      subtitle: Text(widget.lead.disability),
    );
  }

  Future<List> _getReasonOfEnrollment(String reasons) async {
    if (reasons == null) {
      return [];
    } else {
      List<int> reasonIds = new List();
      List<String> _reasonNames = new List();

      reasonIds = reasons.split(',').map((id) => int.parse(id)).toList();

      var db = DatabaseHelper();
      for (var i in reasonIds) {
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
          subtitle:
              snapshot.hasData ? Text(snapshot.data.join(' ')) : Text('N/A'),
        );
      },
    );
  }

  Future<LeadConversion> _getLeadConversionObject() async {
    var db = DatabaseHelper();
    var result = db.getLeadConversion(widget.lead.id);

    return result;
  }

  Widget _householdImage() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return ListTile(
            title: Text('Household Image'),
            subtitle: Container(
              padding: EdgeInsets.all(20),
              child: snapshot.hasData
                  ? Image.network(
                      snapshot.data.householdImageUrl,
                      scale: 1.5,
                    )
                  : Image.asset('assets/house-placeholder.jpg'),
            ));
      },
    );
  }

  Widget _landmarkImage() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return ListTile(
            title: Text('Landmark Image'),
            subtitle: Container(
              padding: EdgeInsets.all(20),
              child: snapshot.hasData
                  ? Image.network(
                      snapshot.data.landmarkImageUrl,
                      scale: 1.5,
                    )
                  : Image.asset('assets/landmark-placeholder.png'),
            ));
      },
    );
  }

  Widget _payerFirstName() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return ListTile(
          title: Text('Payer First Name'),
          subtitle: snapshot.hasData
              ? snapshot.data.payerFirstName == null
                  ? Text('N/A')
                  : Text('snapshot.data.payerFirstName')
              : Text('N/A'),
        );
      },
    );
  }

  Widget _payerLastName() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return ListTile(
          title: Text('Payer Last Name'),
          subtitle: snapshot.hasData
              ? snapshot.data.payerLastName == null
                  ? Text('N/A')
                  : Text(snapshot.data.payerLastName)
              : Text('N/A'),
        );
      },
    );
  }

  Widget _relationship() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return ListTile(
          title: Text('Relationship'),
          subtitle: snapshot.hasData
              ? snapshot.data.relationship == null
                  ? Text('N/A')
                  : Text(snapshot.data.relationship)
              : Text('N/A'),
        );
      },
    );
  }

  Widget _payerPrimaryPhoneNumber() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return ListTile(
          title: Text('Payer Primary Phone Number'),
          subtitle: snapshot.hasData
              ? snapshot.data.payerPrimaryTelephone == null
                  ? Text('N/A')
                  : Text(snapshot.data.payerPrimaryTelephone)
              : Text('N/A'),
        );
      },
    );
  }

  Widget _payerSecondaryPhoneNumber() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return ListTile(
          title: Text('Payer Secondary Phone Number'),
          subtitle: snapshot.hasData
              ? snapshot.data.payerSecondaryTelephone == null
                  ? Text('N/A')
                  : Text(snapshot.data.payerSecondaryTelephone)
              : Text('N/A'),
        );
      },
    );
  }

  Widget _payerOccupation() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return ListTile(
          title: Text('Payer Occupation'),
          subtitle: snapshot.hasData
              ? snapshot.data.payerOccupation == null
                  ? Text('N/A')
                  : Text(snapshot.data.payerOccupation)
              : Text('N/A'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Personal Information'),
      // ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _noOfAdults(),
            _noOfChildren(),
            _sourceOfInformation(),
            _leadType(),
            _disability(),
            _reasonsOfEnrollment(),
            Row(
              children: <Widget>[
                Expanded(
                  child: _householdImage(),
                ),
                Expanded(
                  child: _landmarkImage(),
                ),
              ],
            ),
            // _householdImage(),
            // _landmarkImage(),
            _payerFirstName(),
            _payerLastName(),
            _relationship(),
            _payerPrimaryPhoneNumber(),
            _payerSecondaryPhoneNumber(),
            _payerOccupation(),
          ],
        ),
      ),
    );
  }
}
