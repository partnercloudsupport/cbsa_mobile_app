import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/customer.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/toilet_installation.dart';
import 'package:cbsa_mobile_app/services/secondary_approvals_service.dart';
import 'package:cbsa_mobile_app/services/toilet_installation_service.dart';
import 'package:cbsa_mobile_app/setup_models.dart/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class GetSAWorkOrderItems extends StatefulWidget {
  final List<Map> itemList;
  final int leadId;
  final int workOrderId;

  const GetSAWorkOrderItems({Key key, this.itemList, this.leadId, this.workOrderId}) : super(key: key);

  @override
  _GetSAWorkOrderItemsState createState() => _GetSAWorkOrderItemsState();
}

class _GetSAWorkOrderItemsState extends State<GetSAWorkOrderItems> {
  int _userId;
  Map<Map, bool> _itemsCheck = {};
  List<int> _itemsSelected = [];
  String _qrcode = '';
  String _serialNumber;
  File _image;
  TextEditingController _commentController = TextEditingController();
  String _comments;

  bool _isLoading = false;
  bool _itemsPicked = false;

  void initState() {
    super.initState();

    getUserId();

    for(var i in widget.itemList) {
      _itemsCheck[i] = false;
    }
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
            _itemsCheck[key] = value;
            setState(() {
              _itemsSelected.add(key['item'].itemId);
            });
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
      onFieldSubmitted: (value) {
        setState(() {
          this._serialNumber = value;
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

  Widget _getComment() {
    return TextFormField(
      decoration:
          InputDecoration(labelText: 'Comment', hasFloatingPlaceholder: true),
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      controller: _commentController,
      onFieldSubmitted: (value) {
        _commentController.text = value;
      },
      onSaved: (value) {
        setState(() {
          _comments = value;
        });
      },
    );
  }

  Widget _submitItems(String uuid) {
    return RaisedButton(
      child: Text('Submit'),
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        Map<String, dynamic> map = {
          'id': uuid,
          'comments': _comments,
          'setStatus': 19
        };

        var response = await SecondaryApprovalsService.submitItems(map);
        var decodedResponse = jsonDecode(response.body);

        if(decodedResponse['status'] == 200) {
          var db = DatabaseHelper();
          var updateLead = await db.updateLead(Lead.map(decodedResponse['lead']));
          if(updateLead > 0) {
            setState(() {
              _isLoading = false;
            });
            Navigator.pop(context);
          }
        }
      },
    );
  }

  Widget _submitButton() {
    return RaisedButton(
      child: Text('Submit'),
      onPressed: () async {
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
          '1,2,3,4,', // _itemsSelected.join(',').toString(), 
          base64Encode(_image.readAsBytesSync()),
          widget.workOrderId
        );
        
        var response = await ToiletInstallationService.saveToiletInstallation(toiletInstallation);
        var decodedResponse = jsonDecode(response.body);

        if(decodedResponse['status'] == 200) {
          var db = DatabaseHelper();

          Lead lead = Lead.map(decodedResponse['lead']);

          int saveLead = await db.updateLead(lead);
          if(saveLead > 0) {
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Toilet Installation'),
          ),
          body: FutureBuilder(
            future: _getLead(),
            builder: (BuildContext context, AsyncSnapshot<Lead> snapshot) {
              return snapshot.hasData
              ? ListView(
                padding: EdgeInsets.all(30),
                children: <Widget>[
                  snapshot.data.approved == 19
                  ? Column(
                    children: <Widget>[
                      _getQRCode(),
                      Divider(),
                      _getSerialNumber(),
                      Divider(),
                      _getImage(),
                      Divider(),
                      _submitButton(),
                    ],
                  )
                  : Column(
                    children: <Widget>[
                      Text('Items Selected: '),
                      _selectItems(),
                      Divider(),
                      _getComment(),
                      Divider(),
                      _submitItems(snapshot.data.uuid),
                      Divider()
                    ],
                  )
                ],
              )
              : Center(child: Text('Does not have data'),);
            },
          ),
        ),
      ),
    );
  }
}