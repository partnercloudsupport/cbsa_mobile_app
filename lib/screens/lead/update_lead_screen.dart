import 'dart:convert';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/scoped_model/initial_setup_model.dart';
import 'package:cbsa_mobile_app/scoped_model/lead_model.dart';
import 'package:cbsa_mobile_app/services/lead_service.dart';
import 'package:cbsa_mobile_app/services/update_lead_service.dart';
import 'package:cbsa_mobile_app/setup_models.dart/block.dart';
import 'package:cbsa_mobile_app/setup_models.dart/lead_type.dart';
import 'package:cbsa_mobile_app/setup_models.dart/service_provider.dart';
import 'package:cbsa_mobile_app/setup_models.dart/sub_territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/telephone_type.dart';
import 'package:cbsa_mobile_app/setup_models.dart/territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/toilet_type.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' show Response;

class UpdateLead extends StatefulWidget {
  final Lead lead;
  UpdateLead({Key key, @required this.lead}) : super(key: key);
  @override
  _UpdateLeadState createState() => _UpdateLeadState();
}

class _UpdateLeadState extends State<UpdateLead> {
  int _currentStep = 0;
  final _personalDetailsFormKey = GlobalKey<FormState>();
  final _toiletInformationFormKey = GlobalKey<FormState>();
  final _contactInformationFormKey = GlobalKey<FormState>();
  final _additionalInformationFormKey = GlobalKey<FormState>();
  final _statusFormKey = GlobalKey<FormState>();

  // Time
  String _startTime;
  String _endTime;

  // Location
  var location = new Location();
  LocationData currentLocation;
  double _latitude;
  double _longitude;

  // Personal Details
  String _firstName;
  TextEditingController _firstNameController = TextEditingController();
  String _lastName;
  TextEditingController _lastNameController = TextEditingController();
  String _otherNames;
  TextEditingController _otherNamesController = TextEditingController();
  Territory _territory;
  List<Territory> _territoryList = [];
  SubTerritory _subTerritory;
  List<SubTerritory> _allSubTerritories = [];
  List<SubTerritory> _subTerritoryList = [];
  Block _block;
  List<Block> _allBlocks = [];
  List<Block> _blockList = [];
  String _gender = 'Male';
  List<String> _genderList = ['Male', 'Female', 'Other'];
  String _disability = 'No';
  List<String> _disabilityList = ['Yes', 'No'];
  LeadType _leadType;
  List<LeadType> _leadTypeList = [];
  Map<String, bool> _infoSourceList = {};
  List<int> _infoSourceSelected = [];
  String _referred = 'No';
  String _referredBy;
  TextEditingController _referredByController = TextEditingController();

  // Toilet Information
  ToiletType _toiletType;
  List<ToiletType> _toiletTypeList = [];
  int _numberOfToilets;
  TextEditingController _numberOfToiletsController = TextEditingController();
  int _numberOfMaleAdults;
  TextEditingController _numberOfMaleAdultsController = TextEditingController();
  int _numberOfFemaleAdults;
  TextEditingController _numberOfFemaleAdultsController =
      TextEditingController();
  int _numberOfMaleChildren;
  TextEditingController _numberOfMaleChildrenController =
      TextEditingController();
  int _numberOfFemaleChildren;
  TextEditingController _numberOfFemaleChildrenController =
      TextEditingController();

  // Contact Information
  String _address;
  TextEditingController _addressController = TextEditingController();
  String _primaryPhoneNumber;
  TextEditingController _primaryNumberController = TextEditingController();
  String _secondaryPhoneNumber;
  TextEditingController _secondaryNumbercontroller = TextEditingController();

  // Additional Information
  Map<String, bool> _enrollmentReason = {
    'Personal': false,
    'Commercial': false
  };
  List<int> _reasonsSelected = [];
  Map<String, bool> _householdSavings = {
    'Bank': false,
    'Savings Club': false,
    'Mobile Money Account': false
  };
  List<String> _savingsSelected = [];
  
  ServiceProvider _serviceProvider;
  List<ServiceProvider> _serviceProviders = [];
  TelephoneType _telephoneType;
  List<TelephoneType> _telephoneTypes = [];
  List<String> _salary = ['Yes', 'No'];
  String _salariedWorker = 'Yes';
  String _paymentDate;
  TextEditingController _paymentDateController = TextEditingController();
  Map<String, bool> _paidServices = {
    'City Water': false,
    'Trucked Water': false,
    'Electricity': false
  };
  List<int> _servicesSelected = [];
  Map<String, bool> _privacyList = {
    'Public': false,
    'Private': false,
    'Neighbour': false,
    'None': false
  };
  List<int> _privacySelected = [];
  Map<String, bool> _typeList = {
    'Latrine': false,
    'Squat': false,
    'Flush': false,
    'Dry': false
  };
  List<int> _typeSelected = [];
  Map<String, bool> _securityList = {'Safe': false, 'Not Safe': false};
  List<int> _securitySelected = [];

  // Status
  List<String> _statusList = ['Open', 'Ready'];
  String _status = 'Open';
  TextEditingController _followUpDateController = TextEditingController();
  String _fUDate;
  TextEditingController _siteInspectionDateController = TextEditingController();
  String _sIDate;
  TextEditingController _toiletInstallationDateController = TextEditingController();
  String _tIDate;
  TextEditingController _commentController = TextEditingController();
  String _comment;

  bool _isLoading = false;
  Map _user;

  void initState() {
    super.initState();

    fetchUserObject();

    fetchTerritories();
    fetchSubTerritories();
    fetchBlocks();
    fetchLeadTypes();
    fetchToiletTypes();

    fetchTelephoneTypes();
    fetchServiceProviders();

    fetchAllInformationSources();
    fetchAllEnrollmentReasons();
    fetchAllPaidServices();
    fetchAllToiletPrivacy();
    fetchAllToiletTypesCA();
    fetchAllToiletSecurity();

    _firstNameController.text = widget.lead.firstName;
    _lastNameController.text = widget.lead.lastName;
    _otherNamesController.text = widget.lead.otherNames;
    _numberOfToiletsController.text = widget.lead.noOfToilets.toString();
    _numberOfMaleAdultsController.text = widget.lead.noOfMaleAdults.toString();
    _numberOfFemaleAdultsController.text = widget.lead.noOfFemaleAdults.toString();
    _numberOfMaleChildrenController.text = widget.lead.noOfMaleChildren.toString();
    _numberOfFemaleChildrenController.text = widget.lead.noOfFemaleChildren.toString();
    _addressController.text = widget.lead.address;
    _primaryNumberController.text = widget.lead.primaryTelephone;
    _secondaryNumbercontroller.text = widget.lead.secondaryTelephone;
    _paymentDateController.text = widget.lead.paymentDate;
    _commentController.text = widget.lead.comments;

    setState(() {
      _startTime = DateTime.now().toString();
      this._gender = widget.lead.gender;
    });
  }

  void fetchUserObject() async {
    var dbClient = DatabaseHelper();
    Map user = await dbClient.getUserObject();
    setState(() {
     this._user = user; 
    });
  }

  // DROPDOWNS

  void fetchTerritories() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllTerritories();
    List<Territory> territories = list.map((territory) {
      return Territory.map(territory);
    }).toList();
    
    Territory initT;
    for(Territory t in territories) {
      if(t.territoryId == widget.lead.territory) {
        initT = t;
      } 
    }

    setState(() {
     this._territoryList = territories;
     this._territory = initT;
    });
  }

  void fetchSubTerritories() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllSubTerritories();
    List<SubTerritory> subTerritories = list.map((subTerritory) {
      return SubTerritory.map(subTerritory);
    }).toList();

    List<SubTerritory> subT = [];
    for(int i = 0; i < subTerritories.length; i++) {
      if(subTerritories[i].territoryId == this._territory.territoryId) {
        subT.add(subTerritories[i]);
      }
    }

    SubTerritory initSubT;
    for(SubTerritory s in subTerritories) {
      if(s.subTerritoryId == widget.lead.subTerritory) {
        initSubT = s;
      } 
    }

    setState(() {
     this._allSubTerritories = subTerritories;
     this._subTerritoryList = subT;
     this._subTerritory = initSubT; 
    });
  }

  void fetchBlocks() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllBlocks();
    List<Block> blocks = list.map((block) {
      return Block.map(block);
    }).toList();

    List<Block> bloc = [];
    for(int i = 0; i < blocks.length; i++) {
      if(blocks[i].subTerritoryId == this._subTerritory.subTerritoryId) {
        bloc.add(blocks[i]);
      }
    }

    Block initB;
    for(Block b in blocks) {
      if(b.blockId == widget.lead.block) {
        initB = b;
      } 
    }

    setState(() {
     this._allBlocks = blocks;
     this._blockList = bloc;
     this._block = initB; 
    });
  }

  void fetchLeadTypes() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllLeadTypes();
    List<LeadType> leadTypes = list.map((leadType) {
      return LeadType.map(leadType);
    }).toList();

    LeadType initLead;
    for(LeadType l in leadTypes) {
      if(l.leadTypeId == widget.lead.leadType) {
        initLead = l;
      } 
    }

    setState(() {
     this._leadTypeList = leadTypes;
     this._leadType = initLead; 
    });
  }

  void fetchToiletTypes() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllToiletTypes();
    List<ToiletType> toiletTypes = list.map((toiletType) {
      return ToiletType.map(toiletType);
    }).toList();

    ToiletType initType;
    for(ToiletType tt in toiletTypes) {
      if(tt.toiletTypeId == widget.lead.toiletType) {
        initType = tt;
      } 
    }

    setState(() {
     this._toiletTypeList = toiletTypes;
     this._toiletType = initType; 
    });
  }

  void fetchServiceProviders() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllServiceProviders();
    List<ServiceProvider> serviceProviders = list.map((serviceProvider) {
      return ServiceProvider.map(serviceProvider);
    }).toList();

    ServiceProvider initPro;
    for(ServiceProvider sp in serviceProviders) {
      if(sp.serviceProviderId == widget.lead.serviceProvider) {
        initPro = sp;
      } 
    }

    setState(() {
     this._serviceProviders = serviceProviders;
     this._serviceProvider = initPro; 
    });
  }

  void fetchTelephoneTypes() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllTelephoneTypes();
    List<TelephoneType> telephoneTypes = list.map((telephoneType) {
      return TelephoneType.map(telephoneType);
    }).toList();

    TelephoneType initTele;
    for(TelephoneType tel in telephoneTypes) {
      if(tel.telephoneTypeId == widget.lead.telephoneType) {
        initTele = tel;
      } 
    }

    setState(() {
     this._telephoneTypes = telephoneTypes;
     this._telephoneType = initTele; 
    });
  }

  // MULTISELECT CHECKBOXES

  void fetchAllInformationSources() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllInformationSources();
    List<String> s = widget.lead.infoSourceSelected.split(',');
    List<int> i = s.map(int.parse).toList();

    Map<String, bool> infoSourceMap = new Map.fromIterable(
      list, 
      key: (value) => value['name'], 
      value: (value) {
        for(int id in i) {
          if(value['information_source_id'] == id) {
            return true;
          }
        }
        return false;
      }
    );
    
    setState(() {
      this._infoSourceList = infoSourceMap; 
    });
  }

  void fetchAllEnrollmentReasons() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllEnrollmentReasons();

    List<String> s = widget.lead.reasonsSelected.split(',');
    List<int> i = s.map(int.parse).toList();

    Map<String, bool> enrollmentReasonMap = new Map.fromIterable(
      list, 
      key: (value) => value['name'], 
      value: (value) {
        for(int id in i) {
          if(value['enrollment_reason_id'] == id) {
            return true;
          }
        }
        return false;
      }
    );

    setState(() {
      this._enrollmentReason = enrollmentReasonMap; 
    });
  }

  void fetchAllPaidServices() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllPaidServices();
    
    List<String> s = widget.lead.servicesSelected.split(',');
    List<int> i = s.map(int.parse).toList();

    Map<String, bool> paidServicesMap = new Map.fromIterable(
      list, 
      key: (value) => value['name'], 
      value: (value) {
        for(int id in i) {
          if(value['paid_service_id'] == id) {
            return true;
          }
        }
        return false;
      }
    );
    
    setState(() {
      this._paidServices = paidServicesMap; 
    });
  }

  void fetchAllToiletPrivacy() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllToiletPrivacy();
    
    List<String> s = widget.lead.privacySelected.split(',');
    List<int> i = s.map(int.parse).toList();

    Map<String, bool> toiletPrivacyMap = new Map.fromIterable(
      list, 
      key: (value) => value['name'], 
      value: (value) {
        for(int id in i) {
          if(value['toilet_privacy_id'] == id) {
            return true;
          }
        }
        return false;
      }
    );
    
    setState(() {
      this._privacyList = toiletPrivacyMap; 
    });
  }

  void fetchAllToiletTypesCA() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllToiletTypeCA();

    List<String> s = widget.lead.typeSelected.split(',');
    List<int> i = s.map(int.parse).toList();

    Map<String, bool> toiletTypeMap = new Map.fromIterable(
      list, 
      key: (value) => value['name'], 
      value: (value) {
        for(int id in i) {
          if(value['toilet_type_id'] == id) {
            return true;
          }
        }
        return false;
      }
    );
    
    setState(() {
      this._typeList = toiletTypeMap; 
    });
  }

  void fetchAllToiletSecurity() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllToiletSecurity();
    
    List<String> s = widget.lead.securitySelected.split(',');
    List<int> i = s.map(int.parse).toList();

    Map<String, bool> toiletSecurityMap = new Map.fromIterable(
      list, 
      key: (value) => value['name'], 
      value: (value) {
        for(int id in i) {
          if(value['toilet_security_id'] == id) {
            return true;
          }
        }
        return false;
      }
    );
    
    setState(() {
      this._securityList = toiletSecurityMap; 
    });
  }

  _getLocation() async {
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    print(currentLocation);
    setState(() {
      _latitude = currentLocation.latitude;
      _longitude = currentLocation.longitude;
    });
  }

  // Personal Details Widgets
  Widget _getFirstName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'First Name', hasFloatingPlaceholder: true),
      controller: _firstNameController,
      onFieldSubmitted: (value) {
        _firstNameController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'First Name is Required';
        }
      },
      onSaved: (value) {
        setState(() {
          this._firstName = value;
        });
      },
    );
  }

  Widget _getLastName() {
    return TextFormField(
      decoration:
          InputDecoration(labelText: 'Last Name', hasFloatingPlaceholder: true),
      controller: _lastNameController,
      onFieldSubmitted: (value) {
        _lastNameController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Last Name is Required';
        }
      },
      onSaved: (value) {
        setState(() {
          this._lastName = value;
        });
      },
    );
  }

  Widget _getOtherNames() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Other Names', hasFloatingPlaceholder: true),
      controller: _otherNamesController,
      onFieldSubmitted: (value) {
        _otherNamesController.text = value;
      },
      onSaved: (value) {
        setState(() {
          this._otherNames = value;
        });
      }
    );
  }

  Widget _getTerritory() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Territory'),
        DropdownButton<Territory>(
          hint: Text('Territory'),
          value: _territory,
          items: _territoryList.map((Territory territory) {
            return new DropdownMenuItem<Territory>(
              value: territory,
              child: Text(territory.name),
            );
          }).toList(),
          onChanged: (value) async {
            List<SubTerritory> subT = [];
            for(int i = 0; i < this._allSubTerritories.length; i++) {
              if(_allSubTerritories[i].territoryId == value.territoryId) {
                subT.add(_allSubTerritories[i]);
              }
            }
            List<Block> bloc = [];
            for(int i = 0; i < _allBlocks.length; i++) {
              if(_allBlocks[i].subTerritoryId == subT[0].subTerritoryId) {
                bloc.add(_allBlocks[i]);
              }
            }
            
            setState(() {
              this._territory = value;
              this._subTerritoryList = subT;
              this._subTerritory = null;
              this._blockList = bloc;
              this._block = null;
            });
          },
        )
      ],
    );
  }

  Widget _getSubTerritory() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Sub-Territory'),
        _subTerritoryList.isNotEmpty
        ? DropdownButton<SubTerritory>(
          hint: Text('Sub-Territory'),
          value: _subTerritory,
          items: this._subTerritoryList.map((SubTerritory subTerritory) {
            return DropdownMenuItem<SubTerritory>(
              value: subTerritory,
              child: Text(subTerritory.name),
            );
          }).toList(),
          onChanged: (value) {
            List<Block> bloc = [];
            for(int i = 0; i < _allBlocks.length; i++) {
              if(_allBlocks[i].subTerritoryId == value.subTerritoryId) {
                bloc.add(_allBlocks[i]);
              }
            }

            setState(() {
              this._subTerritory = value;
              this._blockList = bloc;
              this._block = null;
            });
          },
        )
        : Text('None', style: TextStyle(fontSize: 18),),
      ],
    );
  }

  Widget _getBlock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Block'),
        _blockList.isNotEmpty
        ? DropdownButton<Block>(
          hint: Text('Block'),
          value: _block,
          items: _blockList.map((block) {
            return DropdownMenuItem<Block>(
              value: block,
              child: Text(block.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              this._block = value;
            });
          },
        )
        : Text('None', style: TextStyle(fontSize: 18),)
      ],
    );
  }

  Widget _getGender() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Gender'),
        DropdownButton<String>(
          value: _gender,
          items: _genderList.map((gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              this._gender = value;
            });
          },
        )
      ],
    );
  }

  Widget _getDisability() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Disabled?'),
        DropdownButton<String>(
          value: _disability,
          items: _disabilityList.map((disability) {
            return DropdownMenuItem<String>(
              value: disability,
              child: Text(disability),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              this._disability = value;
            });
          },
        )
      ],
    );
  }

  Widget _getLeadType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Lead Type'),
        DropdownButton<LeadType>(
          value: _leadType,
          items: _leadTypeList.map((leadType) {
            return DropdownMenuItem<LeadType>(
              value: leadType,
              child: Text(leadType.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              this._leadType = value;
            });
          },
        )
      ],
    );
  }

  Widget _getSourceOfInformation(InitialSetupModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Source of Information'),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: _infoSourceList.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: _infoSourceList[key],
                onChanged: (bool value) async {
                  setState(() {
                    _infoSourceList[key] = value;
                  });
                  if(value) {
                    int id = await model.getInformationSourceId(key);
                    _infoSourceSelected.add(id);
                  } else {
                    _infoSourceSelected.removeLast();
                  }
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget referredBy() {
    var referredList = ['Yes', 'No'];
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20), 
              child: Text('Referred?')
            ),
            DropdownButton<String>(
              value: _referred,
              items: referredList.map((val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              }).toList(),
              onChanged: (String val) {
                setState(() {
                  _referred = val;
                });
              },
            )
          ],
        ),
        Container(
          child: _referred == 'Yes'
              ? TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Name of Referee',
                      hasFloatingPlaceholder: true),
                  controller: _referredByController,
                  onFieldSubmitted: (value) {
                    _referredByController.text = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Name of Referee is Required';
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      this._referredBy = value;
                    });
                  },
                )
              : null,
        )
      ],
    );
  }

  // Toilet Information Widgets
  Widget _getToiletType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Toilet Type'),
        DropdownButton<ToiletType>(
          value: _toiletType,
          items: _toiletTypeList.map((toiletType) {
            return DropdownMenuItem<ToiletType>(
              value: toiletType,
              child: Text(toiletType.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              this._toiletType = value;
            });
          },
        )
      ],
    );
  }

  Widget _getNumberOfToilets() {
    return TextFormField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          labelText: 'Number of Toilets', hasFloatingPlaceholder: true),
      keyboardType: TextInputType.number,
      controller: _numberOfToiletsController,
      onFieldSubmitted: (value) {
        _numberOfToiletsController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Number of Toilets is Required';
        }
      },
      onSaved: (value) {
        setState(() {
          _numberOfToilets = int.parse(value);
        });
      },
    );
  }

  Widget _getNumberOfMaleAdults() {
    return TextFormField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          labelText: 'Number of Male Adults', hasFloatingPlaceholder: true),
      keyboardType: TextInputType.number,
      controller: _numberOfMaleAdultsController,
      onFieldSubmitted: (value) {
        _numberOfMaleAdultsController.text = value;
      },
      onSaved: (value) {
        setState(() {
          _numberOfMaleAdults = value.isEmpty ? 0 : int.parse(value);
        });
      },
    );
  }

  Widget _getNumberOfFemaleAdults() {
    return TextFormField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          labelText: 'Number of Female Adults', hasFloatingPlaceholder: true),
      keyboardType: TextInputType.number,
      controller: _numberOfFemaleAdultsController,
      onFieldSubmitted: (value) {
        _numberOfFemaleAdultsController.text = value;
      },
      onSaved: (value) {
        setState(() {
          _numberOfFemaleAdults = value.isEmpty ? 0 : int.parse(value);
        });
      },
    );
  }

  Widget _getNumberOfMaleChildren() {
    return TextFormField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          labelText: 'Number of Male Children', hasFloatingPlaceholder: true),
      keyboardType: TextInputType.number,
      controller: _numberOfMaleChildrenController,
      onFieldSubmitted: (value) {
        _numberOfMaleChildrenController.text = value;
      },
      onSaved: (value) {
        setState(() {
          _numberOfMaleChildren = value.isEmpty ? 0 : int.parse(value);
        });
      },
    );
  }

  Widget _getNumberOfFemaleChildren() {
    return TextFormField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          labelText: 'Number of Female Children', hasFloatingPlaceholder: true),
      keyboardType: TextInputType.number,
      controller: _numberOfFemaleChildrenController,
      onFieldSubmitted: (value) {
        _numberOfFemaleChildrenController.text = value;
      },
      onSaved: (value) {
        setState(() {
          _numberOfFemaleChildren = value.isEmpty ? 0 : int.parse(value);
        });
      },
    );
  }

  // Contact Information Widgets
  Widget _getAddress() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Address / House Number', hasFloatingPlaceholder: true),
      controller: _addressController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Address is Required';
        }
      },
      onFieldSubmitted: (value) {
        _addressController.text = value;
      },
      onSaved: (value) {
        setState(() {
          this._address = value;
        });
      },
    );
  }

  Widget _getPrimaryPhoneNumber() {
    return TextFormField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          labelText: 'Primary Phone Number', hasFloatingPlaceholder: true),
      keyboardType: TextInputType.phone,
      controller: _primaryNumberController,
      onFieldSubmitted: (value) {
        _primaryNumberController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Primary Telephone is Required';
        }
      },
      onSaved: (value) {
        setState(() {
          _primaryPhoneNumber = value;
        });
      },
    );
  }

  Widget _getSecondaryPhoneNumber() {
    return TextFormField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          labelText: 'Secondary Phone Number', hasFloatingPlaceholder: true),
      keyboardType: TextInputType.phone,
      controller: _secondaryNumbercontroller,
      onFieldSubmitted: (value) {
        _secondaryNumbercontroller.text = value;
      },
      onSaved: (value) {
        setState(() {
          _secondaryPhoneNumber = value;
        });
      },
    );
  }

  // Additional Information Widgets
  Widget _getEnrollmentReason(InitialSetupModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Reason for Enrollment'),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: _enrollmentReason.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: _enrollmentReason[key],
                onChanged: (value) async {
                  setState(() {
                    _enrollmentReason[key] = value;
                  });
                  if(value) {
                    int id = await model.getEnrollmentReasonId(key);
                    _reasonsSelected.add(id);
                  } else {
                    _reasonsSelected.removeLast();
                  }
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _getServiceProvider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Service Provider'),
        DropdownButton<ServiceProvider>(
          value: _serviceProvider,
          items: _serviceProviders.map((serviceProvider) {
            return DropdownMenuItem<ServiceProvider>(
              value: serviceProvider,
              child: Text(serviceProvider.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              this._serviceProvider = value;
            });
          },
        )
      ],
    );
  }

  Widget _getTelephoneType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Telephone Type'),
        DropdownButton<TelephoneType>(
          value: _telephoneType,
          items: _telephoneTypes.map((telephoneType) {
            return DropdownMenuItem<TelephoneType>(
              value: telephoneType,
              child: Text(telephoneType.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              this._telephoneType = value;
            });
          },
        )
      ],
    );
  }

  Widget _getSalariedWorker() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Salaried Worker?'),
            DropdownButton<String>(
              value: _salariedWorker,
              items: _salary.map((salary) {
                return DropdownMenuItem<String>(
                  value: salary,
                  child: Text(salary),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  this._salariedWorker = value;
                });
              },
            )
          ],
        ),
        Container(
          child: (_salariedWorker == 'Yes'
              ? TextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      labelText: 'Payment Date', hasFloatingPlaceholder: true),
                  controller: _paymentDateController,
                  onFieldSubmitted: (value) {
                    _paymentDateController.text = value;
                  },
                  onSaved: (value) {
                    setState(() {
                      this._paymentDate = value;
                    });
                  },
                )
              : null),
        )
      ],
    );
  }

  Widget _getOtherPaidServices(InitialSetupModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Other Paid Services'),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: _paidServices.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: _paidServices[key],
                onChanged: (bool value) async {
                  setState(() {
                    _paidServices[key] = value;
                  });
                  if(value) {
                    int id = await model.getPaidServiceId(key);
                    _servicesSelected.add(id);
                  } else {
                    _servicesSelected.removeLast();
                  }
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _getPrivacy(InitialSetupModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Privacy'),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: _privacyList.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: _privacyList[key],
                onChanged: (bool value) async {
                  setState(() {
                    _privacyList[key] = value;
                  });
                  if(value) {
                    int id = await model.getToiletPrivacyId(key);
                    _privacySelected.add(id);
                  } else {
                    _privacySelected.removeLast();
                  }
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _getType(InitialSetupModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Type'),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: _typeList.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: _typeList[key],
                onChanged: (bool value) async {
                  setState(() {
                    _typeList[key] = value;
                  });
                  if(value) {
                    int id = await model.getToiletTypeIdCA(key);
                    _typeSelected.add(id);
                  } else {
                    _typeSelected.removeLast();
                  }
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _getSecurity(InitialSetupModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Security'),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: _securityList.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: _securityList[key],
                onChanged: (bool value) async {
                  setState(() {
                    _securityList[key] = value;
                  });
                  if(value) {
                    int id = await model.getToiletSecurityId(key);
                    _securitySelected.add(id);
                  } else {
                    _securitySelected.removeLast();
                  }
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  // Status Widgets
  Widget _getStatus() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(right: 20), child: Text('Status')),
            DropdownButton<String>(
              value: _status,
              items: _statusList.map((val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              }).toList(),
              onChanged: (String val) {
                setState(() {
                  if (val == 'Open') {
                    _siteInspectionDateController.text = '';
                    _toiletInstallationDateController.text = '';
                  } else {
                    _followUpDateController.text = '';
                  }
                  _status = val;
                });
              },
            )
          ],
        ),
        Container(
          child: (_status == 'Open'
              ? Divider()
              : Column(
                  children: <Widget>[
                    Divider(),
                    GestureDetector(
                      onTap: () async {
                        DateTime datePicked = await showDatePicker(
                            context: context,
                            firstDate: new DateTime.now(),
                            initialDate: new DateTime.now(),
                            lastDate: new DateTime(2030));
                        setState(() {
                          _siteInspectionDateController.text =
                              DateFormat.yMMMd().format(datePicked);
                          _sIDate = datePicked.toString();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                        child: AbsorbPointer(
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: 'Site Inspection Date',
                              hasFloatingPlaceholder: true,
                            ),
                            controller: _siteInspectionDateController,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        DateTime datePicked = await showDatePicker(
                            context: context,
                            firstDate: new DateTime.now(),
                            initialDate: new DateTime.now(),
                            lastDate: new DateTime(2030));
                        setState(() {
                          _toiletInstallationDateController.text =
                              DateFormat.yMMMd().format(datePicked);
                          _tIDate = datePicked.toString();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                        child: AbsorbPointer(
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: 'Toilet Installation Date',
                              hasFloatingPlaceholder: true,
                            ),
                            controller: _toiletInstallationDateController,
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Toilet Installation Date is Required';
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                )),
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
          _comment = value;
        });
      },
    );
  }

  // Steps
  List<Step> _steps(InitialSetupModel model) {
    List<Step> steps = [
      Step(
          title: Text('Personal Details'),
          content: Form(
            key: _personalDetailsFormKey,
            child: Column(
              children: <Widget>[
                _getFirstName(),
                Divider(),
                _getLastName(),
                Divider(),
                _getOtherNames(),
                Divider(),
                _getTerritory(),
                Divider(),
                _getSubTerritory(),
                Divider(),
                _getBlock(),
                Divider(),
                _getGender(),
                Divider(),
                _getDisability(),
                Divider(),
                _getLeadType(),
                Divider(),
                _getSourceOfInformation(model),
                Divider(),
              ],
            ),
          ),
          isActive: _currentStep >= 0),
      Step(
          title: Text('Toilet Information'),
          content: Form(
            key: _toiletInformationFormKey,
            child: Column(
              children: <Widget>[
                _getToiletType(),
                Divider(),
                _getNumberOfToilets(),
                Divider(),
                _getNumberOfMaleAdults(),
                Divider(),
                _getNumberOfFemaleAdults(),
                Divider(),
                _getNumberOfMaleChildren(),
                Divider(),
                _getNumberOfFemaleChildren(),
                Divider(),
              ],
            ),
          ),
          isActive: _currentStep >= 1),
      Step(
          title: Text('Contact Information'),
          content: Form(
            key: _contactInformationFormKey,
            child: Column(
              children: <Widget>[
                _getAddress(),
                Divider(),
                _getPrimaryPhoneNumber(),
                Divider(),
                _getSecondaryPhoneNumber(),
                Divider(),
              ],
            ),
          ),
          isActive: _currentStep >= 2),
      Step(
          title: Text('Additional Information'),
          content: Form(
            key: _additionalInformationFormKey,
            child: Column(
              children: <Widget>[
                _getEnrollmentReason(model),
                Divider(),
                _getServiceProvider(),
                Divider(),
                _getTelephoneType(),
                Divider(),
                _getSalariedWorker(),
                Divider(),
                _getOtherPaidServices(model),
                Divider(),
                Column(
                  children: <Widget>[
                    Text('Current Access To Toilet'),
                    Divider(),
                    _getPrivacy(model),
                    Divider(),
                    _getType(model),
                    Divider(),
                    _getSecurity(model),
                    Divider(),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
          isActive: _currentStep >= 3),
      Step(
          title: Text('Status'),
          content: Form(
            key: _statusFormKey,
            child: Column(
              children: <Widget>[
                _getStatus(),
                _getComment(),
                Divider(),
              ],
            ),
          ),
          isActive: _currentStep >= 4),
    ];
    return steps;
  }

  void _updateLead(LeadModel leadModel, int userId) async {
    try {
      setState(() {
        _endTime = DateTime.now().toString();
        _isLoading = true;
      });
      Fluttertoast.showToast(
        msg: 'Updating Lead...',
        toastLength: Toast.LENGTH_LONG
      );
      print(this._sIDate);
      Lead lead = new Lead(
        _firstName,
        _lastName,
        _otherNames,
        '', // uuid
        _territory.territoryId,
        _subTerritory.subTerritoryId,
        _block.blockId,
        _gender,
        _primaryPhoneNumber,
        _secondaryPhoneNumber,
        _referredBy,
        _toiletType.toiletTypeId,
        _numberOfToilets,
        _numberOfMaleAdults,
        _numberOfFemaleAdults,
        _numberOfMaleChildren,
        _numberOfFemaleChildren,
        _latitude,
        _longitude,
        _infoSourceSelected.join(','),
        _leadType.leadTypeId,
        _disability,
        _reasonsSelected.join(','),
        _status,
        _fUDate,
        _sIDate,
        _tIDate,
        _comment,
        _user['user_id'],
        _serviceProvider.serviceProviderId, // _serviceProvider,
        _telephoneType.telephoneTypeId,
        _salariedWorker,
        _paymentDate,
        _servicesSelected.join(','),
        '',// _typeSelected,
        _securitySelected.join(','),
        _privacySelected.join(','),
        '',
        1,
        _address,
        1,
        null,
        null,
        _endTime,
        null,
      );

      Response response = await UpdateLeadService.updateLead(lead, widget.lead.id);
      var decodedJson = jsonDecode(response.body);
      var status = decodedJson['status'];

      print(response.statusCode);
      print(response.body);

      if(status == 200) {                      
        int saveLead = await leadModel.updateLead(Lead.map(decodedJson['lead']));
        setState(() {
          _isLoading = false; 
        });
        if(saveLead > 0) {
          Fluttertoast.showToast(
            msg: 'Lead Updated Successfully',
            toastLength: Toast.LENGTH_SHORT,
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Could Not Update Lead',
          toastLength: Toast.LENGTH_SHORT,
        );
        setState(() {
          _isLoading = false; 
        });
      }
    } catch (e) {
      currentLocation = null;
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
              title: Text('Update Lead'),
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
                      initialSetupModel.fetchAllTerritories();
                      initialSetupModel.fetchAllSubTerritories();
                      initialSetupModel.fetchAllBlocks();
                      initialSetupModel.fetchAllLeadTypes();
                      initialSetupModel.fetchAllToiletTypes();
                      initialSetupModel.fetchAllTelephoneTypes();
                      
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
                            if (_personalDetailsFormKey.currentState.validate()) {
                              setState(() {
                                this._currentStep = this._currentStep + 1;
                              });
                            }
                          } else if (this._currentStep <= 1) {
                            if (_toiletInformationFormKey.currentState.validate()) {
                              setState(() {
                                this._currentStep = this._currentStep + 1;
                              });
                            }
                          } else if (this._currentStep <= 2) {
                            if (_contactInformationFormKey.currentState.validate()) {
                              setState(() {
                                this._currentStep = this._currentStep + 1;
                              });
                            }
                          } else if (this._currentStep <= 3) {
                            
                            setState(() {
                              this._currentStep = this._currentStep + 1;
                            });
                          } else {
                            if (_statusFormKey.currentState.validate()) {
                              _personalDetailsFormKey.currentState.save();
                              _toiletInformationFormKey.currentState.save();
                              _contactInformationFormKey.currentState.save();
                              _additionalInformationFormKey.currentState.save();
                              _statusFormKey.currentState.save();

                              // _leadData(leadModel);
                              _updateLead(leadModel, initialSetupModel.userObject['user_id']);
                            }
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
