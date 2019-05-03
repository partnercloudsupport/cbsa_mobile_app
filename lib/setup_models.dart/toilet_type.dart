class ToiletType {
  int _id;
  int _toiletTypeId;
  String _name;
  String _description;
  int _unitPrice;
  int _status;
  int _createdBy;
  int _updatedBy;
  String _createdAt;
  String _updatedAt;

  ToiletType(this._toiletTypeId, this._name, this._description, this._unitPrice, this._status, this._createdBy, this._updatedBy, this._createdAt, this._updatedAt);
  ToiletType.empty();

  // Getters
  int get id => _id;
  int get toiletTypeId => _toiletTypeId;
  String get name => _name;
  String get description => _description;
  int get unitPrice => _unitPrice;
  int get status => _status;
  int get createdBy => _createdBy;
  int get modifiedBy => _updatedBy;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  ToiletType.map(dynamic object) {
    this._toiletTypeId = object['id'];
    this._name = object['name'];
    this._description = object['description'];
    this._unitPrice = object['unitPrice'];
    this._status = object['status'];
    this._createdBy = object['created_by'];
    this._updatedBy = object['updated_by'];
    this._createdAt = object['created_at'];
    this._updatedAt = object['updated_at'];
  }

  ToiletType.fromMap(Map<String, dynamic> map) {
    this._toiletTypeId = map['id'];
    this._name = map['name'];
    this._description = map['description'];
    this._unitPrice = map['unitPrice'];
    this._status = map['status'];
    this._createdBy = map['created_by'];
    this._updatedBy = map['updated_by'];
    this._createdAt = map['created_at'];
    this._updatedAt = map['updated_at'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(_id != null) {
      map['id'] = _id;
    }

    map['toilet_type_id'] = this._toiletTypeId;
    map['name'] = this._name;
    map['description'] = this.description;
    map['unitPrice'] = this._unitPrice;
    map['status'] = this._status;
    map['created_by'] = this._createdBy;
    map['updated_by'] = this._updatedBy;
    map['created_at'] = this._createdAt;
    map['updated_at'] = this._updatedAt;

    return map;
  }
}