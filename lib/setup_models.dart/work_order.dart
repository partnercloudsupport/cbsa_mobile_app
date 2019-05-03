class WorkOrder {
  int _id;
  int _workOrderId;
  String _name;
  String _description;
  int _toiletTypeId;
  int _status;
  String _qrCode;
  String _imageURL;
  int _createdBy;
  String _createdAt;
  String _updatedAt;

  WorkOrder(this._workOrderId, this._name, this._description, this._toiletTypeId, this._status, 
  this._qrCode, this._imageURL, this._createdBy, this._createdAt, this._updatedAt);

  // Getters
  int get id => _id;
  int get workOrderId => _workOrderId;
  String get name => _name;
  String get description => _description;
  int get toiletTypeId => _toiletTypeId;
  int get status => _status;
  String get qrCode => _qrCode;
  String get imageURL => _imageURL;
  int get createdBy => _createdBy;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  WorkOrder.map(dynamic object) {
    this._workOrderId = object['id'];
    this._name = object['name'];
    this._description = object['description'];
    this._toiletTypeId = object['toilettypeid'];
    this._status = object['status'];
    this._qrCode = object['qrcode'];
    this._imageURL = object['imageurl'];
    this._createdBy = object['created_by'];
    this._createdAt = object['created_at'];
    this._updatedAt = object['updated_at'];
  }

  WorkOrder.fromMap(Map<String, dynamic> map) {
    this._workOrderId = map['id'];
    this._name = map['name'];
    this._description = map['description'];
    this._toiletTypeId = map['toilettypeid'];
    this._status = map['status'];
    this._qrCode = map['qrcode'];
    this._imageURL = map['imageurl'];
    this._createdBy = map['created_by'];
    this._createdAt = map['created_at'];
    this._updatedAt = map['updated_at'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(_id != null) {
      map['id'] = _id;
    }

    map['work_order_id'] = this._workOrderId;
    map['name'] = this._name;
    map['description'] = this.description;
    map['toilet_type_id'] = this._toiletTypeId;
    map['status'] = this._status;
    map['qr_code'] = this._qrCode;
    map['image_url'] = this._imageURL;
    map['created_by'] = this._createdBy;
    map['created_at'] = this._createdAt;
    map['updated_at'] = this._updatedAt;

    return map;
  }
}