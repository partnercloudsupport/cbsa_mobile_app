import 'dart:convert';
import 'dart:io';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/app_translations.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/lead_conversion.dart';
import 'package:cbsa_mobile_app/scoped_model/initial_setup_model.dart';
import 'package:cbsa_mobile_app/scoped_model/lead_model.dart';
import 'package:cbsa_mobile_app/services/lead_conversion_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';

class NewLeadConversion extends StatefulWidget {
  final Lead lead;
  NewLeadConversion({Key key, this.lead}) : super(key: key);

  @override
  _NewLeadConversionState createState() => _NewLeadConversionState();
}

class _NewLeadConversionState extends State<NewLeadConversion> {
  int _currentStep = 0;
  final _additionalInformationFormKey = GlobalKey<FormState>();
  final _locationInformationFormKey = GlobalKey<FormState>();
  final _paymentInformationFormKey = GlobalKey<FormState>();
  final _documentFormKey = GlobalKey<FormState>();

  // Time
  String _endTime;

  // Additional Information
  Map<String, bool> _householdSavings = {
    'Bank': false,
    'Savings Club': false,
    'Mobile Money Account': false
  };
  List<String> _savingsSelected = [];

  List<String> _primaryOccupations = [
    'None',
    'Business',
    'Skilled Labour',
    'Salaried Worker',
    'Other'
  ];
  String _primaryOccupation = 'None';
  TextEditingController _primaryOccupationController = TextEditingController();
  String _pOccupation;

  List<String> _secondaryOccupations = [
    'None',
    'Business',
    'Skilled Labour',
    'Salaried Worker',
    'Other'
  ];
  String _secondaryOccupation = 'None';
  TextEditingController _secondaryOccupationController =
      TextEditingController();
  String _sOccupation;

  List<String> _homeOwnerships = ['Own', 'Rent'];
  String _homeOwnership = 'Own';

  // Location Information
  File _customerImage;
  File _houseHoldImage;
  File _landmarkImage;

  // Payment Information
  String _mobileMoneyCode;
  TextEditingController _mobileMoneyCodeController = TextEditingController();
  List<String> _isPayer = ['Yes', 'No'];
  String _payer = 'Yes';
  String _payerFirstName;
  TextEditingController _payerFirstNameController = TextEditingController();
  String _payerLastName;
  TextEditingController _payerLastNameController = TextEditingController();
  String _relationship;
  TextEditingController _relationshipController = TextEditingController();
  String _payerPrimaryPhoneNumber;
  TextEditingController _payerPrimaryPhoneNumberController =
      TextEditingController();
  String _payerSecondaryPhoneNumber;
  TextEditingController _payerSecondaryPhoneNumberController =
      TextEditingController();
  String _payerOccupation;
  TextEditingController _payerOccupationController = TextEditingController();
  Map<String, bool> _paymentMethods = {'Mobile Money': false, 'Cash': false};
  List<String> _paymentMethodSelected = [];

  Base64Codec base64 = Base64Codec();

  // Document Upload
  List<String> _documentPath = [];

  bool _isLoading = false;

  Widget _getHouseholdSavings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(AppTranslations.of(context).text("householdSavings")),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: _householdSavings.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: _householdSavings[key],
                onChanged: (bool value) {
                  setState(() {
                    _householdSavings[key] = value;
                  });
                  if(value) {
                    _savingsSelected.add(key);
                  } else {
                    _savingsSelected.removeLast();
                  }
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _getPrimaryOccupation() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(AppTranslations.of(context).text("primaryOccupation")),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: FractionalOffset.centerRight,
                child: DropdownButton<String>(
                  value: _primaryOccupation,
                  items: _primaryOccupations.map((primaryOccupation) {
                    return DropdownMenuItem<String>(
                      value: primaryOccupation,
                      child: Text(primaryOccupation),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      this._primaryOccupation = value;
                      this._pOccupation = value;
                    });
                  },
                ),
              ),
            )
          ],
        ),
        this._primaryOccupation == 'Other'
            ? TextFormField(
                decoration: InputDecoration(
                    labelText: AppTranslations.of(context).text("primaryOccupation"),
                    hasFloatingPlaceholder: true),
                controller: _primaryOccupationController,
                onFieldSubmitted: (value) {
                  _primaryOccupationController.text = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return AppTranslations.of(context).text("required");
                  }
                },
                onSaved: (value) {
                  setState(() {
                    this._pOccupation = value;
                  });
                },
              )
            : Divider(),
      ],
    );
  }

  Widget _getSecondaryOccupation() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(AppTranslations.of(context).text("secondaryOccupation")),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: FractionalOffset.centerRight,
                child: DropdownButton<String>(
                  value: _secondaryOccupation,
                  items: _secondaryOccupations.map((secondaryOccupation) {
                    return DropdownMenuItem<String>(
                      value: secondaryOccupation,
                      child: Text(secondaryOccupation),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      this._secondaryOccupation = value;
                      this._sOccupation = value;
                    });
                  },
                ),
              )
            )
          ],
        ),
        this._secondaryOccupation == 'Other'
        ? TextFormField(
            decoration: InputDecoration(
              labelText: AppTranslations.of(context).text("secondaryOccupation"),
              hasFloatingPlaceholder: true),
            controller: _secondaryOccupationController,
            onFieldSubmitted: (value) {
              _secondaryOccupationController.text = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return AppTranslations.of(context).text("required");
              }
            },
            onSaved: (value) {
              setState(() {
                this._sOccupation = value;
              });
            },
          )
        : Divider(),
      ],
    );
  }

  Widget _getHomeOwnership() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text(AppTranslations.of(context).text("homeOwnership")),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: FractionalOffset.centerRight,
            child: DropdownButton<String>(
              value: _homeOwnership,
              items: _homeOwnerships.map((homeOwnership) {
                return DropdownMenuItem<String>(
                  value: homeOwnership,
                  child: Text(homeOwnership),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  this._homeOwnership = value;
                });
              },
            ),
          )
        )
      ],
    );
  }

  // Location Information Widgets
  Widget _getCustomerImage() {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(AppTranslations.of(context).text("customerImage")),
            ),
            RaisedButton(
              child: Row(
                children: <Widget>[
                  Text('Take Photo  '),
                  Icon(Icons.camera_alt)
                ],
              ),
              onPressed: () async {
                var image =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                print(image);
                setState(() {
                  _customerImage = image;
                });
              },
            ),
            FlatButton(
              child: Row(
                children: <Widget>[Text('Gallery  '), Icon(Icons.collections)],
              ),
              onPressed: () async {
                var image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _customerImage = image;
                });
              },
            )
          ],
        ),
        Container(
          height: 150,
          width: 120,
          child: _customerImage == null
              ? Image.asset('assets/profile-placeholder.png')
              : Image.file(_customerImage),
        )
      ],
    ));
  }

  Widget _getHouseholdImage() {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(AppTranslations.of(context).text("householdImage")),
            ),
            RaisedButton(
              child: Row(
                children: <Widget>[
                  Text('Take Photo  '),
                  Icon(Icons.camera_alt)
                ],
              ),
              onPressed: () async {
                var image =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                setState(() {
                  _houseHoldImage = image;
                });
              },
            ),
            FlatButton(
              child: Row(
                children: <Widget>[Text('Gallery  '), Icon(Icons.collections)],
              ),
              onPressed: () async {
                var image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _houseHoldImage = image;
                });
              },
            )
          ],
        ),
        Container(
          height: 150,
          width: 120,
          child: _houseHoldImage == null
              ? Image.asset('assets/house-placeholder.jpg')
              : Image.file(_houseHoldImage),
        )
      ],
    ));
  }

  Widget _getLandMarkImage() {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(AppTranslations.of(context).text("landmarkImage")),
            ),
            RaisedButton(
              child: Row(
                children: <Widget>[
                  Text('Take Photo  '),
                  Icon(Icons.camera_alt)
                ],
              ),
              onPressed: () async {
                var image =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                setState(() {
                  _landmarkImage = image;
                });
              },
            ),
            FlatButton(
              child: Row(
                children: <Widget>[Text('Gallery  '), Icon(Icons.collections)],
              ),
              onPressed: () async {
                var image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _landmarkImage = image;
                });
              },
            )
          ],
        ),
        Container(
          height: 150,
          width: 120,
          child: _landmarkImage == null
              ? Image.asset('assets/landmark-placeholder.png')
              : Image.file(_landmarkImage),
        )
      ],
    ));
  }

  // Payment Information Widgets
  Widget _getMobileMoneyCode() {
    return (TextFormField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          labelText: AppTranslations.of(context).text("mobileMoneyCode"), hasFloatingPlaceholder: true),
      keyboardType: TextInputType.number,
      controller: _mobileMoneyCodeController,
      onFieldSubmitted: (value) {
        _mobileMoneyCodeController.text = value;
      },
      onSaved: (value) {
        setState(() {
          _mobileMoneyCode = value;
        });
      },
    ));
  }

  Widget _getPayer() {
    return (Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(AppTranslations.of(context).text("customerSameAsPayer")),
            DropdownButton<String>(
              value: _payer,
              items: _isPayer.map((payer) {
                return DropdownMenuItem<String>(
                  value: payer,
                  child: Text(payer),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  this._payer = value;
                });
              },
            )
          ],
        ),
        _payer == 'No'
            ? Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: AppTranslations.of(context).text("payerFirstName"),
                        hasFloatingPlaceholder: true),
                    controller: _payerFirstNameController,
                    onFieldSubmitted: (value) {
                      _payerFirstNameController.text = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppTranslations.of(context).text("required");
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        this._payerFirstName = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: AppTranslations.of(context).text("payerLastName"),
                        hasFloatingPlaceholder: true),
                    controller: _payerLastNameController,
                    onFieldSubmitted: (value) {
                      _payerLastNameController.text = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppTranslations.of(context).text("required");
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        this._payerLastName = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: AppTranslations.of(context).text("payerRelationship"),
                        hasFloatingPlaceholder: true),
                    controller: _relationshipController,
                    onFieldSubmitted: (value) {
                      _relationshipController.text = value;
                    },
                    onSaved: (value) {
                      setState(() {
                        this._relationship = value;
                      });
                    },
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: AppTranslations.of(context).text("payerPrimaryTelephone"),
                        hasFloatingPlaceholder: true),
                    keyboardType: TextInputType.number,
                    controller: _payerPrimaryPhoneNumberController,
                    onFieldSubmitted: (value) {
                      _payerPrimaryPhoneNumberController.text = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppTranslations.of(context).text("required");
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        _payerPrimaryPhoneNumber = value;
                      });
                    },
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: AppTranslations.of(context).text("payerSecondaryTelephone"),
                        hasFloatingPlaceholder: true),
                    keyboardType: TextInputType.number,
                    controller: _payerSecondaryPhoneNumberController,
                    onFieldSubmitted: (value) {
                      _payerSecondaryPhoneNumberController.text = value;
                    },
                    onSaved: (value) {
                      setState(() {
                        _payerSecondaryPhoneNumber = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: AppTranslations.of(context).text("payerOccupation"),
                        hasFloatingPlaceholder: true),
                    controller: _payerOccupationController,
                    onFieldSubmitted: (value) {
                      _payerOccupationController.text = value;
                    },
                    onSaved: (value) {
                      setState(() {
                        this._payerOccupation = value;
                      });
                    },
                  ),
                ],
              )
            : Divider()
      ],
    ));
  }

  Widget _getPaymentMethod() {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(AppTranslations.of(context).text("paymentMethod")),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: _paymentMethods.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: _paymentMethods[key],
                onChanged: (bool value) {
                  setState(() {
                    _paymentMethods[key] = value;
                  });
                  if(value) {
                    _paymentMethodSelected.add(key);
                  } else {
                    _paymentMethodSelected.removeLast();
                  }
                },
              );
            }).toList(),
          ),
        )
      ],
    ));
  }

  // Document Upload
  Widget _getDocument() {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _documentPath == null
            ? Text('No Document Selected')
            : Text(_documentPath.length.toString() + ' ' + AppTranslations.of(context).text("documentAdded")),
        RaisedButton(
          child: Icon(Icons.attachment),
          onPressed: () async {
            try {
              String filePath =
                  await FilePicker.getFilePath(type: FileType.ANY);
              if (filePath == null) return;
              setState(() {
                _documentPath.add(filePath);
              });
              print(_documentPath);
            } catch (e) {
              print(e.toString());
            }
          },
        )
      ],
    ));
  }

  // Steps
  List<Step> _steps(InitialSetupModel model) {
    List<Step> steps = [
      Step(
          title: Text(AppTranslations.of(context).text("additionalInformation")),
          content: Form(
            key: _additionalInformationFormKey,
            child: Column(
              children: <Widget>[
                _getHouseholdSavings(),
                Divider(),
                _getPrimaryOccupation(),
                Divider(),
                _getSecondaryOccupation(),
                Divider(),
                Divider(),
                _getHomeOwnership(),
                Divider(),
              ],
            ),
          ),
          isActive: _currentStep >= 3),
      Step(
          title: Text(AppTranslations.of(context).text("locationInformation")),
          content: Form(
            key: _locationInformationFormKey,
            child: Column(
              children: <Widget>[
                _getCustomerImage(),
                Divider(),
                _getHouseholdImage(),
                Divider(),
                _getLandMarkImage(),
                Divider(),
              ],
            ),
          ),
          isActive: _currentStep >= 5),
      Step(
          title: Text(AppTranslations.of(context).text("paymentInformation")),
          content: Form(
            key: _paymentInformationFormKey,
            child: Column(
              children: <Widget>[
                _getMobileMoneyCode(),
                Divider(),
                _getPayer(),
                Divider(),
                _getPaymentMethod(),
                Divider(),
              ],
            ),
          ),
          isActive: _currentStep >= 6),
      Step(
          title: Text(AppTranslations.of(context).text("documentUpload")),
          content: Form(
            key: _documentFormKey,
            child: Column(
              children: <Widget>[
                _getDocument(),
                Divider(),
              ],
            ),
          ),
          isActive: _currentStep >= 7),
    ];
    return steps;
  }

  void _convertLead(LeadModel model, int userId) async {
    try {
      setState(() {
        _endTime = DateTime.now().toString();
        _isLoading = true;
      });

      LeadConversion leadConversion = new LeadConversion(
        widget.lead.id, 
        _endTime, 
        _mobileMoneyCode, 
        _payerFirstName, 
        _payerLastName, 
        _relationship, 
        _payerPrimaryPhoneNumber, 
        _payerSecondaryPhoneNumber, 
        _payerOccupation, 
        _paymentMethodSelected.join(','), 
        userId, 
        _savingsSelected.join(','), 
        _pOccupation, 
        _sOccupation, 
        _homeOwnership, 
        base64Encode(_customerImage.readAsBytesSync()), 
        base64Encode(_landmarkImage.readAsBytesSync()), 
        base64Encode(_houseHoldImage.readAsBytesSync()), 
        null, 
        null, 
        null
      );

      var leadConversionResponse = await LeadConversionService.saveLeadConversion(leadConversion);
      var decodedJson = jsonDecode(leadConversionResponse.body);

      print(decodedJson);

      if(decodedJson['status'] == 200) {
        var db = DatabaseHelper();
        int saveLeadConversion = await db.saveLeadConversion(LeadConversion.map(decodedJson['leadconversion']));

        if (saveLeadConversion > 0) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        }
      } else {
        Fluttertoast.showToast(
          msg: AppTranslations.of(context).text("conversionError"),
          toastLength: Toast.LENGTH_SHORT
        );
      }
    } catch (e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: ScopedModel<LeadModel>(
        model: new LeadModel(),
        child: ScopedModel(
          model: InitialSetupModel(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppTranslations.of(context).text("leadConversion")),
            ),
            body: ModalProgressHUD(
              inAsyncCall: _isLoading,
              opacity: 0.5,
              progressIndicator: CircularProgressIndicator(),
              child: new ScopedModelDescendant<LeadModel>(
                builder: (context, child, leadModel) {
                  return ScopedModelDescendant<InitialSetupModel>(
                    builder: (context, child, initialSetupModel) {
                      initialSetupModel.fetchUserObject();

                      return Stepper(
                        steps: _steps(initialSetupModel),
                        currentStep: this._currentStep,
                        onStepTapped: (step) {
                          setState(() {
                            this._currentStep = step;
                          });
                        },
                        onStepContinue: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          if (this._currentStep <= 0) {
                            setState(() {
                              this._currentStep = this._currentStep + 1;
                            });
                          } else if (this._currentStep <= 1) {
                            setState(() {
                              this._currentStep = this._currentStep + 1;
                            });
                          } else if (this._currentStep <= 2) {
                            setState(() {
                              this._currentStep = this._currentStep + 1;
                            });
                          } else if (this._currentStep <= 3) {
                            _additionalInformationFormKey.currentState.save();
                            _locationInformationFormKey.currentState.save();
                            _paymentInformationFormKey.currentState.save();
                            _documentFormKey.currentState.save();
                            
                            _convertLead(leadModel, initialSetupModel.userObject['user_id']);
                          }
                        },
                        onStepCancel: () {
                          if (this._currentStep > 0) {
                            setState(() {
                              this._currentStep = this._currentStep - 1;
                            });
                          } else {
                            print('Can not go back any further');
                          }
                        },
                      );
                    },
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
