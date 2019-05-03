import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
import 'package:cbsa_mobile_app/screens/follow_ups/new_follow_up_screen.dart';
import 'package:cbsa_mobile_app/screens/follow_ups/update_followup.dart';
import 'package:cbsa_mobile_app/screens/follow_ups/view_followup_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';

class Followups extends StatefulWidget {
  final String initials;
  final String fullName;
  final int id;
  Followups({Key key, this.initials, this.fullName, this.id}) : super(key: key);

  @override
  _FollowupsState createState() => _FollowupsState();
}

class _FollowupsState extends State<Followups> {
  bool allowSelect = false;
  var selectedLeadRecords = <int>[];
  var selectedOrderRecords = <int>[];
  String _followUpDate = DateTime.now().toString();
  DateTime initialDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  var followUpDateController = TextEditingController();
  var followupPopupList = ['New', 'History'];
  bool isloading = false;

  Widget followupDropdown() {
    return DropdownButton(
      onChanged: (String newValue) {
        setState(() {});
      },
      items: followupPopupList.map((String value) {
        return new DropdownMenuItem(
          value: value,
          child: new Text(value),
        );
      }).toList(),
    );
  }

  void showAlertDialog(String message, TaskModel model, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: message == 'archive' ? Text('Archive Follow Up') : Text(''),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                setState(() {
                  isloading = true;
                });
                Fluttertoast.showToast(
                    msg: 'Archiving Followup', toastLength: Toast.LENGTH_LONG);
                int result = await model
                    .archiveRemoteFollowup(model.followups[index]['id']);
                print(result);
                if (result == 1) {
                  model.archiveLead(model.followupsById[index]['id']);
                  setState(() {
                    isloading = false;
                  });
                  Fluttertoast.showToast(
                      msg: 'Successfully Archive Followup',
                      toastLength: Toast.LENGTH_LONG);
                } else {
                  isloading = false;
                  Fluttertoast.showToast(
                      msg: 'Failed To Archive Followup',
                      toastLength: Toast.LENGTH_LONG);
                }
                // model.archiveLead(model.leadFollowups[index]['id'], archived)
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: initialDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        followUpDateController.text = picked.year.toString() +
            '-' +
            picked.month.toString() +
            '-' +
            picked.day.toString();
        _followUpDate = picked.toString();
      });
  }

  Widget followUpDateTextField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
        child: AbsorbPointer(
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: followUpDateController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
            ),
          ),
        ),
      ),
    );
  }

  void showRescheduleDialog(String message, TaskModel model, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change FollowUp Date'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[followUpDateTextField(context)],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Save'),
              onPressed: () async {
                setState(() {
                  isloading = true;
                });
                Fluttertoast.showToast(
                    msg: 'Rescheduling Followup',
                    toastLength: Toast.LENGTH_LONG);
                int result = await model.rescheduleRemoteFollowup(
                    model.followups[index], _followUpDate);
                if (result == 1) {
                  model.rescheduleFollowup(
                      model.followupsById[index]['id'], _followUpDate);
                  setState(() {
                    isloading = false;
                  });
                  Fluttertoast.showToast(
                      msg: 'Successfully Rescheduled Followup',
                      toastLength: Toast.LENGTH_LONG);
                } else {
                  isloading = false;
                  Fluttertoast.showToast(
                      msg: 'Failed To Reschedule Followup',
                      toastLength: Toast.LENGTH_LONG);
                }
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  buildListView(TaskModel model, int index) {
    return InkWell(
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(model.followupsById[index]['type']),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(model.followupsById[index]['paystate']),
                        // Text(status),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            model.fetchfollowUp(
                                model.followupsById[index]['id']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateFollowUp(
                                      followup: model.followup,
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text('Reschedule'),
                  onPressed: () {
                    showRescheduleDialog(null, model, index);
                  },
                ),
                FlatButton(
                  child: Text('Archive'),
                  onPressed: () {
                    showAlertDialog('archive', model, index);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        model.fetchfollowUp(model.followupsById[index]['id']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewFollowup(
                  followup: model.followup,
                ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Follow Ups'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: isloading,
          child: ScopedModel<TaskModel>(
            model: TaskModel(),
            child: ScopedModelDescendant<TaskModel>(
              builder: (context, child, model) {
                model.fetchFollowUps();
                model.fetchfollowUpsById(widget.id);
                return Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Card(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Hero(
                                  tag: 'profileImg',
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: Text(
                                      widget.initials,
                                      style: TextStyle(
                                          fontSize: 35.0, color: Colors.white),
                                    ),
                                    radius: 40.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.fullName,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: model.followupsById.length == 0
                          ? Center(
                              child: Text(
                                'No followups available',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                            )
                          : ListView.builder(
                              itemCount: model.followupsById.length,
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
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewFollowUp(id: widget.id)),
            );
          },
        ),
      ),
    );
  }
}
