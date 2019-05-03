class EnrollmentReason {
  int _id;
  int _enrollmentReasonId;
  String _name;
  String _description;
  int _status;
  int _createdBy;
  int _updatedBy;
  String _createdAt;
  String _updatedAt;

  EnrollmentReason(this._enrollmentReasonId, this._name, this._description, this._status, this._createdBy, this._updatedBy, this._createdAt, this._updatedAt);

  // Getters
  int get id => _id;
  int get blockId => _enrollmentReasonId;
  String get name => _name;
  String get description => _description;
  int get status => _status;
  int get createdBy => _createdBy;
  int get modifiedBy => _updatedBy;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  EnrollmentReason.map(dynamic object) {
    this._enrollmentReasonId = object['id'];
    this._name = object['name'];
    this._description = object['description'];
    this._status = object['status'];
    this._createdBy = object['created_by'];
    this._updatedBy = object['updated_by'];
    this._createdAt = object['created_at'];
    this._updatedAt = object['updated_at'];
  }

  EnrollmentReason.fromMap(Map<String, dynamic> map) {
    this._enrollmentReasonId = map['id'];
    this._name = map['name'];
    this._description = map['description'];
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

    map['enrollment_reason_id'] = this._enrollmentReasonId;
    map['name'] = this._name;
    map['description'] = this.description;
    map['status'] = this._status;
    map['created_by'] = this._createdBy;
    map['updated_by'] = this._updatedBy;
    map['created_at'] = this._createdAt;
    map['updated_at'] = this._updatedAt;

    return map;
  }
}