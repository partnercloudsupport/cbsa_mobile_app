class HealthInspectionSchedule {
  int _id;
  int _subTerritoryId;
  int _assignedTo;
  String _repetitive;
  String _interval;
  String _inspectionDay;
  String _startDate;
  String _createdAt;
  String _updatedAt;

  HealthInspectionSchedule(this._subTerritoryId, this._assignedTo, this._repetitive, this._interval,
  this._inspectionDay, this._startDate, this._createdAt, this._updatedAt);

  // Getters
  int get id => _id;
  int get subTerritoryId => _subTerritoryId;
  int get assignedTo => _assignedTo;
  String get repetitve => _repetitive;
  String get interval => _interval;
  String get inspectionDay => _inspectionDay;
  String get startDate => _startDate;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  HealthInspectionSchedule.map(dynamic object) {
    this._id = object['id'];
    this._subTerritoryId = object['subterritoyid'];
    this._assignedTo = object['assignedto'];
    this._repetitive = object['repetitive'];
    this._interval = object['duration'];
    this._inspectionDay = object['inspedays'];
    this._startDate = object['startdate'];
    this._createdAt = object['created_at'];
    this._updatedAt = object['updated_at'];
  }

  HealthInspectionSchedule.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._subTerritoryId = map['subterritory_id'];
    this._assignedTo = map['assigned_to'];
    this._repetitive = map['repetitive'];
    this._interval = map['interval'];
    this._inspectionDay = map['inspection_day'];
    this._startDate = map['start_date'];
    this._createdAt = map['created_at'];
    this._updatedAt = map['updated_at'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(_id != null) {
      map['id'] = _id;
    }

    map['subterritory_id'] = this._subTerritoryId;
    map['assigned_to'] = this._assignedTo;
    map['repetitive'] = this._repetitive;
    map['interval'] = this._interval;
    map['inspection_day'] = this._inspectionDay;
    map['start_date'] = this._startDate;
    map['created_at'] = this._createdAt;
    map['updated_at'] = this._updatedAt;

    return map; 
  }
}