class Order {
  int _id;
  int _leadId;
  String _type;
  String _inspectionDate;
  String _installationDate;
  int _status;
  String _accountNumber;
  int _createdBy;
  String _createdAt;
  String _updatedAt;

  Order(this._leadId, this._type, this._inspectionDate, this._installationDate, 
    this._status, this._accountNumber, this._createdBy, this._createdAt, this._updatedAt);

  Order.empty();

  // Getters
  int get id => _id;
  int get leadId => _leadId;
  String get type => _type;
  String get inspectionDate => _inspectionDate;
  String get installationDate => _installationDate;
  int get status => _status;
  String get accountNumber => _accountNumber;
  int get createdBy => _createdBy;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Order.map(dynamic object) {
    this._id = object['id'];
    this._leadId = object['leadid'];
    this._type = object['type'];
    this._inspectionDate = object['inspectiondate'];
    this._installationDate = object['installationdate'];
    this._status = object['status'];
    this._accountNumber = object['accountnumber'].toString();
    this._createdBy = object['createdby'];
    this._createdAt = object['created_at'];
    this._updatedAt = object['updated_at'];
  }

  Order.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._leadId = map['leadid'];
    this._type = map['type'];
    this._inspectionDate = map['inspectiondate'].toString();
    this._installationDate = map['installationdate'].toString();
    this._status = map['status'];
    this._accountNumber = map['accountnumber'];
    this._createdBy = map['createdby'];
    this._createdAt = map['created_at'].toString();
    this._updatedAt = map['updated_at'].toString();
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }

    map['leadid'] = this._leadId;
    map['type'] = this._type;
    map['inspectiondate'] = this._inspectionDate;
    map['installationdate'] = this._installationDate;
    map['status'] = this._status;
    map['accountnumber'] = this._accountNumber;
    map['createdby'] = this._createdBy;
    map['created_at'] = this._createdAt;
    map['updated_at'] = this._updatedAt;

    return map;
  }
}