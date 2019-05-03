import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cbsa_mobile_app/scoped_model/health_inspection_model.dart';
import 'package:cbsa_mobile_app/services/health_inspection_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';

class PerformInspection extends StatefulWidget {
  final int leadId, inspectionId;

  PerformInspection({Key key, this.leadId, this.inspectionId}) : super(key: key);

  @override
  _PerformInspectionState createState() => _PerformInspectionState();
}

class _PerformInspectionState extends State<PerformInspection> {
  final _inspectionFormKey = GlobalKey<FormState>();

  String _qrcode = '';
  String _use = 'Yes';
  List<String> _useOptions = ['Yes', 'No'];
  String _state = 'Clean';
  List<String> _stateOptions = ['Very Clean', 'Clean', 'Acceptable', 'Bad'];
  String _flush = 'Functional';
  List<String> _flushOptions = ['Functional', 'Needs Repair'];
  String _cubicle = 'Good Condition';
  List<String> _cubicleOptions = ['Good Condition', 'Needs Repair'];
  String _location = 'Yes';
  List<String> _locationOptions = ['Yes', 'No'];
  String _satisfaction = 'Yes';
  List<String> _satisfactionOptions = ['Yes', 'No'];
  int _containers;
  TextEditingController _containersController = TextEditingController();
  String _trashcan = 'Yes';
  List<String> _trashcanOptions = ['Yes', 'No'];
  String _urineGallon = 'Yes';
  List<String> _urineGallonOptions = ['Yes', 'No'];
  String _depot = 'Yes';
  List<String> _depotOptions = ['Yes', 'No'];
  String _comment;
  TextEditingController _commentController = TextEditingController();
  bool _loading = false;
  
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
        this._qrcode = 'No Item Scanned';
      });
    } catch(e) {
      this._qrcode = 'Unknown Error: $e';
    }
  }

  Widget _toiletUse() {
    return (
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Is Customer Using Toilet?'),
          DropdownButton<String>(
            value: _use,
            items: _useOptions.map((use) {
              return DropdownMenuItem<String>(
                value: use,
                child: Text(use),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                this._use = value;
              });
            },
          )
        ],
      )
    );
  }

  Widget _toiletState() {
    return (
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Toilet State'),
          DropdownButton<String>(
            value: _state,
            items: _stateOptions.map((state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Text(state),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                this._state = value;
              });
            },
          )
        ],
      )
    );
  }

  Widget _waterlessFlush() {
    return (
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Waterless Flush'),
          DropdownButton<String>(
            value: _flush,
            items: _flushOptions.map((flush) {
              return DropdownMenuItem<String>(
                value: flush,
                child: Text(flush),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                this._flush = value;
              });
              // select issues from checkboxes
              // assign users
            },
          )
        ],
      )
    );
  }

  Widget _toiletCubicle() {
    return (
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Toilet Cubicle'),
          DropdownButton<String>(
            value: _cubicle,
            items: _cubicleOptions.map((cubicle) {
              return DropdownMenuItem<String>(
                value: cubicle,
                child: Text(cubicle),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                this._cubicle = value;
              });
            },
          )
        ],
      )
    );
  }

  Widget _toiletLocation() {
    return (
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Is Toilet In Protected Location?'),
          DropdownButton<String>(
            value: _location,
            items: _locationOptions.map((location) {
              return DropdownMenuItem<String>(
                value: location,
                child: Text(location),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                this._location = value;
              });
            },
          )
        ],
      )
    );
  }

  Widget _customerSatisfaction() {
    return (
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Is Customer Satisfied?'),
          DropdownButton<String>(
            value: _satisfaction,
            items: _satisfactionOptions.map((satisfaction) {
              return DropdownMenuItem<String>(
                value: satisfaction,
                child: Text(satisfaction),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                this._satisfaction = value;
              });
            },
          )
        ],
      )
    );
  }
  
  Widget _numberOfContainers() {
    return (
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Number of Containers', 
          hasFloatingPlaceholder: true,
          border: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
          )
        ),
        keyboardType: TextInputType.number,
        controller: _containersController,
        validator: (value) {
          if (value.isEmpty) {
            return 'Number of Containers is Required';
          }
        },
        onFieldSubmitted: (value) {
          _containersController.text = value;
        },
        onSaved: (value) {
          setState(() {
            this._containers = int.parse(value);
          });
        },
      )
    );
  }

  Widget _trashcanPresent() {
    return (
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Is Trashcan Present?'),
          DropdownButton<String>(
            value: _trashcan,
            items: _trashcanOptions.map((trashcan) {
              return DropdownMenuItem<String>(
                value: trashcan,
                child: Text(trashcan),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                this._trashcan = value;
              });
            },
          )
        ],
      )
    );
  }

  Widget _urineGallonPresent() {
    return (
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Is Urine Gallon Present?'),
          DropdownButton<String>(
            value: _urineGallon,
            items: _urineGallonOptions.map((urineGallon) {
              return DropdownMenuItem<String>(
                value: urineGallon,
                child: Text(urineGallon),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                this._urineGallon = value;
              });
            },
          )
        ],
      )
    );
  }

  Widget _getDepot() {
    return (
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Does Customer Know Where Depot Is?'),
          DropdownButton<String>(
            value: _depot,
            items: _depotOptions.map((depot) {
              return DropdownMenuItem<String>(
                value: depot,
                child: Text(depot),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                this._depot = value;
              });
            },
          )
        ],
      )
    );
  }

  Widget _getComment() {
    return (
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Comment', 
          hasFloatingPlaceholder: true,
          border: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
          )
        ),
        maxLines: 3,
        controller: _commentController,
        onFieldSubmitted: (value) {
          _commentController.text = value;
        },
        onSaved: (value) {
          setState(() {
            this._comment = value;
          });
        },
      )
    );
  }

  Widget _submitButton(HealthInspectionModel model) {
    return RaisedButton(
      child: Text('Submit'),
      onPressed: () async {
        if(_inspectionFormKey.currentState.validate()) {
          _inspectionFormKey.currentState.save();

          setState(() {
            _loading = true;
          });

          Map<String, dynamic> map = {
            'date': DateTime.now().toString(),
            'customerid': widget.leadId.toString(),
            'noofcontainers' : _containers.toString(),
            'toiletstate' : _state,
            'protectedlocation' : _location,
            'cussastisfaction' : _satisfaction,
            'depotaware' : _depot,
            'trashcanpresent' : _trashcan,
            'gallonpresent' : _urineGallon,
            'qrcode' : 'asdfasdf', // _qrcode,
            'cubiclestate' : _cubicle,
            'istoiletused' : _use,
            'flush': _flush,
            'comment': _comment,
          };
          
          var response = await HealthInspectionService.submitInspection(map);
          var decodedResponse = jsonDecode(response.body);

          if(decodedResponse['status'] == 200) {
            Fluttertoast.showToast(
              msg: 'Inspection Recorded Successfully',
              toastLength: Toast.LENGTH_SHORT
            );
            setState(() {
              _loading = false;
            });

            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Fluttertoast.showToast(
              msg: 'An Error Occured. Inspection Not Recorded',
              toastLength: Toast.LENGTH_SHORT
            );
            setState(() {
              _loading = false;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: HealthInspectionModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Health Inspection'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              padding: EdgeInsets.all(30),
              child: ScopedModelDescendant<HealthInspectionModel>(
                builder: (context, child, model) {
                  return Form(
                    key: _inspectionFormKey,
                    child: ListView(
                      children: <Widget>[
                        _getQRCode(),
                        Divider(),
                        _toiletUse(),
                        Divider(),
                        _toiletState(),
                        Divider(),
                        _waterlessFlush(),
                        Divider(),
                        _toiletCubicle(),
                        Divider(),
                        _toiletLocation(),
                        Divider(),
                        _customerSatisfaction(),
                        Divider(),
                        _numberOfContainers(),
                        Divider(),
                        _trashcanPresent(),
                        Divider(),
                        _urineGallonPresent(),
                        Divider(),
                        _getDepot(),
                        Divider(),
                        _getComment(),
                        Divider(),
                        _submitButton(model)
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}