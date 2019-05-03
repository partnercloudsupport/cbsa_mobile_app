import 'dart:convert';

class Leads {
  int _id;
  String _firstName;
  String _lastName;
  String _otherNames;
  String _uuid;
  int _territory;
  int _subTerritory;
  String _block;
  String _gender;
  String _primaryTelephone;
  String _secondaryTelephone;
  String _referredBy;
  int _toiletType;
  int _noOfToilets;
  int _noOfMaleAdults;
  int _noOfFemaleAdults;
  int _noOfMaleChildren;
  int _noOfFemaleChildren;
  double _latitude;
  double _longitude;
  List<String> _infoSourceSelected;
  int _leadType;
  String _disability;
  List<String> _reasonsSelected;
  String _status;
  String _comments;
  int _createdBy;
  String _serviceProvider;
  String _telephoneType;
  String _salariedWorker;
  String _paymentDate;
  List<String> _servicesSelected;
  List<String> _typeSelected;
  List<String> _securitySelected;
  List<String> _privacySelected;
  String _type;
  String _followupDate;
  String _installDate;
  String _sIDate;
  String _address;
  String _startTime;
  String _endTime;
  int _archived;
  String _archiveDate;
  String _archiveStage;


  Leads(this._firstName, this._lastName, this._otherNames, this._territory, this._subTerritory,this._block, this._gender,this._primaryTelephone,
  this._secondaryTelephone,this._referredBy,this._toiletType,this._noOfToilets,this._noOfMaleAdults,this._noOfFemaleAdults,this._noOfMaleChildren,
  this._noOfFemaleChildren,this._latitude,this._longitude,this._infoSourceSelected,this._leadType,this._disability,this._reasonsSelected,this._status,
  this._comments, this._createdBy, this._serviceProvider,this._telephoneType,this._salariedWorker,this._paymentDate,this._servicesSelected,this._typeSelected,this._securitySelected,
  this._privacySelected,this._followupDate,this._installDate,this._sIDate,this._address,this._startTime,this._endTime,this._archived,
  this._archiveDate,this._archiveStage
  );

  Leads.map(Map<String,dynamic> obj) {
    this._id = obj['id'];
    this._firstName = obj['firstName'];
    this._lastName = obj['lastName'];
    this._otherNames = obj['otherNames'];
    this._territory = obj['territory'];
    this._subTerritory = obj['subTerritory'];
    this._block = obj['block'];
    this._gender = obj['gender'];
    this._primaryTelephone = obj['primaryTelephone'];
    this._secondaryTelephone = obj['secondaryTelephone'];
    this._referredBy = obj['referredBy'];
    this._toiletType = obj['toiletType'];
    this._noOfToilets = obj['noOfToilets'];
    this._noOfMaleAdults = obj['noOfMaleAdults'];
    this._noOfFemaleAdults = obj['noOfFemaleAdults'];
    this._noOfMaleChildren = obj['noOfMaleChildren'];
    this._noOfFemaleChildren = obj['noOfFemaleChildren'];
    this._latitude = obj['latitude'];
    this._longitude = obj['longitude'];
    this._infoSourceSelected = (jsonDecode(obj['infoSourceSelected'])as List<dynamic>).cast<String>();
    this._leadType = obj['leadType'];
    this._reasonsSelected = (jsonDecode(obj['reasonsSelected'])as List<dynamic>).cast<String>();
    this._status = obj['status'];
    this._comments = obj['comments'];
    this._createdBy = obj['createdBy'];
    this._serviceProvider = obj['serviceProvider'];
    this._telephoneType = obj['telephoneType'];
    this._salariedWorker = obj['salariedWorker'];
    this._paymentDate = obj['paymentDate'];
    this._servicesSelected = (jsonDecode(obj['servicesSelected'])as List<dynamic>).cast<String>();
    this._typeSelected = (jsonDecode(obj['typeSelected'])as List<dynamic>).cast<String>();
    this._securitySelected = (jsonDecode(obj['securitySelected'])as List<dynamic>).cast<String>();
    this._privacySelected = (jsonDecode(obj['privacySelected'])as List<dynamic>).cast<String>();
    this._followupDate = obj['followUpDate'];
    this._installDate = obj['installDate'];
    this._sIDate = obj['siteInspectionDate'];
    this._address = obj['address'];
    this._startTime = obj['startTime'];
    this._endTime = obj['endTime'];
    this._disability = obj['disability'];
    this._archived = obj['archived'];
    this._archiveDate = obj['archiveDate'];
    this._archiveStage = obj['archiveStage'];
  }

  void setId(int id){
    this._id=id;
  }

  void setStatus(String value){
    this._status=value;
  }

  void setArchived(int value){
    this._archived=value;
  }

  
 
  int get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get otherNames => _otherNames;
  int get territory => _territory;
  int get subTerritory => _subTerritory;
  String get block => _block;
  String get gender => _gender;
  String get primaryTelephone =>_primaryTelephone;
  String get secondaryTelephone => _secondaryTelephone;
  String get referredBy =>_referredBy;
  int get toiletType => _toiletType;
  int get noOfToilets => _noOfToilets;
  int get noOfMaleAdults => _noOfMaleAdults;
  int get noOfFemaleAdults => _noOfFemaleAdults;
  int get noOfMaleChildren => _noOfMaleChildren;
  int get noOfFemaleChildren => _noOfFemaleChildren;
  double get latitude => _latitude;
  double get longitude => _longitude;
  List<String> get infoSourceSelected => _infoSourceSelected;
  int get leadType => _leadType;
  String get disability => _disability;
  List<String> get reasonsSelected =>_reasonsSelected;
  String get status =>_status;
  String get comments => _comments;
  int get createdBy => _createdBy;
  String get serviceProvider => _serviceProvider;
  String get telephoneType => _telephoneType;
  String get salariedWorker => _salariedWorker;
  String get paymentDate => _paymentDate;
  List<String> get servicesSelected =>_servicesSelected;
  List<String> get typeSelected => _typeSelected;
  List<String> get securitySelected => _securitySelected;
  List<String> get privacySelected => _privacySelected;
  String get followupDate => _followupDate;
  String get installDate => _installDate;
  String get siteInspectionDate => _sIDate;
  String get address => _address;
  String get startTime => _startTime;
  String get endTime => _endTime;
  int get archived => _archived;
  String get archiveDate => _archiveDate;
  String get archiveStage => _archiveStage;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['fname'] =  _firstName;
    map['lname'] =  _lastName;
    map['onames'] =  _otherNames;
    map['terrisectownid'] =  _territory;
    map['subterrizonecomid'] =  _subTerritory;
    map['block'] =  _block;
    map['address'] =  _address;
    map['gender'] =  _gender;
    map['pritelephone'] =  _primaryTelephone;
    map['sectelephone'] =  _secondaryTelephone;
    map['referredby'] =  _referredBy;
    map['toilettypeid'] =  _toiletType;
    map['numoftoilets'] =  _noOfToilets;
    map['numofmaleadults'] =  _noOfMaleAdults;
    map['numoffemaleadults'] =  _noOfFemaleAdults;
    map['numofmalechild'] =  _noOfMaleChildren;
    map['numofemalechild'] =  _noOfFemaleChildren;
    map['lat'] =  _latitude;
    map['lng'] =  _longitude;
    map['soofinfo'] =  json.encode(_infoSourceSelected);
    map['leadtype'] =  _leadType;
    map['disability'] =  _disability;
    map['resofenroll'] =  json.encode(_reasonsSelected);
    map['status'] =  _status;
    map['comments'] =  _comments;
    map['created_by'] = _createdBy;
    map['teleserpro'] =  _serviceProvider;
    map['teletype'] =  _telephoneType;
    map['issalworker'] =  _salariedWorker;
    map['dateofpay'] =  _paymentDate;
    map['opaidservices'] =  json.encode(_servicesSelected);
    map['toilettype'] =  json.encode(_typeSelected);
    map['toiletsecu'] =  json.encode(_securitySelected);
    map['curaccesstotoilet'] =  json.encode(_privacySelected);
  
    map['followupDate'] =  _followupDate;
    map['installDate'] =  _installDate;
    map['siteInspectionDate'] =  _sIDate;
    map['startTime'] =  _startTime;
    map['endTime'] =  _endTime;
    map['archived'] = _archived;
    map['archiveddate'] = archiveDate;
    map['archivedat'] = archiveStage;
    return map;
  }
 
  Leads.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._firstName =  map['firstName'];
    this._lastName = map['lastName'];
    this._otherNames=map['otherNames'];
    this._territory=map['territory'];
    this._subTerritory=map['subTerritory'];
    this._block=map['block'];
    this._gender=map['gender'];
    this._primaryTelephone=map['primaryTelephone'];
    this._secondaryTelephone=map['secondaryTelephone'];
    this._referredBy=map['referredBy'];
    this._toiletType=map['toiletType'];
    this._noOfToilets=map['noOfToilets'];
    this._noOfMaleAdults=map['noOfMaleAdults'];
    this._noOfFemaleAdults=map['noOfFemaleAdults'];
    this._noOfMaleChildren=map['noOfMaleChildren'];
    this._noOfFemaleChildren=map['noOfFemaleChildren'];
    this._latitude=map['latitude'];
    this._longitude=map['longitude'];
    this._infoSourceSelected= List.from(map['infoSourceSelected']);
    this._leadType=map['leadType'];
    this._disability=map['disability'];
    this._reasonsSelected= List.from(map['reasonsSelected']);
    this._status=map['status'];
    this._comments=map['comments'];
    this._createdBy=map['createdBy'];
    this._serviceProvider=map['serviceProvider'];
    this._telephoneType=map['telephoneType'];
    this._salariedWorker=map['salariedWorker'];
    this._paymentDate=map['paymentDate'];
    this._servicesSelected= List.from(map['servicesSelected']);
    this._typeSelected= List.from(map['typeSelected']);
    this._securitySelected= List.from(map['securitySelected']);
    this._privacySelected= List.from(map['privacySelected']);
    this._followupDate=map['followupDate'];
    this._installDate=map['installDate'];
    this._sIDate=map['siteInspectionDate'];
    this._address=map['address'];
    this._startTime=map['startTime'];
    this._endTime=map['endTime'];
    this._archived = map['archived'];
    this._archiveDate = map['archiveDate'];
    this._archiveStage =map['archiveStage'];
  }
}


class Lead {
  int _id;
  String _firstName;
  String _lastName;
  String _otherNames;
  String _uuid;//
  int _territory;
  int _subTerritory;
  int _block;
  String _gender;
  String _primaryTelephone;
  String _secondaryTelephone;
  String _referredBy;
  int _toiletType;
  int _noOfToilets;
  int _noOfMaleAdults;
  int _noOfFemaleAdults;
  int _noOfMaleChildren;
  int _noOfFemaleChildren;
  double _latitude;
  double _longitude;
  String _infoSourceSelected;
  int _leadType;
  String _disability;
  String _reasonsSelected;
  String _status;
  String _fUDate;
  String _sIDate;
  String _tIDate;
  String _comments;
  int _createdBy;
  int _serviceProvider;
  int _telephoneType;
  String _salariedWorker;
  String _paymentDate;
  String _servicesSelected;
  String _typeSelected;
  String _securitySelected;
  String _privacySelected;
  String _type;
  int _approved;
  String _address;
  int _archived;
  String _archiveDate;
  String _archiveStage;
  String _createdAt;
  String _updatedAt;

  Lead(this._firstName, this._lastName, this._otherNames, this._uuid, this._territory, this._subTerritory, this._block,
  this._gender, this._primaryTelephone, this._secondaryTelephone, this._referredBy, this._toiletType, this._noOfToilets,
  this._noOfMaleAdults, this._noOfFemaleAdults, this._noOfMaleChildren, this._noOfFemaleChildren, this._latitude, this._longitude,
  this._infoSourceSelected, this._leadType, this._disability, this._reasonsSelected, this._status, this._fUDate, this._sIDate, this._tIDate, this._comments, this._createdBy,
  this._serviceProvider, this._telephoneType, this._salariedWorker, this._paymentDate, this._servicesSelected, this._typeSelected,
  this._securitySelected, this._privacySelected, this._type, this._approved, this._address, this._archived, this._archiveDate,
  this._archiveStage, this._createdAt, this._updatedAt);

  Lead.empty();

  // Setters
  void setId(int id) {
    this._id = id;
  }

  void setStatus(String value) {
    this._status = value;
  }

  void setArchived(int value) {
    this._archived = value;
  }

  // Getters
  int get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get otherNames => _otherNames;
  String get uuid => _uuid;
  int get territory => _territory;
  int get subTerritory => _subTerritory;
  int get block => _block;
  String get gender => _gender;
  String get primaryTelephone =>_primaryTelephone;
  String get secondaryTelephone => _secondaryTelephone;
  String get referredBy =>_referredBy;
  int get toiletType => _toiletType;
  int get noOfToilets => _noOfToilets;
  int get noOfMaleAdults => _noOfMaleAdults;
  int get noOfFemaleAdults => _noOfFemaleAdults;
  int get noOfMaleChildren => _noOfMaleChildren;
  int get noOfFemaleChildren => _noOfFemaleChildren;
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get infoSourceSelected => _infoSourceSelected;
  int get leadType => _leadType;
  String get disability => _disability;
  String get reasonsSelected =>_reasonsSelected;
  String get status =>_status;
  String get followUpDate =>_fUDate;
  String get siteInspectionDate =>_sIDate;
  String get installationDate =>_tIDate;
  String get comments => _comments;
  int get createdBy => _createdBy;
  int get serviceProvider => _serviceProvider;
  int get telephoneType => _telephoneType;
  String get salariedWorker => _salariedWorker;
  String get paymentDate => _paymentDate;
  String get servicesSelected =>_servicesSelected;
  String get typeSelected => _typeSelected;
  String get securitySelected => _securitySelected;
  String get privacySelected => _privacySelected;
  String get type => _type;
  int get approved => _approved;
  String get address => _address;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get archived => _archived;
  String get archiveDate => _archiveDate;
  String get archiveStage => _archiveStage;

  Lead.map(dynamic object) {
    this._id = object['id'];
    this._firstName = object['fname'];
    this._lastName = object['lname'];
    this._otherNames = object['onames'];
    this._uuid = object['uuid'];
    this._territory = object['terrisectownid'];
    this._subTerritory = object['subterrizonecomid'];
    this._block = object['block'];
    this._address = object['address'];
    this._gender = object['gender'];
    this._primaryTelephone = object['pritelephone'];
    this._secondaryTelephone = object['sectelephone'];
    this._referredBy = null;
    this._toiletType = object['toilettypeid'];
    this._noOfToilets = object['numoftoilets'];
    this._noOfMaleAdults = object['numofmaleadults'];
    this._noOfFemaleAdults = object['numoffemaleadults'];
    this._noOfMaleChildren = object['numofmalechild'];
    this._noOfFemaleChildren = object['numofemalechild'];
    this._latitude = object['lat'];
    this._longitude = object['lng'];
    this._infoSourceSelected = object['soofinfo'];
    this._leadType = object['leadtype'];
    this._disability = object['disability'];
    this._reasonsSelected = object['resofenroll'];
    this._status = object['status'];
    this._fUDate = null;
    this._sIDate = null;
    this._tIDate = null;
    this._comments = object['comments'];
    this._createdBy = object['created_by'];
    this._serviceProvider = object['teleserpro'];
    this._telephoneType = object['teletype'];
    this._salariedWorker = object['issalworker'];
    this._paymentDate = object['dateofpay'].toString();
    this._servicesSelected = object['opaidservices'];
    this._typeSelected = object['toilettype'];
    this._securitySelected = object['toiletsecu'];
    this._privacySelected = object['toiletprivacy'];
    this._type = object['type'];
    this._approved = object['approved'];
    this._archived = object['archived'];
    this._archiveDate = object['archiveddate'];
    this._archiveStage = object['archivedat'];
    this._createdAt = object['created_at'];
    this._updatedAt = object['updated_at'];
  }

  Lead.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._firstName =  map['fname'];
    this._lastName = map['lname'];
    this._otherNames = map['onames'];
    this._uuid = map['uuid'];
    this._territory = map['terrisectownid'];
    this._subTerritory = map['subterrizonecomid'];
    this._block = map['block'];
    this._address = map['address'];
    this._gender = map['gender'];
    this._primaryTelephone = map['pritelephone'];
    this._secondaryTelephone = map['sectelephone'];
    this._referredBy = map['referredby'];
    this._toiletType = map['toilettypeid'];
    this._noOfToilets = map['numoftoilets'];
    this._noOfMaleAdults = map['numofmaleadults'];
    this._noOfFemaleAdults = map['numoffemaleadults'];
    this._noOfMaleChildren = map['numofmalechild'];
    this._noOfFemaleChildren = map['numofemalechild'];
    this._latitude = map['lat'];
    this._longitude = map['lng'];
    this._infoSourceSelected = map['soofinfo'];
    this._leadType = map['leadtype'];
    this._disability = map['disability'];
    this._reasonsSelected = map['resofenroll'];
    this._status = map['status'];
    this._comments = map['comments'];
    this._createdBy = map['created_by'];
    this._serviceProvider = map['teleserpro'];
    this._telephoneType = map['teletype'];
    this._salariedWorker = map['issalworker'];
    this._paymentDate = map['dateofpay'];
    this._servicesSelected = map['opaidservices'];
    this._typeSelected = map['toilettype'];
    this._securitySelected = map['toiletsecu'];
    this._privacySelected = map['toiletprivacy'];
    this._type = map['type'];
    this._approved = map['approved'];
    this._archived = map['archived'];
    this._archiveDate = map['archiveddate'];
    this._archiveStage = map['archivedat'];
    this._createdAt = map['created_at'];
    this._updatedAt = map['updated_at'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['fname'] =  _firstName;
    map['lname'] =  _lastName;
    map['onames'] =  _otherNames;
    map['uuid'] =  _uuid;
    map['terrisectownid'] =  _territory;
    map['subterrizonecomid'] =  _subTerritory;
    map['block'] =  _block;
    map['address'] =  _address;
    map['gender'] =  _gender;
    map['pritelephone'] =  _primaryTelephone;
    map['sectelephone'] =  _secondaryTelephone;
    map['referredby'] =  _referredBy;
    map['toilettypeid'] =  _toiletType;
    map['numoftoilets'] =  _noOfToilets;
    map['numofmaleadults'] =  _noOfMaleAdults;
    map['numoffemaleadults'] =  _noOfFemaleAdults;
    map['numofmalechild'] =  _noOfMaleChildren;
    map['numofemalechild'] =  _noOfFemaleChildren;
    map['lat'] =  _latitude;
    map['lng'] =  _longitude;
    map['soofinfo'] =  _infoSourceSelected;
    map['leadtype'] =  _leadType;
    map['disability'] =  _disability;
    map['resofenroll'] =  _reasonsSelected;
    map['status'] =  _status;
    map['comments'] =  _comments;
    map['created_by'] = _createdBy;
    map['teleserpro'] =  _serviceProvider;
    map['teletype'] =  _telephoneType;
    map['issalworker'] =  _salariedWorker;
    map['dateofpay'] =  _paymentDate;
    map['opaidservices'] =  _servicesSelected;
    map['toilettype'] =  _typeSelected;
    map['toiletsecu'] =  _securitySelected;
    // map['curaccesstotoilet'] =  json.encode(_privacySelected);
    map['toiletprivacy'] =  _privacySelected;
    map['type'] = _type;
    map['approved'] = _approved;
    map['archived'] = _archived;
    map['archiveddate'] = _archiveDate;
    map['archivedat'] = _archiveStage;
    map['created_at'] =  _createdAt;
    map['updated_at'] =  _updatedAt;

    return map;
  }

  Map<String, dynamic> toApiMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['fname'] =  _firstName;
    map['lname'] =  _lastName;
    map['onames'] =  _otherNames;
    map['uuid'] =  _uuid;
    map['terrisectownid'] =  _territory;
    map['subterrizonecomid'] =  _subTerritory;
    map['block'] =  _block;
    map['address'] =  _address;
    map['gender'] =  _gender;
    map['pritelephone'] =  _primaryTelephone;
    map['sectelephone'] =  _secondaryTelephone;
    map['referredby'] =  _referredBy;
    map['toilettypeid'] =  _toiletType;
    map['numoftoilets'] =  _noOfToilets;
    map['numofmaleadults'] =  _noOfMaleAdults;
    map['numoffemaleadults'] =  _noOfFemaleAdults;
    map['numofmalechild'] =  _noOfMaleChildren;
    map['numofemalechild'] =  _noOfFemaleChildren;
    map['lat'] =  _latitude;
    map['lng'] =  _longitude;
    map['soofinfo'] =  _infoSourceSelected;
    map['leadtype'] =  _leadType;
    map['disability'] =  _disability;
    map['resofenroll'] =  _reasonsSelected;
    map['status'] =  _status;
    map['follupdate'] = _fUDate;
    map['inspectiondate'] = _sIDate;
    map['installdate'] = _tIDate;
    map['comments'] =  _comments;
    map['createdby'] = _createdBy;
    map['teleserpro'] =  _serviceProvider;
    map['teletype'] =  _telephoneType;
    map['issalworker'] =  _salariedWorker;
    map['dateofpay'] =  _paymentDate;
    map['opaidservices'] =  _servicesSelected;
    map['toilettype'] =  _typeSelected;
    map['toiletsecu'] =  _securitySelected;
    map['curaccesstotoilet'] =  _privacySelected;
    // map['toiletprivacy'] =  json.encode(_privacySelected);
    map['type'] = _type;
    map['approved'] = _approved;
    map['archived'] = _archived;
    map['archiveddate'] = _archiveDate;
    map['archivedat'] = _archiveStage;
    map['created_at'] =  _createdAt;
    map['updated_at'] =  _updatedAt;
    map['device'] = 'mobile';

    return map;
  }
}