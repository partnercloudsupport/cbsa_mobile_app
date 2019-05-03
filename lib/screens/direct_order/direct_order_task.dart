import 'package:cbsa_mobile_app/models/direct_order.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
import 'package:cbsa_mobile_app/screens/tasks/new_task_screen.dart';
import 'package:cbsa_mobile_app/screens/tasks/update_task.dart';
import 'package:cbsa_mobile_app/screens/tasks/view_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class DirectOrderTask extends StatefulWidget {
  final Lead lead;
  DirectOrderTask({Key key, this.lead}) : super(key: key);

  @override
  _DirectOrderTaskState createState() => _DirectOrderTaskState();
}

class _DirectOrderTaskState extends State<DirectOrderTask> {

  bool allowSelect = false;
  var selectedLeadRecords = <int>[];
  var selectedOrderRecords = <int>[];
  String _followUpDate=DateTime.now().toString();
  DateTime initialDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  var followUpDateController = TextEditingController();
  var followupPopupList = ['New', 'History'];

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

  void showAlertDialog(String message, TaskModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: message == 'archive' ? Text('Archive Follow Up') : Text(''),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
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
        _followUpDate=picked.toString();
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


  void showRescheduleDialog(String message, TaskModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change FollowUp Date'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              followUpDateTextField(context)
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Save'),
              onPressed: () {
                // model.archiveLead(model.leadFollowups[index]['id'], archived)
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
    DateTime date = DateTime.parse(model.tasks[index]['date']);
    String formattedDate = date.day.toString() +
        ' - ' +
        date.month.toString() +
        ' - ' +
        date.year.toString();
    return InkWell(
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(formattedDate),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(model.tasks[index]['name']),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(model.tasks[index]['description']),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.view_list),
                          onPressed: () {
                            model.fetchTask(model.tasks[index]['id']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewTask(
                                      task: model.task,
                                    ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            model.fetchTask(model.tasks[index]['id']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateTask(
                                      task: model.task,
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: <Widget>[
            //     FlatButton(
            //       child: Text('Reschedule'),
            //       onPressed: () {
            //         showRescheduleDialog(null, model);
            //       },
            //     ),
            //     FlatButton(
            //       child: Text('Archive'),
            //       onPressed: () {
            //         showAlertDialog('archive', model);
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    String initials =  widget.lead.firstName.substring(0, 1).toUpperCase() +
    widget.lead.lastName.substring(0, 1).toUpperCase();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Tasks'),
        ),
        body: ScopedModel<TaskModel>(
          model: TaskModel(),
          child: ScopedModelDescendant<TaskModel>(
            builder: (context, child, model) {
              model.fetchTasks();
              return Column(
                children: <Widget>[
                  initials==null? SizedBox(height: 0.0,) : Expanded(
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
                                tag: initials,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    initials,
                                    style: TextStyle(fontSize: 35.0),
                                  ),
                                  radius: 50.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10.0,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.lead.firstName + ' ' + widget.lead.lastName,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Theme.of(context).primaryColor),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: ListView.builder(
                      itemCount: model.tasks.length,
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
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewTask(id: widget.lead.id,)),
              // MaterialPageRoute(builder: (context) => NewTask()),
            );
          },
        ),
      ),
    );
  }
}