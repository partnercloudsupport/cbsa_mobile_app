class HealthInspection {
  int _id;
  int _leadId;
  String _healthInspectionDate;
  String _status;

  HealthInspection(this._leadId, this._healthInspectionDate, this._status);

  // Setters
  void setId(int id) {
    this._id = id;
  }

  void setStatus(String status) {
    this._status = status;
  }

  // Getters
  int get id => _id;
  int get leadId => _leadId;
  String get healthInspectionDate => _healthInspectionDate;
  String get status => _status;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic> ();

    if(_id != null) {
      map['id'] = _id;
    }

    map['leadId'] = this._leadId;
    map['healthInspectionDate'] = this._healthInspectionDate;
    map['status'] =  this._status;

    return map;
  }

  HealthInspection.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._leadId = map['leadId'];
    this._healthInspectionDate = map['healthInspectionDate'];
    this._status = map['status'];
  }

  HealthInspection.map(dynamic object) {
    this._id = object['id'];
    this._leadId = object['leadId'];
    this._healthInspectionDate = object['healthInspectionDate'];
    this._status = object['status'];
  }
}