class SubTerritory {
  int _id;
  int _subTerritoryId;
  int _territoryId;
  String _name;
  String _description;
  int _status;
  int _createdBy;
  int _updatedBy;
  String _createdAt;
  String _updatedAt;

  SubTerritory(this._subTerritoryId, this._territoryId, this._name, this._description, this._status, this._createdBy, this._updatedBy, this._createdAt, this._updatedAt);
  SubTerritory.empty();

  // Getters
  int get id => _id;
  int get subTerritoryId => _subTerritoryId;
  int get territoryId => _territoryId;
  String get name => _name;
  String get description => _description;
  int get status => _status;
  int get createdBy => _createdBy;
  int get modifiedBy => _updatedBy;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  SubTerritory.map(dynamic object) {
    this._subTerritoryId = object['id'];
    this._territoryId = object['territory_id'];
    this._name = object['name'];
    this._description = object['description'];
    this._status = object['status'];
    this._createdBy = object['created_by'];
    this._updatedBy = object['updated_by'];
    this._createdAt = object['created_at'];
    this._updatedAt = object['updated_at'];
  }

  SubTerritory.fromMap(Map<String, dynamic> map) {
    this._subTerritoryId = map['id'];
    this._territoryId = map['territory_id'];
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

    map['subterritory_id'] = this._subTerritoryId;
    map['territory_id'] = this._territoryId;
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