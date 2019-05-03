import 'package:cbsa_mobile_app/models/followUp.dart';
import 'package:flutter/material.dart';

class ViewFollowup extends StatefulWidget {
  final FollowUps followup;
  ViewFollowup({Key key,this.followup}):super(key:key);

  @override
  _ViewFollowupState createState() => _ViewFollowupState();
}

class _ViewFollowupState extends State<ViewFollowup> {

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followup Details'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 25.0,),
          Visibility(
            visible: widget.followup.type!=null,
            child: _displayText('Visit Type', widget.followup.type),
          ),
          Visibility(
            visible: widget.followup.wasleadreached!=null,
            child: _displayText('Reached Customer', widget.followup.wasleadreached),
          ),
          Visibility(
            visible: widget.followup.isinterested!=null,
            child: _displayText('Is Interested', widget.followup.isinterested),
          ),
          Visibility(
            visible: widget.followup.paystate!=null,
            child: _displayText('Ready To Pay', widget.followup.paystate),
          ),
           Visibility(
            visible: widget.followup.spacepreparestate!=null,
            child: _displayText('Has Prepared Space', widget.followup.spacepreparestate),
          ),
          Visibility(
            visible: widget.followup.folupdate!=null,
            child: _displayText('Followup Date', widget.followup.folupdate),
          ),
          Visibility(
            visible: widget.followup.inspectiondate!=null,
            child: _displayText('Site Inspection Date', widget.followup.inspectiondate),
          ),
          Visibility(
            visible: widget.followup.installationdate!=null,
            child: _displayText('Installation Date', widget.followup.installationdate),
          ),
         Visibility(
            visible: widget.followup.comment!=null,
            child: _displayText('Comments', widget.followup.comment),
          ),
        ],
      ),
    );
  }

}