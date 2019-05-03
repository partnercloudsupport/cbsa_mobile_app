import 'dart:async';
import 'dart:convert';
import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/complaintModel.dart';
import 'package:cbsa_mobile_app/models/complaintTypeModel.dart';
import 'package:cbsa_mobile_app/scoped_model/customer_model.dart';
import 'package:cbsa_mobile_app/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'package:flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewComplaint extends StatefulWidget {
  final int id;
  NewComplaint({Key key, @required this.id}) : super(key: key);

  @override
  _NewComplaintState createState() => _NewComplaintState();
}

class _NewComplaintState extends State<NewComplaint> {
  final _formKey = GlobalKey<FormState>();
  SharedPreferences prefs;
  List<String> _complainerTypeList = ['Staff', 'Customer'];
  ComplaintType _complaintType;
  List<ComplaintType> _complaintTypeList = [];

  bool isLoading = false;
  var commentsController = TextEditingController();
  var complaintController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    fetchComplaintTypes();
  }

  initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void fetchComplaintTypes() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getComplaintTypes();
    List<ComplaintType> complaintTypes = list.map((complaintType) {
      return ComplaintType.fromMap(complaintType);
    }).toList();
    setState(() {
      this._complaintTypeList = complaintTypes;
      if (_complaintTypeList.length > 0) {
        this._complaintType = _complaintTypeList.first;
      }
    });
  }

  Widget _getComplaintType() {
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
      child: FormField(
        builder: (FormFieldState state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 22.0),
              // border:
              //     OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Complaint Type',
              contentPadding: EdgeInsets.all(8.0),
            ),
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton<ComplaintType>(
                value: _complaintType,
                onChanged: (value) {
                  setState(() {
                    this._complaintType = value;
                  });
                  print(value);
                },
                items: _complaintTypeList.map((cmptyp) {
                  return DropdownMenuItem<ComplaintType>(
                    value: cmptyp,
                    child: Text(cmptyp.name),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getComplaint() {
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
      child: TextFormField(
        decoration: InputDecoration(
            isDense: false,
            contentPadding: EdgeInsets.all(10.0),
            labelText: 'Complaint',
            // labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
            hasFloatingPlaceholder: true),
        controller: complaintController,
        onFieldSubmitted: (value) {
          complaintController.text = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Required';
          }
        },
      ),
    );
  }

  Widget _getComments() {
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
      child: TextFormField(
        maxLines: 4,
        decoration: InputDecoration(
            isDense: false,
            contentPadding: EdgeInsets.all(10.0),
            labelText: 'Comments',
            // labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
            hasFloatingPlaceholder: true),
        controller: commentsController,
        onFieldSubmitted: (value) {
          commentsController.text = value;
        },
        // validator: (val){
        //   if(val.isEmpty){
        //     return 'Required';
        //   }
        // },
      ),
    );
  }

  Widget saveButton() {
    return new ScopedModelDescendant<CustomerModel>(
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
                Complaint c = new Complaint(
                    widget.id,
                    _complaintType.id,
                    complaintController.text,
                    commentsController.text,
                    prefs.getInt('id'));
                CustomerService.saveComplaint(c).then((res) {
                  setState(() {
                    isLoading = false;
                  });
                  if (res.data['status'] == 200) {
                    if (res.data['message'] == 'error') {
                      Fluttertoast.showToast(
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        msg: res.data['message'],
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    } else {
                      Navigator.of(context).pop();
                      Fluttertoast.showToast(
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        msg: res.data['message'],
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    }
                  } else {
                    Fluttertoast.showToast(
                      backgroundColor: Colors.red,
                        textColor: Colors.white,
                      msg: 'There was an error executing your request',
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }
                });
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<CustomerModel>(
      model: new CustomerModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Record Complaint',
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
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  _getComplaintType(),
                  _getComplaint(),
                  _getComments(),
                  saveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
