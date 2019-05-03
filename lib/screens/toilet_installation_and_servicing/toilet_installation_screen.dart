import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/customer.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/toilet_installation.dart';
import 'package:cbsa_mobile_app/services/toilet_installation_service.dart';
import 'package:cbsa_mobile_app/setup_models.dart/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class ToiletInstallation extends StatefulWidget {
  final List<Map> itemList;
  final int leadId;

  const ToiletInstallation({Key key, this.itemList, this.leadId}) : super(key: key);

  @override
  _ToiletInstallationState createState() => _ToiletInstallationState();
}

class _ToiletInstallationState extends State<ToiletInstallation> {
  final _toiletInstallationFormKey = GlobalKey<FormState>();

  int _userId;
  Map<Map, bool> _itemsCheck = {};
  List<int> _itemsSelected = [];
  String _qrcode = '';
  String _serialNumber;
  File _image;
  TextEditingController _commentController = TextEditingController();
  TextEditingController _serialNumController = TextEditingController();
  // String _comments;
  bool _isLoading = false;

  void initState() {
    super.initState();

    for(var i in widget.itemList) {
      _itemsCheck[i] = false;
    }

    getUserId();
  }

  Future<Lead> _getLead() async {
    var db = DatabaseHelper();
    var result = await db.getLead(widget.leadId);
    return result;
  }

  void getUserId() async {
    var db = DatabaseHelper();
    var result = await db.getUserObject();
    UserObject user = UserObject.map(result);
    setState(() {
      _userId = user.userId;
    });
  }

  Widget _selectItems() {
    return Column(
      children: _itemsCheck.keys.map((key) {
        return CheckboxListTile(
          title: Text(key['item'].name + ' (' + key['quantity'].toString() + ')'),
          value: _itemsCheck[key],
          onChanged: (bool value) {
            setState(() {
              _itemsCheck[key] = value;
            });
            if(value) {
              _itemsSelected.add(key['item'].itemId);
            } else {
              _itemsSelected.removeLast();
            }
          },
        );
      }).toList(),
    );
  }

  Widget _getQRCode() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Scan QR Code: '),
            RaisedButton(
              child: Text('Scan'),
              onPressed: scan,
            ),
          ],
        ),
        _qrcode == null ? null : Text(_qrcode),
      ],
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this._qrcode = barcode;
      });
    } on PlatformException catch(e) {
      if(e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._qrcode = 'Camera access denied';
        });
      }
      else {
        setState(() {
          this._qrcode = 'Error: Unknown Error';
        });
      }
    } on FormatException {
      setState(() {
        this._qrcode = 'null';
      });
    } catch(e) {
      this._qrcode = 'Unknown Error: $e';
    }
  }

  Widget _getSerialNumber() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Serial Number', hasFloatingPlaceholder: true),
      controller: _serialNumController,
      onFieldSubmitted: (value) {
        setState(() {
          _serialNumController.text = value;
        });
      },
      validator: (value) {
        if(value.isEmpty) {
          return 'Serial Number Is Required';
        }
      },
      onSaved: (value) {
        setState(() {
          _serialNumber = value;
        });
      },
    );
  }

  Widget _getImage() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text('Customer Image'),
              ),
              RaisedButton(
                child: Row(children: <Widget>[Text('Take Photo  '), Icon(Icons.camera_alt)],),
                onPressed: () async {
                  var image = await ImagePicker.pickImage(source: ImageSource.camera);
                  setState(() {
                    _image = image;
                  });
                },
              ),
              FlatButton(
                child: Row(children: <Widget>[Text('Gallery  '), Icon(Icons.collections)],),
                onPressed: () async {
                  var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _image = image;
                  });
                },
              )
            ],
          ),
          Container(
            height: 150,
            width: 120,
            child: _image == null ?
              Center(child: Text('No Image Selected'),) :
              Image.file(_image),
          )
        ],
      );
  }

  Widget _submitButton() {
    return RaisedButton(
      child: Text('Submit'),
      onPressed: () async {
        if(_toiletInstallationFormKey.currentState.validate()) {
          _toiletInstallationFormKey.currentState.save();

          setState(() {
            _isLoading = true;
          });
          Fluttertoast.showToast(
            msg: 'Submitting...',
            toastLength: Toast.LENGTH_LONG
          );

          ToiletInstallationModel toiletInstallation = ToiletInstallationModel(
            widget.leadId, 
            _userId, 
            DateTime.now().toString(), 
            _qrcode, 
            _serialNumber,
            _itemsSelected.join(',').toString(), 
            base64Encode(_image.readAsBytesSync())
          );
          var response = await ToiletInstallationService.saveToiletInstallation(toiletInstallation);
          var decodedResponse = jsonDecode(response.body);

          if(decodedResponse['status'] == 200) {
            var db = DatabaseHelper();

            Lead lead = Lead.map(decodedResponse['lead']);
            Customer customer = Customer.map(decodedResponse['customer']);
            ToiletInstallationModel toiletInstallation = ToiletInstallationModel.map(decodedResponse['toiletinstall']);
            print(decodedResponse['toiletinstall']);

            int saveLead = await db.updateLead(lead);
            int saveCustomer = await db.saveCustomer(customer);
            int updateWorkOrder = await db.updateAssignedWorkOrderStatus(widget.leadId);
            int saveInstallation = await db.saveToiletInstallation(toiletInstallation);

            if(saveLead > 0 && saveCustomer > 0 && updateWorkOrder > 0 && saveInstallation > 0) {
              Fluttertoast.showToast(
                msg: 'Toilet Installation Completed Successfully',
                toastLength: Toast.LENGTH_SHORT,
              );
              setState(() {
                _isLoading = false; 
              });

              Navigator.pop(context);
              Navigator.pop(context);
            } else {
              Fluttertoast.showToast(
                msg: 'An Error Occured When Updating Database',
                toastLength: Toast.LENGTH_SHORT,
              );
              setState(() {
                _isLoading = false; 
              });
            }
          } else {
            setState(() {
              _isLoading = false; 
            });

            Fluttertoast.showToast(
              msg: 'Details Not Submitted',
              toastLength: Toast.LENGTH_SHORT,
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Toilet Installation'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: Form(
            key: _toiletInstallationFormKey,
            child: ListView(
              padding: EdgeInsets.all(30),
              children: <Widget>[
                Text('Items Selected: '),
                _selectItems(),
                Divider(),
                _getQRCode(),
                Divider(),
                _getSerialNumber(),
                Divider(),
                _getImage(),
                Divider(),
                _submitButton(),
              ],
            ),
          ),
        )
      ),
    );
  }
}