import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cbsa_mobile_app/models/toilet_servicing.dart';
// import 'package:cbsa_mobile_app/models/toilet_servicing.dart';
import 'package:cbsa_mobile_app/scoped_model/toilet_servicing_model.dart'
    as scp;
import 'package:cbsa_mobile_app/services/toiletServicing_service.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BarrelCount extends StatefulWidget {
  @override
  _BarrelCountState createState() => _BarrelCountState();
}

class _BarrelCountState extends State<BarrelCount> {
  final _formKey = GlobalKey<FormState>();
  bool scanned = false;
  int update;
  int id;
  // bool first = false;
  bool rest = false;
  bool isupdate = false;
  String barcode = '';
  var barrelReceipientController = new TextEditingController();
  var noOfBarrelsController = new TextEditingController();
  var noOfFullBarrelsController = new TextEditingController();
  var noOfEmptyBarrelsController = new TextEditingController();
  SharedPreferences prefs;
  bool isloading = false;

  void initState() {
    super.initState();
    initSharedPreferences();
  }

  initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future scan(scp.ToiletServicingsModel model) async {
    try {
      String barcode = await BarcodeScanner.scan();
      // String barcode = '123';
      if (model.codeDetailsExist(barcode)) {
        setState(() {
          isupdate=true;
          scanned = true;
          rest = true;
          BarrelCountModel a = model.getCodeDetails(scanned, barcode);
          id=a.serverid;
          barrelReceipientController.text = barcode;
          this.barcode = barcode;
          noOfBarrelsController.text = a.noofbarrels.toString();
          noOfEmptyBarrelsController.text = 0.toString();//a.noofemptybarrels==double.nan? 0 : a.noofemptybarrels.toString();
          noOfFullBarrelsController.text = 0.toString();//a.nooffullbarrels.toString();
        });
      } else {
        setState(() {
          isupdate=false;
          scanned = true;
          rest = false;
          barrelReceipientController.text = barcode;
          noOfEmptyBarrelsController.text=0.toString();
          noOfFullBarrelsController.text=0.toString();
          this.barcode = barcode;
        });
      }
      // setState(() {
      //   this.scanned = true;
      //   noOfEmptyBarrelsController.text = 0.toString();
      //   noOfFullBarrelsController.text = 0.toString();
      //   barrelReceipientController.text = barcode;
      //   this.barcode = barcode;
      // });
      // BarrelCountModel a = model.barcodeExists(scanned, barcode);

      // setState(() {
      //   rest = true;
      //   // isupdate = true;
      //   barrelReceipientController.text = barcode;
      //   this.barcode = barcode;
      //   noOfBarrelsController.text = a.noofbarrels.toString();
      //   noOfEmptyBarrelsController.text =
      //       a.noofemptybarrels == null ? 0 : a.noofemptybarrels.toString();
      //   noOfFullBarrelsController.text = a.nooffullbarrels.toString();
      // });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'Permission denied';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Widget barrelRecipientTextField(scp.ToiletServicingsModel model) {
    return InkWell(
      onTap: () {
        scan(model);
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: barrelReceipientController,
          decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              hintText: 'User'),
        ),
      ),
    );
  }

  Widget noOfBarrelsTextField() {
    return TextFormField(
      controller: noOfBarrelsController,
      enabled: scanned,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Number Of Barrels',
        labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          hintText: 'Number Of Barrels'),
      validator: (value) {
        if (value.isEmpty){
          return 'Required';
        }
      },
    );
  }

  Widget noOfFullBarrelsTextField() {
    return TextFormField(
      controller: noOfFullBarrelsController,
      enabled: rest,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          return 'Required';
        }
      },
      decoration: InputDecoration(
        labelText: 'Number Of Full Barrels',
        labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          hintText: 'Number Of Full Barrels'),
    );
  }

  Widget noOfEmptyBarrelsTextField() {
    return TextFormField(
      controller: noOfEmptyBarrelsController,
      enabled: rest,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Number Of Empty Barrels',
        labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          hintText: 'Number Of Empty Barrels'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Required';
        }
      },
    );
  }

  void showtoast(String title) {
    Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIos: 4,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  void showerrortoast(String title) {
    Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIos: 4,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );
  }

  Widget saveButton() {
    return new ScopedModelDescendant<scp.ToiletServicingsModel>(
      builder: (context, child, model) {
        model.getBarrelCounts();
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
          child: RaisedButton(
            disabledColor: Colors.cyan.shade100,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(17.0),
            child: Text(
              'SAVE',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(13.0)),
            onPressed: !scanned
                ? null
                : () {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        isloading = true;
                      });
                      _formKey.currentState.save();
                      if (isupdate) {
                        var barrelCount = new BarrelCountModel(
                            model.id,
                            prefs.getInt('id'),
                            int.parse(noOfBarrelsController.text),
                            int.parse(noOfEmptyBarrelsController.text),
                            int.parse(noOfFullBarrelsController.text),
                            int.parse(barrelReceipientController.text));
                            barrelCount.setServerId(id);
                        ToiletServicingService.updateBarrelCount(barrelCount)
                            .then((response) {
                          if (response.statusCode == 200) {
                            setState(() {
                              isloading = false;
                            });

                            if (jsonDecode(response.body)['status'] ==
                                'error') {
                              showerrortoast(
                                  jsonDecode(response.body)['message']);
                            } else {
                              // model.updateBarrelCounts(BarrelCountModel.fromMap(
                              //     (json.decode(response.body))['Barrelcount']));
                              model.deleteBarrelCounts(id);
                              Navigator.of(context).pop();
                              showtoast(jsonDecode(response.body)['message']);
                            }
                          } else {
                            setState(() {
                              isloading = false;
                            });

                            showerrortoast('Failed To Connect To Server');
                          }
                        });
                      } else {
                        var barrelCount = new BarrelCountModel(
                            0,
                            prefs.getInt('id'),
                            int.parse(noOfBarrelsController.text),
                            int.parse(noOfEmptyBarrelsController.text),
                            int.parse(noOfFullBarrelsController.text),
                            int.parse(barrelReceipientController.text));
                        print(barrelCount.toMap());
                        ToiletServicingService.recordBarrelCount(barrelCount)
                            .then((response) {
                          if (response.statusCode == 200) {
                            setState(() {
                              isloading = false;
                            });

                            if (jsonDecode(response.body)['status'] ==
                                'error') {
                              showerrortoast(
                                  jsonDecode(response.body)['message']);
                            } else {
                              print(json.decode(response.body));
                              model.saveBarrelCount(BarrelCountModel.fromMap(
                                  (json.decode(response.body))['Barrelcount']));
                              Navigator.of(context).pop();
                              showtoast(jsonDecode(response.body)['message']);
                            }
                          } else {
                            setState(() {
                              isloading = false;
                            });

                            showerrortoast('Failed To Connect To Server');
                          }
                        });
                      }
                    }
                  },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<scp.ToiletServicingsModel>(
      model: new scp.ToiletServicingsModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Barrel Count',
          ),
          elevation: 0.0,
        ),
        body: ModalProgressHUD(
          inAsyncCall: isloading,
          progressIndicator: CircularProgressIndicator(),
          child: Container(
            child: Center(
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ScopedModelDescendant<scp.ToiletServicingsModel>(
                        builder: (context, child, model) {
                      return Padding(
                        padding: EdgeInsets.all(20.0),
                        child: barrelRecipientTextField(model),
                      );
                    }),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: noOfBarrelsTextField(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                      child: noOfFullBarrelsTextField(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                      child: noOfEmptyBarrelsTextField(),
                    ),
                    saveButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
