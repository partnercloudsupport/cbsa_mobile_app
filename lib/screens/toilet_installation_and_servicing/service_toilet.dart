import 'dart:convert';

import 'package:cbsa_mobile_app/models/toilet_servicing.dart';
import 'package:cbsa_mobile_app/scoped_model/toilet_servicing_model.dart';
import 'package:cbsa_mobile_app/screens/toilet_installation_and_servicing/toilet_servicing_records.dart';
import 'package:cbsa_mobile_app/services/toiletServicing_service.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceToilet extends StatefulWidget {
  @override
  _ServiceToiletState createState() => _ServiceToiletState();
}

class GridItem {
  String title;
  Icon icon;
  bool hasBadge;
  GridItem({this.title, this.icon, this.hasBadge});
}

class _ServiceToiletState extends State<ServiceToilet> {
  String barcode = '';
  String serviceToiletCode = '';
  String serialNumber = '';
  String accountId = '';
  bool scanned = false;
  SharedPreferences prefs;
  bool isloading = false;
  var barcodeController = new TextEditingController();

  void initState() {
    super.initState();
    initSharedPreferences();
  }

  initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  List<GridItem> operations = <GridItem>[
    new GridItem(
      title: 'Serviced Toilets',
    ),
    new GridItem(title: 'Failed Servicing'),
    new GridItem(title: 'Scheduled Servicing')
  ];

  _getGridViewItems(BuildContext context) {
    List<Widget> allWidgets = new List<Widget>();
    for (int i = 0; i < operations.length; i++) {
      var widget = homeCard(operations[i].title);
      allWidgets.add(widget);
    }
    return allWidgets;
  }

  Future scan() async {
    try {
      setState(() {
        barcodeController.text = '';
      });
      String code = await BarcodeScanner.scan();

      setState(() {
        this.scanned = true;
        this.serviceToiletCode = code;
        barcodeController.text = code;
      });
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

  serviceToilet(String type) async {
    switch (type) {
      case 'regular':
        String barcode = await BarcodeScanner.scan();
        Response response = await ToiletServicingService.serviceToilet(
            new ToiletServicingModel(barcode, prefs.getInt('id')));
        if (response.statusCode == 200) {
          if (jsonDecode(response.body)['status'] == 'error') {
            showerrortoast('Failed To Service Toilet');
          } else {
            showtoast('Toilet Serviced Successfully');
          }
        } else {
          showerrortoast('There was an error executing your request');
        }
        break;
      case 'adhoc':
        String barcode = await BarcodeScanner.scan();
        Response response = await ToiletServicingService.serviceAdhocToilet(
            new ToiletServicingModel(barcode, prefs.getInt('id')));
        if (response.statusCode == 200) {
          if (jsonDecode(response.body)['status'] == 'error') {
            showerrortoast('Adhoc Toilet Servicing Unsuccessful');
          } else {
            showtoast('Adhoc Toilet Servicing Successful');
          }
          Navigator.of(context).pop();
        } else {
          showerrortoast('There was an error executing your request');
          Navigator.of(context).pop();
        }
        break;
      case 'requestqrcode':
        Response response = await ToiletServicingService.requestQrCode(
            new AdhocServicingModel(
                barcodeController.text, prefs.getInt('id')));
        if (response.statusCode == 200) {
          if (jsonDecode(response.body)['status'] == 'error') {
            showerrortoast('QrCode Request Unsuccessful');
          } else {
            showtoast('QrCode Request Successful');
          }
          Navigator.of(context).pop();
        } else {
          showerrortoast('There was an error executing your request');
          Navigator.of(context).pop();
        }
        break;
    }
  }

  Widget scanOutputTextField() {
    return InkWell(
      onTap: scan,
      child: AbsorbPointer(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.87,
          child: TextFormField(
            controller: barcodeController,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            // controller: _usernameController,
            decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                hintText: 'Scan QR CODE'),
          ),
        ),
      ),
    );
  }

  Widget serialNumberTextField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.87,
      child: TextFormField(
        decoration: InputDecoration(
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(7.0),
            ),
            labelText: 'Serial Number',
            hasFloatingPlaceholder: true),
        onSaved: (val) {
          serialNumber = val;
        },
      ),
    );
  }

  Widget accountIdTextField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.87,
      child: TextFormField(
        decoration: InputDecoration(
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(7.0),
            ),
            labelText: 'Account Id',
            hasFloatingPlaceholder: true),
        onSaved: (val) {
          accountId = val;
        },
      ),
    );
  }

  void _setModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              scanOutputTextField(),
              SizedBox(
                height: 7.0,
              ),
              // serialNumberTextField(),
              SizedBox(
                height: 7.0,
              ),
              accountIdTextField(),
              SizedBox(
                height: 7.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              submitButton(),
            ],
          ),
        );
      },
    );
  }

  void _setAdhocModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: CircleAvatar(
            radius: 100.0,
            child: InkWell(
              onTap: () {
                serviceToilet('adhoc');
              },
              child: Text(
                'SCAN',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.87,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
          'SUBMIT',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        padding: EdgeInsets.all(13.0),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8.0)),
        onPressed: () async {
          serviceToilet('requestqrcode');
          // Response response = await ToiletServicingService.serviceToilet(
          //     new ToiletServicingModel(barcode, prefs.getInt('id')));
          // print(json.decode(response.body));
          // // showtoast('QrCode Request Successful');
          // // Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget scanButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.87,
      child: RaisedButton(
        color: Colors.cyan,
        child: Text(
          'SCAN',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        padding: EdgeInsets.all(13.0),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8.0)),
        onPressed: () {
          showtoast('QrCode Request Successful');
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget homeCard(String title) {
    return InkWell(
      child: Card(
        color: Theme.of(context).primaryColor,
        // elevation: 15.0,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: CircleAvatar(
                  radius: 27.0,
                  backgroundColor: Colors.white,
                  child: Text(
                    '3',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(title),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        switch (title) {
          case 'Serviced Toilets':
            Navigator.pushNamed(context, '/lead');
            break;
          case 'Failed Servicing':
            Navigator.pushNamed(context, '/task');
            break;
          case 'Scheduled Servicing':
            Navigator.pushNamed(context, '/archive');
            break;
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
      timeInSecForIos: 50,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );
  }

  buildListview(ToiletServicingsModel model) {
    List<Widget> allWidgets = new List<Widget>();
    for (int i = 0; i < model.interruptionTypes.length; i++) {
      var widget = InkWell(
        onTap: () async {
          setState(() {
            isloading = true;
          });
          Navigator.of(context).pop();
          ServiceInterruption si = new ServiceInterruption(
              1, prefs.getInt('id'), model.interruptionTypes[i]['id']);
          ToiletServicingService.reportServiceInterruption(si).then((res) {
            setState(() {
              isloading = false;
            });
            if (res.statusCode == 200) {
              if (jsonDecode(res.body)['status'] == 'error') {
                showerrortoast(jsonDecode(res.body)['message']);
              } else {
                showtoast(jsonDecode(res.body)['message']);
              }
            } else {
              showerrortoast('There was an error executing your request');
            }
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            child: Image.network(model.interruptionTypes[i]['imageurl']),
          ),
        ),
      );
      ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          child: Image.network(model.interruptionTypes[i]['imageurl']),
        ),
      );
      allWidgets.add(widget);
    }
    return allWidgets;
  }

  showInterruptionModal(ToiletServicingsModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Interruption Type',
            style: TextStyle(
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1.08,
              padding: EdgeInsets.all(16.0),
              children: buildListview(model),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: ToiletServicingsModel(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Service Toilet'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: isloading,
          child: ScopedModelDescendant<ToiletServicingsModel>(
            builder: (context, child, model) {
              model.getInterruptionTypes();
              return ModalProgressHUD(
                inAsyncCall: isloading,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 6,
                              child: ListView(
                                children: <Widget>[
                                  InkWell(
                                    child: Card(
                                      color: Theme.of(context).primaryColor,
                                      child: Container(
                                        padding: EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                flex: 1,
                                                child: Icon(Icons.open_in_new)),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                'Request QrCode',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        barcodeController.text = '';
                                      });

                                      _setModalBottomSheet(context);
                                    },
                                  ),
                                  InkWell(
                                    child: Card(
                                      color: Theme.of(context).primaryColor,
                                      child: Container(
                                        padding: EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                flex: 1,
                                                child: Icon(Icons.open_in_new)),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                'View Records',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ToiletServicingRecords(
                                                  id: prefs.getInt('id'),
                                                )),
                                      );
                                      // Navigator.pushNamed(
                                      //     context, '/toiletservicingrecords');
                                    },
                                  ),
                                  InkWell(
                                    child: Card(
                                      color: Theme.of(context).primaryColor,
                                      child: Container(
                                        padding: EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                flex: 1,
                                                child: Icon(Icons.open_in_new)),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                'Barrel Count',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/barrelcount');
                                    },
                                  ),
                                  InkWell(
                                    child: Card(
                                      color: Theme.of(context).primaryColor,
                                      child: Container(
                                        padding: EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                flex: 1,
                                                child: Icon(Icons.open_in_new)),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                'Adhoc Service',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      _setAdhocModalBottomSheet(context);
                                    },
                                  ),
                                  InkWell(
                                    child: Card(
                                      color: Theme.of(context).primaryColor,
                                      child: Container(
                                        padding: EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                flex: 1,
                                                child: Icon(Icons.open_in_new)),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                'Report Interruption',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      showInterruptionModal(model);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: CircleAvatar(
                                radius: 100.0,
                                child: InkWell(
                                  onTap: () {
                                    serviceToilet('regular');
                                  },
                                  child: Text(
                                    'SCAN',
                                    style: TextStyle(fontSize: 40.0),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
