class LeadConversion {
  int _id;
  int _leadId;
  String _dateOfConversion;
  String _mobileMoneyCode;
  String _payerFirstName;
  String _payerLastName;
  String _relationship;
  String _payerPrimaryTelephone;
  String _payerSecondaryTelephone;
  String _payerOccupation;
  String _paymentMethod;
  int _createdBy;
  String _householdSavings;
  String _primaryOccupation;
  String _secondaryOccupation;
  String _homeOwnership;
  String _customerImageUrl;
  String _landmarkImageUrl;
  String _householdImageUrl;
  int _status;
  String _createdAt;
  String _updatedAt;

  LeadConversion(this._leadId, this._dateOfConversion, this._mobileMoneyCode, this._payerFirstName, this._payerLastName,
  this._relationship, this._payerPrimaryTelephone, this._payerSecondaryTelephone, this._payerOccupation,
  this._paymentMethod, this._createdBy, this._householdSavings, this._primaryOccupation, this._secondaryOccupation,
  this._homeOwnership, this._customerImageUrl, this._landmarkImageUrl, this._householdImageUrl, this._status, this._createdAt, this._updatedAt);

  // Getters
  int get id => _id;
  int get leadId => _leadId;
  String get dateOfConversion => _dateOfConversion;
  String get mobileMoneyCode => _mobileMoneyCode;
  String get payerFirstName => _payerFirstName;
  String get payerLastName => _payerLastName;
  String get relationship => _relationship;
  String get payerPrimaryTelephone => _payerPrimaryTelephone;
  String get payerSecondaryTelephone => _payerSecondaryTelephone;
  String get payerOccupation => _payerOccupation;
  String get paymentMethod => _paymentMethod;
  int get createdBy => _createdBy;
  String get householdSavings => _householdSavings;
  String get primaryOccupation => _primaryOccupation;
  String get secondaryOccupation => _secondaryOccupation;
  String get homeOwnership => _homeOwnership;
  String get customerImageUrl => _customerImageUrl;
  String get landmarkImageUrl => _landmarkImageUrl;
  String get householdImageUrl => _householdImageUrl;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  LeadConversion.map(dynamic object) {
    this._id = object['id'];
    this._leadId = object['leadid'];
    this._dateOfConversion = object['dateofconv'];
    this._mobileMoneyCode = object['mobilemoneycode'];
    this._payerFirstName = object['payeefname'];
    this._payerLastName = object['payeelname'];
    this._relationship = object['relationship'];
    this._payerPrimaryTelephone = object['payeepritele'];
    this._payerSecondaryTelephone = object['payeesectele'];
    this._payerOccupation = object['payeeoccupation'];
    this._paymentMethod = object['paymentmethod'];
    this._createdBy = object['createdby'];
    this._householdSavings = object['householdsavings'];
    this._primaryOccupation = object['prioccupation'];
    this._secondaryOccupation = object['secoccupation'];
    this._homeOwnership = object['homeownership'];
    this._customerImageUrl = object['customerimageurl'];
    this._landmarkImageUrl = object['landmarkimageurl'];
    this._householdImageUrl = object['householdimageurl'];
    this._status = object['status'];
    this._createdAt = object['created_at'];
    this._updatedAt = object['updated_at'];
  }

  LeadConversion.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._leadId = map['leadid'];
    this._dateOfConversion = map['dateofconv'];
    this._mobileMoneyCode = map['mobilemoneycode'];
    this._payerFirstName = map['payeefname'];
    this._payerLastName = map['payeelname'];
    this._relationship = map['relationship'];
    this._payerPrimaryTelephone = map['payeepritele'];
    this._payerSecondaryTelephone = map['payeesectele'];
    this._payerOccupation = map['payeeoccupation'];
    this._paymentMethod = map['paymentmethod'];
    this._createdBy = map['createdby'];
    this._householdSavings = map['householdsavings'];
    this._primaryOccupation = map['prioccupation'];
    this._secondaryOccupation = map['secoccupation'];
    this._homeOwnership = map['homeownership'];
    this._customerImageUrl = map['customerimageurl'];
    this._landmarkImageUrl = map['landmarkimageurl'];
    this._householdImageUrl = map['householdimageurl'];
    this._status = map['status'];
    this._createdAt = map['created_at'];
    this._updatedAt = map['updated_at'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['leadid'] = _leadId;
    map['dateofconv'] = _dateOfConversion;
    map['mobilemoneycode'] = _mobileMoneyCode;
    map['payeefname'] = _payerFirstName;
    map['payeelname'] = _payerLastName;
    map['relationship'] = _relationship;
    map['payeepritele'] = _payerPrimaryTelephone;
    map['payeesectele'] = _payerSecondaryTelephone;
    map['payeeoccupation'] = _payerSecondaryTelephone;
    map['paymentmethod'] = _paymentMethod;
    map['createdby'] =_createdBy;
    map['householdsavings'] =_householdSavings;
    map['prioccupation'] =_primaryOccupation;
    map['secoccupation'] = _secondaryOccupation;
    map['homeownership'] = _homeOwnership;
    map['customerimageurl'] = _customerImageUrl;
    map['landmarkimageurl'] = _landmarkImageUrl;
    map['householdimageurl'] = _householdImageUrl;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;

    return map;
  }

  Map<String, dynamic> toApiMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['leadid'] = _leadId;
    map['dateofconv'] = _dateOfConversion;
    map['mobilemoneycode'] = _mobileMoneyCode;
    map['payeefname'] = _payerFirstName;
    map['payeelname'] = _payerLastName;
    map['relationship'] = _relationship;
    map['payeepritele'] = _payerPrimaryTelephone;
    map['payeesectele'] = _payerSecondaryTelephone;
    map['payeeoccupation'] = _payerSecondaryTelephone;
    map['paymentmethod'] = _paymentMethod;
    map['createdby'] =_createdBy;
    map['householdsavings'] =_householdSavings;
    map['prioccupation'] =_primaryOccupation;
    map['secoccupation'] = _secondaryOccupation;
    map['homeownership'] = _homeOwnership;
    map['customerimageurl'] = _customerImageUrl;
    map['landmarkimageurl'] = _landmarkImageUrl;
    map['householdimageurl'] = _householdImageUrl;
    map['device'] = 'mobile';

    return map;
  }

}