import 'dart:async';
import 'dart:convert';
import 'package:cbsa_mobile_app/models/followUp.dart';
import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
import 'package:cbsa_mobile_app/services/follow_up_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';

class NewFollowUp extends StatefulWidget {
  final int id;
  NewFollowUp({Key key, @required this.id}) : super(key: key);

  @override
  _NewFollowUpState createState() => _NewFollowUpState();
}

class _NewFollowUpState extends State<NewFollowUp> {
  final _formKey = GlobalKey<FormState>();
  List<String> _followUpTypeList = ['Visit', 'Call'];
  List<String> _followUpStatusList = [
    'Yes',
    'No, number was bad',
    'No, no answer',
    'No, not at home'
  ];
  List<String> _isInterestedList = ['Yes', 'No'];
  List<String> _readyToPayList = [
    'Ready now',
    'Gave a future date',
    'Not ready',
    'No longer interested -hard',
        'No longer interested -soft'
  ];
  List<String> _hasPreparedSpaceList = ['Yes', 'No', 'Gave a future date',
    'No longer interested -hard',
        'No longer interested -soft'];
  String _followUpType = 'Visit';
  String _followUpStatus = 'Yes';
  String _isInterested = 'Yes';
  String _readyToPay = 'Ready now';
  String _hasPreparedSpace = 'Yes';
  String _followUpDate, _siteInspectionDate, _installationDate;
  String _comments;
  DateTime initialDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  var followUpDateController = TextEditingController();
  var siteInspectionDateController = TextEditingController();
  var installationDateController = TextEditingController();
  FollowUps followUp;

  @override
  void initState() {
    super.initState();
  }

  Widget followUpTypeDropDown() {
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
      child: FormField(
        builder: (FormFieldState state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 20.0),
              labelText: 'Type Of Follow Up',
              contentPadding: EdgeInsets.only(left: 10.0),
            ),
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton(
                value: _followUpType,
                onChanged: (String newValue) {
                  setState(() {
                    _followUpType = newValue;
                  });
                },
                items: _followUpTypeList.map((String value) {
                  return new DropdownMenuItem(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget followUpStatusDropDown() {
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
      child: FormField(
        builder: (FormFieldState state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 20.0),
              labelText: 'Did you reach prospect',
              contentPadding: EdgeInsets.only(left: 10.0),
            ),
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton(
                value: _followUpStatus,
                onChanged: (String newValue) {
                  setState(() {
                    _followUpStatus = newValue;
                  });
                },
                items: _followUpStatusList.map((String value) {
                  return new DropdownMenuItem(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget isInterestedDropDown() {
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
      child: FormField(
        builder: (FormFieldState state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 20.0),
              labelText: 'Is lead Interested',
              contentPadding: EdgeInsets.only(left: 10.0),
            ),
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton(
                value: _isInterested,
                onChanged: (String newValue) {
                  setState(() {
                    _isInterested = newValue;
                  });
                },
                items: _isInterestedList.map((String value) {
                  return new DropdownMenuItem(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget readyToPayDropDown() {
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
      child: FormField(
        builder: (FormFieldState state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 20.0),
              labelText: 'Ready To Pay',
              contentPadding: EdgeInsets.only(left: 10.0),
            ),
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton(
                value: _readyToPay,
                onChanged: (String newValue) {
                  setState(() {
                    _readyToPay = newValue;
                  });
                },
                items: _readyToPayList.map((String value) {
                  return new DropdownMenuItem(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget hasPreparedSpaceDropDown() {
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
      child: FormField(
        builder: (FormFieldState state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 20.0),
              labelText: 'Prepared Space',
              contentPadding: EdgeInsets.only(left: 10.0),
            ),
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton(
                value: _hasPreparedSpace,
                onChanged: (String newValue) {
                  setState(() {
                    _hasPreparedSpace = newValue;
                  });
                },
                items: _hasPreparedSpaceList.map((String value) {
                  return new DropdownMenuItem(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context, String type) async {
    final DateTime picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        initialDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      switch (type) {
        case 'followup':
          setState(() {
            selectedDate = picked;
            followUpDateController.text = DateFormat.yMMMd().format(picked);
            _followUpDate = picked.toString();
          });
          break;
        case 'inspection':
          setState(() {
            selectedDate = picked;
            siteInspectionDateController.text =
                DateFormat.yMMMd().format(picked);
            _siteInspectionDate = picked.toString();
          });
          break;
        case 'installation':
          setState(() {
            selectedDate = picked;
            installationDateController.text = DateFormat.yMMMd().format(picked);
            _installationDate = picked.toString();
          });
          break;
      }
  }

  Widget followUpDateTextField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context, "followup"),
      child: Container(
        padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
        child: AbsorbPointer(
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: followUpDateController,
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 20.0),
              labelText: 'Follow Up Date',
              contentPadding: EdgeInsets.all(10.0),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Follow Up Date Is Required";
              }
            },
            // onSaved: (value) {
            //   _followUpDate = value;
            // },
          ),
        ),
      ),
    );
  }

  Widget siteInspectionDateTextField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context, 'inspection'),
      child: Container(
        padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
        child: AbsorbPointer(
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: siteInspectionDateController,
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 20.0),
              labelText: 'Site Inspection Date',
              contentPadding: EdgeInsets.all(10.0),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Site Inspection Date Is Required";
              }
            },
            // onSaved: (value) {
            //   _followUpDate = value;
            // },
          ),
        ),
      ),
    );
  }

  Widget installationDateTextField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context, 'installation'),
      child: Container(
        padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
        child: AbsorbPointer(
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: installationDateController,
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 20.0),
              labelText: 'Installation Date',
              contentPadding: EdgeInsets.all(10.0),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Installation Date Is Required";
              }
            },
            // onSaved: (value) {
            //   _followUpDate = value;
            // },
          ),
        ),
      ),
    );
  }

  Widget commentsTextField() {
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 35.0),
      child: TextFormField(
        maxLines: 3,
        decoration: InputDecoration(
          labelStyle: TextStyle(fontSize: 15.0),
          labelText: 'Comments',
          contentPadding: EdgeInsets.all(10.0),
        ),
        validator: (value) {},
        onSaved: (value) {
          _comments = value;
        },
      ),
    );
  }

  Widget saveButton() {
    return new ScopedModelDescendant<TaskModel>(
      builder: (context, child, model) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(13.0),
            child: Text(
              'SAVE',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0)),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                setState(() {
                  isLoading = !isLoading;
                });

                try {
                  Fluttertoast.showToast(
                    msg: 'Saving Followup',
                    toastLength: Toast.LENGTH_SHORT,
                  );
                  FollowUps followup = new FollowUps(
                      widget.id,
                      _followUpStatus,
                      _followUpType,
                      _followUpDate,
                      _isInterested,
                      _comments,
                      _readyToPay,
                      _hasPreparedSpace,
                      _siteInspectionDate,
                      _installationDate);

                  print(jsonEncode(followup.toMap()));

                  FollowUpService.createFollowUp(followup).then((response) {
                    // print(response.body);
                    // var status = decodedJson['status'];
                    if (response.statusCode == 200) {
                      setState(() {
                        isLoading = false;
                      });
                      var decodedJson = jsonDecode(response.body);
                      model.addFollowUp(FollowUps.map(decodedJson['followup']));
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      Fluttertoast.showToast(
                          msg: 'Failed To Add Followup',
                          toastLength: Toast.LENGTH_SHORT);
                    }
                  });
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                  Fluttertoast.showToast(
                      msg: 'Failed To Connect To Server',
                      toastLength: Toast.LENGTH_SHORT);
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
              : Text('Follow Up Saved Successfully'),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
            'Create Follow Up',
          ),
          elevation: 0.0,
        ),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(),
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: ListView(
                      children: <Widget>[
                        followUpTypeDropDown(),
                        followUpStatusDropDown(),
                        isInterestedDropDown(),
                        Visibility(
                          visible: _isInterested == 'Yes',
                          child: Column(
                            children: <Widget>[
                              readyToPayDropDown(),
                              Visibility(
                                visible: _readyToPay!='No longer interested -hard' && _readyToPay != 'No longer interested -soft',
                                child: Column(
                                  children: <Widget>[
                                    hasPreparedSpaceDropDown(),
                                    Visibility(
                                      visible: _hasPreparedSpace != 'No longer interested -hard' && _hasPreparedSpace!='No longer interested -soft',
                                      child: Column(
                                        children: <Widget>[
                                          Visibility(
                                            visible: _hasPreparedSpace!='Yes',
                                            child: followUpDateTextField(context),
                                            replacement: Column(
                                              children: <Widget>[
                                                siteInspectionDateTextField(context),
                                                installationDateTextField(context),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      replacement: commentsTextField(),
                                    ),
                                  ],
                                ),
                                replacement: commentsTextField(),
                              ),
                            ],
                          ),
                          replacement: commentsTextField(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: saveButton(),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
