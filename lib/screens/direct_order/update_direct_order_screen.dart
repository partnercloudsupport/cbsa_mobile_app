import 'dart:convert';
import 'dart:io';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/app_translations.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/scoped_model/initial_setup_model.dart';
import 'package:cbsa_mobile_app/scoped_model/lead_model.dart';
import 'package:cbsa_mobile_app/setup_models.dart/block.dart';
import 'package:cbsa_mobile_app/setup_models.dart/lead_type.dart';
import 'package:cbsa_mobile_app/setup_models.dart/service_provider.dart';
import 'package:cbsa_mobile_app/setup_models.dart/sub_territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/telephone_type.dart';
import 'package:cbsa_mobile_app/setup_models.dart/territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/toilet_type.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';

class UpdateDirectRecord extends StatefulWidget {
  final Lead lead;
  UpdateDirectRecord({Key key, this.lead}) : super(key: key);
  @override
  _UpdateDirectRecordState createState() => _UpdateDirectRecordState();
}

class _UpdateDirectRecordState extends State<UpdateDirectRecord> {
  int _currentStep = 0;
  final _personalDetailsFormKey = GlobalKey<FormState>();
  final _toiletInformationFormKey = GlobalKey<FormState>();
  final _contactInformationFormKey = GlobalKey<FormState>();
  final _additionalInformationFormKey = GlobalKey<FormState>();
  final _statusFormKey = GlobalKey<FormState>();
  final _locationInformationFormKey = GlobalKey<FormState>();
  final _paymentInformationFormKey = GlobalKey<FormState>();
  final _documentFormKey = GlobalKey<FormState>();

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
  
  ServiceProvider _serviceProvider = ServiceProvider.empty();
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

  List<String> _primaryOccupations = ['None', 'Business', 'Skilled Labour', 'Salaried Worker'];
  String _primaryOccupation = 'None';
  List<String> _secondaryOccupations = ['None', 'Business', 'Skilled Labour', 'Salaried Worker'];
  String _secondaryOccupation = 'None';
  List<String> _homeOwnerships = ['Own', 'Rent'];
  String _homeOwnership = 'Own';

  // Status
  // List<String> _statusList = ['Open', 'Ready'];
  String _status = 'Ready';
  TextEditingController _followUpDateController = TextEditingController();
  String _fUDate;
  TextEditingController _siteInspectionDateController = TextEditingController();
  String _sIDate;
  TextEditingController _toiletInstallationDateController = TextEditingController();
  String _tIDate;
  TextEditingController _commentController = TextEditingController();
  String _comment;

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
  TextEditingController _payerPrimaryPhoneNumberController = TextEditingController();
  String _payerSecondaryPhoneNumber;
  TextEditingController _payerSecondaryPhoneNumberController = TextEditingController();
  String _payerOccupation;
  TextEditingController _payerOccupationController = TextEditingController();
  Map<String, bool> _paymentMethods = {'Mobile Money': false, 'Cash': false};
  List<String> _paymentMethodSelected = [];

  Base64Codec base64 = Base64Codec();

  // Document Upload
  List<String> _documentPath = [];

  bool _isLoading = false;
  Map _user;


  void initState() {
    super.initState();
    getLeadConversionObject();
    getOrderObject();

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
    fetchToiletTypesCA();
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

    print(widget.lead.servicesSelected);

    _infoSourceSelected = widget.lead.infoSourceSelected != null ? widget.lead.infoSourceSelected.split(',').toList().map((item) => int.parse(item)).toList() : [];
    _reasonsSelected = widget.lead.reasonsSelected != null ? widget.lead.reasonsSelected.split(',').toList().map((item) => int.parse(item)).toList() : [];
    _servicesSelected = widget.lead.servicesSelected != null ? widget.lead.servicesSelected.split(',').toList().map((item) => int.parse(item)).toList() : [];
    _typeSelected = widget.lead.typeSelected != null ? widget.lead.typeSelected.split(',').toList().map((item) => int.parse(item)).toList() : [];
    _securitySelected = widget.lead.securitySelected != null ? widget.lead.securitySelected.split(',').toList().map((item) => int.parse(item)).toList() : [];
    _privacySelected = widget.lead.privacySelected != null ? widget.lead.privacySelected.split(',').toList().map((item) => int.parse(item)).toList() : [];

    setState(() {
      _gender = widget.lead.gender;
    });
  }

  void fetchUserObject() async {
    var dbClient = DatabaseHelper();
    Map user = await dbClient.getUserObject();
    setState(() {
     this._user = user; 
    });
  }

  void getLeadConversionObject() async {
    var db = DatabaseHelper();
    var result = await db.getLeadConversion(widget.lead.id);

    if(result != null) {
      setState(() {
        this._primaryOccupation = result.primaryOccupation;
        this._secondaryOccupation = result.secondaryOccupation;
        // this._savingsSelected = result.householdSavings.split(',').toList().map(int.parse).toList();
      });
    } else {
      print(result);
    }
  }

  void getOrderObject() async {
    var db = DatabaseHelper();
    // var result = await db.getOrder(widget.lead.id);
    var result = await db.getAllOrders();
    var result1 = await db.getAllLeadConversions();
    var result2 = await db.getLeadConversion(widget.lead.id);

    // print(result);
    // print(result1.length);
    print(result2);
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
    Map<String, bool> infoSourceMap;
    
    if(widget.lead.infoSourceSelected != null) {
      List<String> s = widget.lead.infoSourceSelected.split(',');
      List<int> i = s.map(int.parse).toList();

      infoSourceMap = new Map.fromIterable(
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
    } else {
      infoSourceMap = new Map.fromIterable(
        list, 
        key: (value) => value['name'], 
        value: (value) =>  false
      );
    }

    setState(() {
      this._infoSourceList = infoSourceMap; 
    });
  }

  void fetchAllEnrollmentReasons() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllEnrollmentReasons();
    Map<String, bool> enrollmentReasonMap;

    if(widget.lead.reasonsSelected != null) {
      List<String> s = widget.lead.reasonsSelected.split(',');
      List<int> i = s.map(int.parse).toList();

      enrollmentReasonMap = new Map.fromIterable(
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
    } else {
      enrollmentReasonMap = new Map.fromIterable(
        list, 
        key: (value) => value['name'], 
        value: (value) => false
      );
    }

    setState(() {
      this._enrollmentReason = enrollmentReasonMap; 
    });
  }

  void fetchAllPaidServices() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllPaidServices();
    Map<String, bool> paidServicesMap;
    
    if(widget.lead.servicesSelected != null) {
      List<String> s = widget.lead.servicesSelected.split(',');
      List<int> i = s.map(int.parse).toList();

      paidServicesMap = new Map.fromIterable(
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
    } else {
      paidServicesMap = new Map.fromIterable(
        list, 
        key: (value) => value['name'], 
        value: (value) => false
      );
    }

    setState(() {
      this._paidServices = paidServicesMap; 
    });
  }

  void fetchAllToiletPrivacy() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllToiletPrivacy();
    Map<String, bool> toiletPrivacyMap;
    
    if(widget.lead.privacySelected != null) {
      List<String> s = widget.lead.privacySelected.split(',');
      List<int> i = s.map(int.parse).toList();

      toiletPrivacyMap = new Map.fromIterable(
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
    } else {
      toiletPrivacyMap = new Map.fromIterable(
        list, 
        key: (value) => value['name'], 
        value: (value) => false
      );
    }

    setState(() {
      this._privacyList = toiletPrivacyMap; 
    });
  }

  void fetchToiletTypesCA() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllToiletTypes();
    Map<String, bool> toiletTypeMap;

    if(widget.lead.typeSelected != null) {
      List<String> s = widget.lead.typeSelected.split(',');
      List<int> i = s.map(int.parse).toList();

      toiletTypeMap = new Map.fromIterable(
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
    } else {
      toiletTypeMap = new Map.fromIterable(
        list, 
        key: (value) => value['name'], 
        value: (value) => false
      );
    }
    
    setState(() {
      this._typeList = toiletTypeMap; 
    });
  }

  void fetchAllToiletSecurity() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllToiletSecurity();
    Map<String, bool> toiletSecurityMap;

    if(widget.lead.securitySelected != null) {
      List<String> s = widget.lead.securitySelected.split(',');
      List<int> i = s.map(int.parse).toList();

      toiletSecurityMap = new Map.fromIterable(
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
    } else {
      toiletSecurityMap = new Map.fromIterable(
        list, 
        key: (value) => value['name'], 
        value: (value) => false
      );
    }

    setState(() {
      this._securityList = toiletSecurityMap; 
    });
  }

  // Personal Details Widgets
  Widget _getFirstName() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: AppTranslations.of(context).text("firstName"), hasFloatingPlaceholder: true),
      controller: _firstNameController,
      onFieldSubmitted: (value) {
        _firstNameController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return AppTranslations.of(context).text("required");
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
          InputDecoration(labelText: AppTranslations.of(context).text("lastName"), hasFloatingPlaceholder: true),
      controller: _lastNameController,
      onFieldSubmitted: (value) {
        _lastNameController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return AppTranslations.of(context).text("required");
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
          labelText: AppTranslations.of(context).text("otherNames"), hasFloatingPlaceholder: true),
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
        Text(AppTranslations.of(context).text("territory")),
        DropdownButton<Territory>(
          hint: Text(AppTranslations.of(context).text("territory")),
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
              this._subTerritory = this._subTerritoryList.isNotEmpty ? this._subTerritoryList[0] : null;
              this._blockList = bloc;
              this._block = this._blockList.isNotEmpty ? this._blockList[0] : null;
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
        Text(AppTranslations.of(context).text("subTerritory")),
        _subTerritoryList.isNotEmpty
        ? DropdownButton<SubTerritory>(
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
              this._block = this._blockList.isNotEmpty ? this._blockList[0] : null;
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
        Text(AppTranslations.of(context).text("block")),
        _blockList.isNotEmpty
        ? DropdownButton<Block>(
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
        Text(AppTranslations.of(context).text("gender")),
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
        Text(AppTranslations.of(context).text("disabled")),
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
        Text(AppTranslations.of(context).text("leadType")),
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
          child: Text(AppTranslations.of(context).text("sourceOfInformation")),
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
              child: Text(AppTranslations.of(context).text("referred"))
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
                      return AppTranslations.of(context).text("required");
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
        Text(AppTranslations.of(context).text("toiletType")),
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
          labelText: AppTranslations.of(context).text("numberOfToilets"), hasFloatingPlaceholder: true),
      keyboardType: TextInputType.number,
      controller: _numberOfToiletsController,
      onFieldSubmitted: (value) {
        _numberOfToiletsController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return AppTranslations.of(context).text("required");
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
          labelText: AppTranslations.of(context).text("numberOfMaleAdult"), hasFloatingPlaceholder: true),
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
          labelText: AppTranslations.of(context).text("numberOfFemaleAdults"), hasFloatingPlaceholder: true),
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
          labelText: AppTranslations.of(context).text("numberOfMaleChildren"), hasFloatingPlaceholder: true),
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
          labelText: AppTranslations.of(context).text("numberOfFemaleChildren"), hasFloatingPlaceholder: true),
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
          labelText: AppTranslations.of(context).text("address"), hasFloatingPlaceholder: true),
      controller: _addressController,
      validator: (value) {
        if (value.isEmpty) {
          return AppTranslations.of(context).text("required");
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
          labelText: AppTranslations.of(context).text("primaryPhoneNumber"), hasFloatingPlaceholder: true),
      keyboardType: TextInputType.phone,
      controller: _primaryNumberController,
      onFieldSubmitted: (value) {
        _primaryNumberController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return AppTranslations.of(context).text("required");
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
          labelText: AppTranslations.of(context).text("secondaryPhoneNumber"), hasFloatingPlaceholder: true),
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
          child: Text(AppTranslations.of(context).text("reasonForEnrollment")),
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

  Widget _getHouseholdSavings() {
    return(
      Row(
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
                      _savingsSelected.add(key);
                    });
                  },
                );
              }).toList(),
            ),
          )
        ],
      )
    );
  }

  Widget _getServiceProvider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(AppTranslations.of(context).text("serviceProvider")),
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
        Text(AppTranslations.of(context).text("telephoneType")),
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

  Widget _getPrimaryOccupation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(AppTranslations.of(context).text("primaryOccupation")),
        DropdownButton<String>(
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
            });
          },
        )
      ],
    );
  }

  Widget _getSecondaryOccupation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(AppTranslations.of(context).text("secondaryOccupation")),
        DropdownButton<String>(
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
            Text(AppTranslations.of(context).text("salariedWorker")),
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
                      labelText: AppTranslations.of(context).text("paymentDate"), hasFloatingPlaceholder: true),
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
          child: Text(AppTranslations.of(context).text("otherPaidServices")),
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
          child: Text(AppTranslations.of(context).text("privacy")),
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
          child: Text(AppTranslations.of(context).text("type")),
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
          child: Text(AppTranslations.of(context).text("security")),
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

  Widget _getHomeOwnership() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(AppTranslations.of(context).text("homeOwnership")),
        DropdownButton<String>(
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
        )
      ],
    );
  }

  // Status Widgets
  Widget _getStatus() {
    return(
      Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(AppTranslations.of(context).text("status"))
              ),
              Text(_status)
            ],
          ),
          Container(
            child: (
              Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      DateTime datePicked = await showDatePicker(
                        context: context,
                        firstDate: new DateTime.now(),
                        initialDate: new DateTime.now(),
                        lastDate: new DateTime(2030)
                      );
                      setState(() {
                        _siteInspectionDateController.text = DateFormat.yMMMd().format(datePicked);
                        _sIDate = datePicked.toString();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                      child: AbsorbPointer(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: AppTranslations.of(context).text("siteInspectionDate"),
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
                        lastDate: new DateTime(2030)
                      );
                      setState(() {
                        _toiletInstallationDateController.text = DateFormat.yMMMd().format(datePicked);
                        _tIDate = datePicked.toString();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                      child: AbsorbPointer(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: AppTranslations.of(context).text("toiletInstallationDate"),
                            hasFloatingPlaceholder: true,
                          ),
                          controller: _toiletInstallationDateController,
                          validator: (value) {
                            if(value.isEmpty)
                              return AppTranslations.of(context).text("required");
                          },
                        ),
                      ),
                    ),
                  )
                ],
              )
            ),
          )
        ],
      )
    );
  }

  Widget _getComment() {
    return TextFormField(
      decoration:
          InputDecoration(labelText: AppTranslations.of(context).text("comment"), hasFloatingPlaceholder: true),
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

  // Location Information Widgets
  Widget _getCustomerImage() {
    return(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(AppTranslations.of(context).text("customerImage")),
              ),
              RaisedButton(
                child: Row(children: <Widget>[Text('Take Photo  '), Icon(Icons.camera_alt)],),
                onPressed: () async {
                  var image = await ImagePicker.pickImage(source: ImageSource.camera);
                  print(image);
                  setState(() {
                    _customerImage = image;
                  });
                },
              ),
              FlatButton(
                child: Row(children: <Widget>[Text('Gallery  '), Icon(Icons.collections)],),
                onPressed: () async {
                  var image = await ImagePicker.pickImage(source: ImageSource.gallery);
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
            child: _customerImage == null ?
              Image.asset('assets/profile-placeholder.png') :
              Image.file(_customerImage),
          )
        ],
      )
    );
  }

  Widget _getHouseholdImage() {
    return(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(AppTranslations.of(context).text("householdImage")),
              ),
              RaisedButton(
                child: Row(children: <Widget>[Text('Take Photo  '), Icon(Icons.camera_alt)],),
                onPressed: () async {
                  var image = await ImagePicker.pickImage(source: ImageSource.camera);
                  setState(() {
                    _houseHoldImage = image;
                  });
                },
              ),
              FlatButton(
                child: Row(children: <Widget>[Text('Gallery  '), Icon(Icons.collections)],),
                onPressed: () async {
                  var image = await ImagePicker.pickImage(source: ImageSource.gallery);
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
            child: _houseHoldImage == null ?
              Image.asset('assets/house-placeholder.jpg') :
              Image.file(_houseHoldImage),
          )
        ],
      )
    );
  }

  Widget _getLandMarkImage() {
    return(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(AppTranslations.of(context).text("landmarkImage")),
              ),
              RaisedButton(
                child: Row(children: <Widget>[Text('Take Photo  '), Icon(Icons.camera_alt)],),
                onPressed: () async {
                  var image = await ImagePicker.pickImage(source: ImageSource.camera);
                  setState(() {
                    _landmarkImage = image;
                  });
                },
              ),
              FlatButton(
                child: Row(children: <Widget>[Text('Gallery  '), Icon(Icons.collections)],),
                onPressed: () async {
                  var image = await ImagePicker.pickImage(source: ImageSource.gallery);
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
            child: _landmarkImage == null ?
              Image.asset('assets/landmark-placeholder.png') :
              Image.file(_landmarkImage),
          )
        ],
      )
    );
  }

  // Payment Information Widgets
  Widget _getMobileMoneyCode() {
    return(
      TextFormField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: AppTranslations.of(context).text("mobileMoneyCode"),
          hasFloatingPlaceholder: true
        ),
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
      )
    );
  }

  Widget _getPayer() {
    return(
      Column(
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
          _payer == 'No' ?
          Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppTranslations.of(context).text("payerFirstName"),
                  hasFloatingPlaceholder: true
                ),
                controller: _payerFirstNameController,
                onFieldSubmitted: (value) {
                  _payerFirstNameController.text = value;
                },
                validator: (value) {
                  if(value.isEmpty) {
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
                  hasFloatingPlaceholder: true
                ),
                controller: _payerLastNameController,
                onFieldSubmitted: (value) {
                  _payerLastNameController.text = value;
                },
                validator: (value) {
                  if(value.isEmpty) {
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
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: AppTranslations.of(context).text("payerPrimaryTelephone"),
                  hasFloatingPlaceholder: true
                ),
                keyboardType: TextInputType.number,
                controller: _payerPrimaryPhoneNumberController,
                onFieldSubmitted: (value) {
                  _payerPrimaryPhoneNumberController.text = value;
                },
                validator: (value) {
                  if(value.isEmpty) {
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
                  hasFloatingPlaceholder: true
                ),
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
                  labelText:AppTranslations.of(context).text("payerOccupation"),
                  hasFloatingPlaceholder: true
                ),
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
      )
    );
  }
  
  Widget _getPaymentMethod() {
    return(
      Row(
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
                      _paymentMethodSelected.add(key);
                    });
                  },
                );
              }).toList(),
            ),
          )
        ],
      )
    );
  }
  
  // Document Upload
  Widget _getDocument() {
    return(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _documentPath == null
          ? Text('No Document Selected')
          : Text(_documentPath.length.toString() + ' ' + AppTranslations.of(context).text("documentAdded")),
          RaisedButton(
            child: Icon(Icons.attachment),
            onPressed: () async {
              try {
                String filePath = await FilePicker.getFilePath(type: FileType.ANY);
                if(filePath == null) return;
                setState(() {
                  _documentPath.add(filePath);
                });
                print(_documentPath);
              } catch(e) {
                print(e.toString());
              }
            },
          )
        ],
      )
    );
  }

  // Steps
  List<Step> _steps(InitialSetupModel model) {
    List<Step> steps = [
      Step(
        title: Text(AppTranslations.of(context).text("Personal Details")),
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
        isActive: _currentStep >= 0
      ),
      Step(
        title: Text(AppTranslations.of(context).text("toiletInformation")),
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
        isActive: _currentStep >= 1
      ),
      Step(
        title: Text(AppTranslations.of(context).text("contactDetails")),
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
        isActive: _currentStep >= 2
      ),
      Step(
        title: Text(AppTranslations.of(context).text("additionalInformation")),
        content: Form(
          key: _additionalInformationFormKey,
          child: Column(
            children: <Widget>[
              _getEnrollmentReason(model),
              Divider(),
              _getHouseholdSavings(),
              Divider(),
              _getServiceProvider(),
              Divider(),
              _getTelephoneType(),
              Divider(),
              _getPrimaryOccupation(),
              Divider(),
              _getSecondaryOccupation(),
              Divider(),
              _getSalariedWorker(),
              Divider(),
              _getOtherPaidServices(model),
              Divider(),
              _getHomeOwnership(),
              Divider(),
              Column(
                children: <Widget>[
                  Text(AppTranslations.of(context).text("currentAccessToToilet")),
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
        isActive: _currentStep >= 3
      ),
      Step(
        title: Text(AppTranslations.of(context).text("status")),
        content: Form(
          key: _statusFormKey,
          child: Column(
            children: <Widget>[
              _getStatus(),
              Divider(),
              _getComment(),
              Divider(),
            ],
          ),
        ),
        isActive: _currentStep >= 4
      ),
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
        isActive: _currentStep >= 5
      ),
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
        isActive: _currentStep >= 6
      ),
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
        isActive: _currentStep >= 7
      ),
    ];
    return steps;
  }

  void _createDirectOrder(LeadModel model, int userId) async {
    try {
      setState(() {
        // _isLoading = true;
      });

      Map<String, dynamic> map = {
        'firstName': _firstName,
        'lastName': _lastName,
        'otherNames': _otherNames,
        'territory': _territory.territoryId,
        'subTerritory': _subTerritory.subTerritoryId,
        'blocks': _block.blockId,
        'gender': _gender,
        'disability': _disability,
        'sourceOfInfo': _infoSourceSelected.join(','),
        'referredby': _referredBy,
        'toiletType': _toiletType.toiletTypeId,
        'numberOfToilets': _numberOfToilets,
        'numOfMalesServedByToilet': _numberOfMaleAdults,
        'numOfFemalesServedByToilet': _numberOfFemaleAdults,
        'numOfBoysServedByToilet': _numberOfMaleChildren,
        'numOfGirlsServedByToilet': _numberOfFemaleChildren,
        'primaryTelephone': _primaryPhoneNumber,
        'secondaryTelephone': _secondaryPhoneNumber,
        'address': _address,
        // 'latitude': _latitude,
        // 'longitude': _longitude,
        'leadtype': _leadType.leadTypeId,
        'telephoneType': _telephoneType.telephoneTypeId,
        'telephoneServiceProvider': _serviceProvider.serviceProviderId,
        'otherPaidServices': _servicesSelected.join(','),
        'accessToiletPrivacy': _privacySelected.join(','),
        'accessToiletType': _typeSelected.join(','),
        'toileaccessToiletSecurity': _securitySelected.join(','),
        'salaryWorker': _salariedWorker,
        'payDay': _paymentDate,
        // 'reasonForEnrollment': _reasonsSelected.join(','),
        // 'houseHoldSavings': _savingsSelected.join(','),
        // 'primaryOccupation': _primaryOccupation,
        // 'secondaryOccupation': _secondaryOccupation,
        // 'homeOwnership': _homeOwnership,
        // // 'customerImage': ,
        // // 'householdImage': ,
        // // 'landmarkImage': ,
        // 'mobileMoneyCode': _mobileMoneyCode,
        // 'payerFirstName': _payerFirstName,
        // 'payerLastName': _payerLastName,
        // 'relationship': _relationship,
        // 'payerPrimaryTelephone': _payerPrimaryPhoneNumber,
        // 'payerSecondaryTelephone': _payerSecondaryPhoneNumber,
        // 'payerOccupation': _payerOccupation,
        // 'paymentMethod': _paymentMethodSelected.join(','),
        // 'device': 'mobile'
      };

      print(map);
      // print(_servicesSelected.join(','));

      // DirectOrder directOrder = new DirectOrder(
      //   _firstName, 
      //   _lastName, 
      //   _otherNames, 
      //   _territory.territoryId, 
      //   _subTerritory.subTerritoryId, 
      //   _block.blockId, 
      //   _gender, 
      //   _primaryPhoneNumber, 
      //   _secondaryPhoneNumber, 
      //   _referredBy, 
      //   _toiletType.toiletTypeId, 
      //   _numberOfToilets, 
      //   _numberOfMaleAdults,
      //   _numberOfFemaleAdults,
      //   _numberOfMaleChildren,
      //   _numberOfFemaleChildren,
      //   _latitude, 
      //   _longitude, 
      //   _infoSourceSelected.join(','), 
      //   _leadType.leadTypeId, 
      //   _disability, 
      //   _reasonsSelected.join(','), 
      //   _savingsSelected.join(','), 
      //   _primaryOccupation, 
      //   _secondaryOccupation, 
      //   _homeOwnership, 
      //   base64Encode(_customerImage.readAsBytesSync()), 
      //   base64Encode(_houseHoldImage.readAsBytesSync()), 
      //   base64Encode(_landmarkImage.readAsBytesSync()), 
      //   _mobileMoneyCode, 
      //   _payerFirstName, 
      //   _payerLastName, 
      //   _relationship, 
      //   _payerPrimaryPhoneNumber, 
      //   _payerSecondaryPhoneNumber, 
      //   _payerOccupation, 
      //   _paymentMethodSelected.join(','), 
      //   userId, 
      //   _serviceProvider.serviceProviderId, 
      //   _telephoneType.telephoneTypeId, 
      //   _salariedWorker, 
      //   _paymentDate, 
      //   _servicesSelected.join(','), 
      //   _typeSelected.join(','), 
      //   _securitySelected.join(','), 
      //   _privacySelected.join(','), 
      //   _address, 
      //   _endTime
      // );

      // print(directOrder.toApiMap());

      // var response = await DirectOrderService.updateDirectOrder(directOrder, widget.lead.id);
      // var decodedJson = jsonDecode(response.body);
      // var status = decodedJson['status'];
      // var jsonLead = decodedJson['lead'];
      // var jsonLeadConversion = decodedJson['leadconversion'];
      // var jsonOrder = decodedJson['order'];

      // // print(status);
      // // print(decodedJson);
      
      // if(status == 200) {
      //   int updateLead = await model.updateLead(Lead.map(jsonLead));
      //   var db = DatabaseHelper();
      //   int updateLeadConversion = await db.updateLeadConversion(LeadConversion.map(jsonLeadConversion));
      //   int updateOrder = await db.updateOrder(Order.map(jsonOrder));

      //   if(updateLead > 0 && updateLeadConversion > 0 && updateOrder > 0) {
      //     Fluttertoast.showToast(
      //       msg: 'Direct Order Updated Successfully',
      //       toastLength: Toast.LENGTH_SHORT,
      //     );
      //     setState(() {
      //       _isLoading = false;
      //     });
      //     Navigator.of(context).pop();
      //   } else {
      //     Fluttertoast.showToast(
      //       msg: 'Could Not Save To Local DB',
      //       toastLength: Toast.LENGTH_SHORT,
      //     );
      //     setState(() {
      //       _isLoading = false;
      //     });
      //     Navigator.of(context).pop();
      //   }
      // } else {
      //   Fluttertoast.showToast(
      //     msg: 'Could Not Update Direct Order',
      //     toastLength: Toast.LENGTH_SHORT,
      //   );
      //   setState(() {
      //     _isLoading = false; 
      //   });
      // }
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
              title: Text('Update Direct Order'),
            ),
            body: ModalProgressHUD(
              inAsyncCall: _isLoading,
              opacity: 0.5,
              progressIndicator: CircularProgressIndicator(),
              child: new ScopedModelDescendant<LeadModel>(
                builder: (context, child, leadModel) {
                  return ScopedModelDescendant<InitialSetupModel>(
                    builder: (context, child, initialSetupModel) {
                      initialSetupModel.fetchAllTerritories();
                      initialSetupModel.fetchAllSubTerritories();
                      initialSetupModel.fetchAllBlocks();
                      initialSetupModel.fetchAllLeadTypes();
                      initialSetupModel.fetchAllToiletTypes();
                      initialSetupModel.fetchAllTelephoneTypes();
                      initialSetupModel.fetchUserObject();
                      
                      return Stepper(
                        steps: _steps(initialSetupModel),
                        currentStep: this._currentStep,
                        onStepTapped: (step) {
                          setState(() {
                            FocusScope.of(context).requestFocus(new FocusNode());
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
                          } else if(this._currentStep <= 4){
                            if(_statusFormKey.currentState.validate()) {
                              setState(() {
                                this._currentStep = this._currentStep + 1;
                              });
                            }
                          } else if(this._currentStep <= 5) {
                            setState(() {
                              this._currentStep = this._currentStep + 1;
                            });
                          } else if(this._currentStep <= 6) {
                            setState(() {
                              this._currentStep = this._currentStep + 1;
                            });
                          } else if(this._currentStep <= 7) {
                            _personalDetailsFormKey.currentState.save();
                            _toiletInformationFormKey.currentState.save();
                            _contactInformationFormKey.currentState.save();
                            _additionalInformationFormKey.currentState.save();
                            _statusFormKey.currentState.save();
                            _locationInformationFormKey.currentState.save();
                            _paymentInformationFormKey.currentState.save();
                            _documentFormKey.currentState.save();

                            _createDirectOrder(leadModel, initialSetupModel.userObject['userId']);
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