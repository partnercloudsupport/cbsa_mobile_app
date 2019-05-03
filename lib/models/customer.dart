class Customer {
  int _id;
  int _leadId;
  String _dateOfConversion;
  String _accountNumber;
  int _status;
  String _updatedAt;
  String _createdAt;

  Customer(this._leadId, this._dateOfConversion, this._accountNumber, this._status, this._updatedAt, this._createdAt);

  // Getters
  int get id => _id;
  int get leadId => _leadId;
  String get dateOfConversion => _dateOfConversion;
  String get accountNumber => _accountNumber;
  int get status => _status;
  String get updatedAt => _updatedAt;
  String get createdAt => _createdAt;

  Customer.map(dynamic object) {
    this._id = object['id'];
    this._leadId = object['leadid'];
    this._dateOfConversion = object['dateofconv'];
    this._accountNumber = object['accountnumber'];
    this._status = object['status'];
    this._updatedAt = object['updated_at'];
    this._createdAt = object['created_at'];
  }

  Customer.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._leadId = map['leadid'];
    this._dateOfConversion = map['dateofconv'];
    this._accountNumber = map['accountnumber'];
    this._status = map['status'];
    this._updatedAt = map['updated_at'];
    this._createdAt = map['created_at'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if(this._id != null) {
      map['id'] = this._id;
    }
    map['leadid'] = this._leadId;
    map['dateofconv'] = this._dateOfConversion;
    map['accountnumber'] = this._accountNumber;
    map['status'] = this._status;
    map['updated_at'] = this._updatedAt;
    map['created_at'] = this._createdAt;

    return map;
  }
}