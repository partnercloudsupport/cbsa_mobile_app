import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
import 'package:cbsa_mobile_app/screens/lead/view_lead_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Archive extends StatefulWidget {
  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  bool allowSelect = false;
  var selectedLeadRecords = <int>[];
  Icon selectIcon = Icon(Icons.check_box_outline_blank);

  void showAlertDialog(String message, TaskModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: message == 'archive' ? Text('Restore Record') : Text(''),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                model.unarchiveLead(selectedLeadRecords);
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

  buildListView(TaskModel model, int index) {
    String firstName = model.leadArchives[index]['firstName'].toString() ;
    String lastName = model.leadArchives[index]['lastName'].toString();
    String initials =  firstName.substring(0, 1).toUpperCase() +
        lastName.substring(0, 1).toUpperCase();
    return GestureDetector(
      onTap: () {
        model.fetchLead(model.leadArchives[index]['id']);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ViewLead(
        //           lead: model.lead,
        //         ),
        //   ),
        // );
      },
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 5.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Hero(
                          tag: initials,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(initials),
                            radius: 30.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(firstName + ' ' + lastName),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(model.leadArchives[index]['primaryTelephone']),
                        SizedBox(
                          height: 10.0,
                        ),
                        // Text(formattedDate),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Visibility(
                    visible: allowSelect,
                    child: Checkbox(
                      value: selectedLeadRecords
                          .contains(model.leadArchives[index]['id']),
                      onChanged: (value) {
                        if (value) {
                          selectedLeadRecords
                              .add(model.leadArchives[index]['id']);
                        } else {
                          selectedLeadRecords
                              .remove(model.leadArchives[index]['id']);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text('Restore'),
                        onPressed: () {
                          selectedLeadRecords.add(model.leadArchives[index]['id']);
                          showAlertDialog('archive', model);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
          title: Text('Archives'),
        ),
        body: ScopedModel<TaskModel>(
          model: TaskModel(),
          child: TabBarView(
            children: <Widget>[
              ScopedModelDescendant<TaskModel>(
                builder: (context, child, model) {
                  model.fetchLeads();
                  return model.leadArchives.length==0 ? Center(child: Text('No Archives Available',style: TextStyle(fontSize: 18.0,color: Colors.white),),):
                  Column(
                    children: <Widget>[
                      Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Row(
                                children: <Widget>[
                                  Visibility(
                                    visible: allowSelect,
                                    child: Checkbox(
                                      value: selectedLeadRecords.length ==
                                          model.leadArchives.length,
                                      onChanged: (value) {
                                        if (value) {
                                          setState(() {
                                            selectedLeadRecords.clear();
                                            model.leadArchives.forEach(
                                                (leads) => selectedLeadRecords
                                                    .add(leads['id']));
                                          });
                                        } else {
                                          setState(() {
                                            model.leadArchives.forEach(
                                                (leads) => selectedLeadRecords
                                                    .remove(leads['id']));
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  FlatButton(
                                    color: Colors.white,
                                    child: Text('Select'),
                                    onPressed: () {
                                      setState(
                                        () {
                                          if (allowSelect) {
                                            allowSelect = false;
                                            selectedLeadRecords.clear();
                                          } else {
                                            allowSelect = true;
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 7.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton(
                                    color: Colors.white,
                                    child: Text('Restore'),
                                    onPressed: selectedLeadRecords.isEmpty &&
                                            allowSelect == false
                                        ? null
                                        : () {
                                            showAlertDialog('archive', model);
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: model.leadArchives.length,
                          itemBuilder: (BuildContext context, index) {
                            return buildListView(model, index);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
