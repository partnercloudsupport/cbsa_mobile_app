class DirectOrder {
  int _id;
  String _firstName;
  String _lastName;
  String _otherNames;
  int _territory;
  int _subTerritory;
  int _block;
  String _gender;
  String _disability;
  String _infoSourceSelected;
  String _referredBy;
  int _toiletType;
  int _noOfToilets;
  int _noOfMaleAdults;
  int _noOfFemaleAdults;
  int _noOfMaleChildren;
  int _noOfFemaleChildren;
  String _primaryTelephone;
  String _secondaryTelephone;
  String _address;
  double _latitude;
  double _longitude;
  int _leadType;
  int _telephoneType;
  int _serviceProvider;
  String _servicesSelected;
  String _privacySelected;
  String _typeSelected;
  String _securitySelected;
  String _salariedWorker;
  String _paymentDate;
  String _reasonsSelected;
  String _householdSavings;
  String _primaryOccupation;
  String _secondaryOccupation;
  String _homeOwnership;
  String _customerImageUrl;
  String _householdImageUrl;
  String _landmarkImageUrl;
  String _mobileMoneyCode;
  String _payerFirstName;
  String _payerLastName;
  String _relationship;
  String _payerPrimaryTelephone;
  String _payerSecondaryTelephone;
  String _payerOccupation;
  String _paymentMethod;
  int _createdBy;
  String _createdAt;
  
  DirectOrder(this._firstName, this._lastName, this._otherNames, this._territory, this._subTerritory, this._block,
  this._gender, this._primaryTelephone, this._secondaryTelephone, this._referredBy, this._toiletType, this._noOfToilets,
  this._noOfMaleAdults, this._noOfFemaleAdults, this._noOfMaleChildren, this._noOfFemaleChildren, this._latitude, this._longitude,
  this._infoSourceSelected, this._leadType, this._disability, this._reasonsSelected, this._householdSavings, this._primaryOccupation,
  this._secondaryOccupation, this._homeOwnership, this._customerImageUrl, this._householdImageUrl, this._landmarkImageUrl,
  this._mobileMoneyCode, this._payerFirstName, this._payerLastName, this._relationship, this._payerPrimaryTelephone, this._payerSecondaryTelephone,
  this._payerOccupation, this._paymentMethod, this._createdBy,
  this._serviceProvider, this._telephoneType, this._salariedWorker, this._paymentDate, this._servicesSelected, this._typeSelected,
  this._securitySelected, this._privacySelected, this._address, this._createdAt);

  DirectOrder.empty();

  // Setters
  void setId(int id) {
    this._id = id;
  }

  // Getters
  int get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get otherNames => _otherNames;
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
  int get createdBy => _createdBy;
  int get serviceProvider => _serviceProvider;
  int get telephoneType => _telephoneType;
  String get salariedWorker => _salariedWorker;
  String get paymentDate => _paymentDate;
  String get servicesSelected =>_servicesSelected;
  String get typeSelected => _typeSelected;
  String get securitySelected => _securitySelected;
  String get privacySelected => _privacySelected;
  String get householdSavings => _householdSavings;
  String get primaryOccupation => _primaryOccupation;
  String get secondaryOccupation => _secondaryOccupation;
  String get homeOwnership => _homeOwnership;
  String get customerImageUrl => _customerImageUrl;
  String get householdImageUrl => _householdImageUrl;
  String get landmarkImageUrl => _landmarkImageUrl;
  String get mobileMoneyCode => _mobileMoneyCode;
  String get payerFirstName => _payerFirstName;
  String get payerLastName => _payerLastName;
  String get relationship => _relationship;
  String get payerPrimaryTelephone => _payerPrimaryTelephone;
  String get payerSecondaryTelephone => _payerSecondaryTelephone;
  String get payerOccupation => _payerOccupation;
  String get paymentMethod => _paymentMethod;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['firstName'] =  _firstName;
    map['lastName'] =  _lastName;
    map['otherNames'] =  _otherNames;
    map['territory'] =  _territory;
    map['subTerritory'] =  _subTerritory;
    map['blocks'] =  _block;
    map['gender'] =  _gender;
    map['disability'] =  _disability;
    map['sourceOfInfo'] =  _infoSourceSelected;
    map['referredby'] =  _referredBy;
    map['toiletType'] =  _toiletType;
    map['numberOfToilets'] =  _noOfToilets;
    map['numOfMalesServedByToilet'] =  _noOfMaleAdults;
    map['numOfFemalesServedByToilet'] =  _noOfFemaleAdults;
    map['numOfBoysServedByToilet'] =  _noOfMaleChildren;
    map['numOfGirlsServedByToilet'] =  _noOfFemaleChildren;
    map['primaryTelephone'] =  _primaryTelephone;
    map['secondaryTelephone'] =  _secondaryTelephone;
    map['address'] =  _address;
    map['latitude'] =  _latitude;
    map['longitude'] =  _longitude;
    map['leadtype'] =  _leadType;
    map['telephoneType'] =  _telephoneType;
    map['telephoneServiceProvider'] =  _serviceProvider;
    map['otherPaidServices'] =  _servicesSelected;
    map['accessToiletPrivacy'] =  _privacySelected;
    map['accessToiletType'] =  _typeSelected;
    map['toileaccessToiletSecurity'] =  _securitySelected;
    map['salaryWorker'] =  _salariedWorker;
    map['payDay'] =  _paymentDate;
    map['reasonForEnrollment'] =  _reasonsSelected;
    map['houseHoldSavings'] = _householdSavings;
    map['primaryOccupation'] = _primaryOccupation;
    map['secondaryOccupation'] = _secondaryOccupation;
    map['homeOwnership'] = _homeOwnership;
    map['customerImage'] = _customerImageUrl;
    map['householdImage'] = _householdImageUrl;
    map['landmarkImage'] = _landmarkImageUrl;
    map['mobileMoneyCode'] = _mobileMoneyCode;
    map['payerFirstName'] = _payerFirstName;
    map['payerLastName'] = _payerLastName;
    map['relationship'] = _relationship;
    map['payerPrimaryTelephone'] = _payerPrimaryTelephone;
    map['payerSecondaryTelephone'] = _payerSecondaryTelephone;
    map['payerOccupation'] = _payerOccupation;
    map['paymentMethod'] = _paymentMethod;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;
    map['device'] = 'mobile';

    return map;
  }

  Map<String, dynamic> toApiMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['firstName'] =  _firstName;
    map['lastName'] =  _lastName;
    map['otherNames'] =  _otherNames;
    map['territory'] =  _territory;
    map['subTerritory'] =  _subTerritory;
    map['blocks'] =  _block;
    map['gender'] =  _gender;
    map['disability'] =  _disability;
    map['sourceOfInfo'] =  _infoSourceSelected;
    map['referredby'] =  _referredBy;
    map['toiletType'] =  _toiletType;
    map['numberOfToilets'] =  _noOfToilets;
    map['numOfMalesServedByToilet'] =  _noOfMaleAdults;
    map['numOfFemalesServedByToilet'] =  _noOfFemaleAdults;
    map['numOfBoysServedByToilet'] =  _noOfMaleChildren;
    map['numOfGirlsServedByToilet'] =  _noOfFemaleChildren;
    map['primaryTelephone'] =  _primaryTelephone;
    map['secondaryTelephone'] =  _secondaryTelephone;
    map['address'] =  _address;
    map['latitude'] =  _latitude;
    map['longitude'] =  _longitude;
    map['leadtype'] =  _leadType;
    map['telephoneType'] =  _telephoneType;
    map['telephoneServiceProvider'] =  _serviceProvider;
    map['otherPaidServices'] =  _servicesSelected;
    map['accessToiletPrivacy'] =  _privacySelected;
    map['accessToiletType'] =  _typeSelected;
    map['toileaccessToiletSecurity'] =  _securitySelected;
    map['salaryWorker'] =  _salariedWorker;
    map['payDay'] =  _paymentDate;
    map['reasonForEnrollment'] =  _reasonsSelected;
    map['houseHoldSavings'] = _householdSavings;
    map['primaryOccupation'] = _primaryOccupation;
    map['secondaryOccupation'] = _secondaryOccupation;
    map['homeOwnership'] = _homeOwnership;
    map['customerImage'] = _customerImageUrl;
    map['householdImage'] = _householdImageUrl;
    map['landmarkImage'] = _landmarkImageUrl;
    map['mobileMoneyCode'] = _mobileMoneyCode;
    map['payerFirstName'] = _payerFirstName;
    map['payerLastName'] = _payerLastName;
    map['relationship'] = _relationship;
    map['payerPrimaryTelephone'] = _payerPrimaryTelephone;
    map['payerSecondaryTelephone'] = _payerSecondaryTelephone;
    map['payerOccupation'] = _payerOccupation;
    map['paymentMethod'] = _paymentMethod;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;
    map['device'] = 'mobile';

    return map;
  }
}

