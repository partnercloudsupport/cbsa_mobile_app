import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
import 'package:cbsa_mobile_app/scoped_model/toilet_servicing_model.dart';
import 'package:cbsa_mobile_app/screens/follow_ups/followup_screen.dart';
import 'package:cbsa_mobile_app/screens/lead/task_screen.dart';
import 'package:cbsa_mobile_app/screens/lead/update_lead_screen.dart';
import 'package:cbsa_mobile_app/screens/lead/view_lead_screen.dart';
import 'package:cbsa_mobile_app/screens/lead_conversion/lead_conversion_screen.dart';
import 'package:cbsa_mobile_app/screens/tasks/new_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToiletServicingRecords extends StatefulWidget {
  final int id;
  ToiletServicingRecords({Key key, this.id}) : super(key: key);

  @override
  _ToiletServicingRecordsState createState() => _ToiletServicingRecordsState();
}

class _ToiletServicingRecordsState extends State<ToiletServicingRecords> {
  bool allowSelect = false;
  var selectedLeadRecords = <int>[];
  var selectedOrderRecords = <int>[];
  Icon selectIcon = Icon(Icons.check_box_outline_blank);

  void showAlertDialog(String message, TaskModel model, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: message == 'archive' ? Text('Archive Record') : Text(''),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                model.archiveLead(model.leadFollowups[index]['id']);
                model.fetchLeads();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void createDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'CREATE',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8.0,
              ),
              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0)),
                color: Colors.blueAccent,
                child: Text('Lead', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/newlead');
                },
              ),
              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0)),
                color: Colors.blueAccent,
                child: Text(
                  'Direct Order',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/directorder');
                },
              )
            ],
          ),
        );
      },
    );
  }

  buildListView(ToiletServicingsModel model, int index) {
    String custid = model.records[index]['customerid'].toString();
    // String servicedate = model.records[index]['servicedon'].toString();
    // String initials = firstName.substring(0, 1).toUpperCase() +
    //     lastName.substring(0, 1).toUpperCase();
    String formattedDate = DateFormat.yMMMd()
        .format(DateTime.parse(model.records[index]['servicedon']));
    return GestureDetector(
      child: Card(
          elevation: 5.0,
          margin: EdgeInsets.fromLTRB(7.0, 7.0, 7.0, 0.0),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(custid,style: TextStyle(fontSize: 18.0),),
                Text(formattedDate,style: TextStyle(fontSize: 18.0),),
              ],
            ),
          ),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Toilet Servicing'),
      ),
      body: ScopedModel<ToiletServicingsModel>(
        model: ToiletServicingsModel(),
        child: ScopedModelDescendant<ToiletServicingsModel>(
          builder: (context, child, model) {
            model.fetchServicedToilets(widget.id);
            print(model.records);
            return model.records.length == 0
                ? Center(
                    child: Text(
                      'No Records Available',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  )
                : Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: model.records.length,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.insert_drive_file,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          // createDialog();
          Navigator.pushNamed(context, '/newlead');
        },
      ),
    );
  }
}
