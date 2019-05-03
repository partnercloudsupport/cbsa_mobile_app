import 'dart:convert';

import 'package:cbsa_mobile_app/models/task.dart';
import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
import 'package:cbsa_mobile_app/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateTask extends StatefulWidget {
  final Tasks task;
  UpdateTask({Key key, this.task}) : super(key: key);

  @override
  _updateTaskState createState() => _updateTaskState();
}

class _updateTaskState extends State<UpdateTask> {
  final _formKey = GlobalKey<FormState>();
  String _name,
      _description,
      _comments,
      _assignedTo,
      _dueDate = DateTime.now().toString();
  var users = ['Dennis', 'Dan'];
  bool isLoading = false;
  DateTime initialDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  var dueDateController = TextEditingController();
   SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    DateTime tdate = DateTime.parse(widget.task.duedate);
    dueDateController.text = tdate.year.toString() +
        '-' +
        tdate.month.toString() +
        '-' +
        tdate.day.toString();
    _name = widget.task.name;
    _description = widget.task.description;
    // _comments = widget.task.comments;
    // _assignedTo = widget.task.assignedTo;
    print(widget.task.toMap());
  }

  initSharedPreferences() async{
    prefs =await SharedPreferences.getInstance();
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
        dueDateController.text = picked.year.toString() +
            '-' +
            picked.month.toString() +
            '-' +
            picked.day.toString();
        _dueDate = picked.toString();
      });
  }

  Widget dueDateTextField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
        child: AbsorbPointer(
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: dueDateController,
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 20.0,color: Colors.black),
              labelText: 'Due Date',
              contentPadding: EdgeInsets.all(10.0),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a due date';
              }
            },
            keyboardType: TextInputType.datetime,
            // onSaved: (value) {
            //   _dueDate = value;
            // },
          ),
        ),
      ),
    );
  }

  Widget nameTextField() {
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
      child: TextFormField(
        initialValue: widget.task.name,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelStyle: TextStyle(fontSize: 20.0,color: Colors.black),
          labelText: 'Name',
          contentPadding: EdgeInsets.all(10.0),
        ),
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter a name';
          }
        },
        onSaved: (value) {
          _name = value;
        },
      ),
    );
  }

  Widget descriptionTextField() {
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
      child: TextFormField(
        initialValue: widget.task.description,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelStyle: TextStyle(fontSize: 20.0,color: Colors.black),
          labelText: 'Description',
          contentPadding: EdgeInsets.all(10.0),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter a description';
          }
        },
        onSaved: (value) {
          _description = value;
        },
      ),
    );
  }

  // Widget commentsTextField() {
  //   return Container(
  //     padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 35.0),
  //     child: TextFormField(
  //       initialValue: widget.task.comments,
  //       textAlign: TextAlign.center,
  //       maxLines: 6,
  //       decoration: InputDecoration(
  //         labelStyle: TextStyle(fontSize: 20.0,color: Colors.black),
  //         labelText: 'Comments',
  //         contentPadding: EdgeInsets.all(10.0),
  //       ),
  //       validator: (value) {},
  //       onSaved: (value) {
  //         _comments = value;
  //       },
  //     ),
  //   );
  // }

  // Widget assignedToDropDown() {
  //   return Container(
  //     padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
  //     child: FormField(
  //       builder: (FormFieldState state) {
  //         return InputDecorator(
  //           decoration: InputDecoration(
  //             labelStyle: TextStyle(fontSize: 20.0),
  //             labelText: 'Assigned To',
  //             contentPadding: EdgeInsets.only(left: 10.0),
  //           ),
  //           child: new DropdownButtonHideUnderline(
  //             child: new DropdownButton(
  //               value: _assignedTo,
  //               onChanged: (String newValue) {
  //                 setState(() {
  //                   _assignedTo = newValue;
  //                 });
  //               },
  //               items: users.map((String value) {
  //                 return new DropdownMenuItem(
  //                   value: value,
  //                   child: new Text(value),
  //                 );
  //               }).toList(),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget createButton() {
    return new ScopedModelDescendant<TaskModel>(
      builder: (context, child, model) {
        return Container(
          padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(13.0),
            child: Text(
              'SAVE',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,),
              textAlign: TextAlign.center,
            ),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0)),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
               try {
                  Fluttertoast.showToast(
                    msg: 'Updating Task',
                    toastLength: Toast.LENGTH_SHORT,
                  );
                  Tasks task = new Tasks(_name, _description, _dueDate,
                      prefs.getInt('id'), prefs.getInt('id'), null);
                      task.setId(widget.task.id);
                
                  TaskService.updateTask(task,widget.task.id).then((response) {
                    print(response.statusCode);
                    // var status = decodedJson['status'];
                    if (response.statusCode == 200) {
                      setState(() {
                        isLoading = false;
                      });
                      var decodedJson = jsonDecode(response.body);
                      model.updateTask(task);
                      model.fetchTasks();
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      Fluttertoast.showToast(
                        msg: 'Failed To Update Task',
                        toastLength: Toast.LENGTH_SHORT
                      );
                    }
                  });
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                  print(e);
                  Fluttertoast.showToast(
                    msg: 'Failed To Connect To Server',
                    toastLength: Toast.LENGTH_SHORT
                  );
                }
              }
            },
          ),
        );
      },
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: isLoading
              ? CircularProgressIndicator()
              : Text('Task Saved Successfully'),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<TaskModel>(
      model: new TaskModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Update Task',
          ),
          elevation: 0.0,
        ),
        body: ScopedModelDescendant<TaskModel>(
          builder: (context, child, model) {
            return Center(
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    nameTextField(),
                    descriptionTextField(),
                    dueDateTextField(context),
                    // commentsTextField(),
                    createButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
