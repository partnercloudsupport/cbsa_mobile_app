class ToiletInstallationModel {
  int _id;
  int _leadId;
  int _userId;
  String _toiletInstallationDate;
  String _qrCode;
  String _serialNumber;
  String _items;
  String _toiletImage;
  int _workOrderId;

  ToiletInstallationModel(this._leadId, this._userId, this._toiletInstallationDate, this._qrCode, this._serialNumber, this._items, this._toiletImage, this._workOrderId);

  void setId(int id) {
    this._id = id;
  }

  int get id => _id;
  int get leadId => _leadId;
  int get userId => _userId;
  String get toiletInstallationDate => _toiletInstallationDate;
  String get qrCode => _qrCode;
  String get serialNumber => _serialNumber;
  String get items => _items;
  String get toiletImage => _toiletImage;
  int get workOrderId => _workOrderId;

  ToiletInstallationModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._leadId = map['leadid'];
    this._userId = map['userid'];
    this._toiletInstallationDate = map['date'];
    this._qrCode = map['qrcode'];
    this._serialNumber = map['serialno'];
    this._items = map['items'];
    this._toiletImage = map['toiletimage'];
    this._workOrderId = map['workOrderId'];
  }

  ToiletInstallationModel.map(dynamic object) {
    this._id = object['id'];
    this._leadId = object['leadid'];
    this._userId = object['userid'];
    this._toiletInstallationDate = object['date'];
    this._qrCode = object['qrcode'];
    this._serialNumber = object['serialno'];
    this._items = object['items'];
    this._toiletImage = object['toiletimage'];
    this._workOrderId = object['workOrderId'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic> ();

    if(_id != null) {
      map['id'] = _id;
    }
    map['leadid'] = _leadId;
    map['userid'] = _userId;
    map['date'] = _toiletInstallationDate;
    map['qrcode'] = _qrCode;
    map['serialno'] = _serialNumber;
    map['items'] = _items;
    map['toiletimage'] = _toiletImage;
    map['workOrderId'] = _workOrderId;

    return map;
  }

  Map<String, dynamic> toApiMap() {
    var map = Map<String, dynamic> ();

    if(_id != null) {
      map['id'] = _id;
    }
    map['leadid'] = _leadId;
    map['userid'] = _userId;
    map['date'] = _toiletInstallationDate;
    map['qrcode'] = _qrCode;
    map['serialno'] = _serialNumber;
    map['items'] = _items;
    map['toiletimage'] = _toiletImage;
    map['workOrderId'] = _workOrderId;
    map['device'] = 'mobile';

    return map;
  }
}