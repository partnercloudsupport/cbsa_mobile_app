class Block {
  int _id;
  int _blockId;
  int _subTerritoryId;
  String _name;
  String _description;
  int _status;
  int _createdBy;
  int _updatedBy;
  String _createdAt;
  String _updatedAt;

  Block(this._blockId, this._subTerritoryId, this._name, this._description, this._status, this._createdBy, this._updatedBy, this._createdAt, this._updatedAt);
  Block.empty();

  // Getters
  int get id => _id;
  int get blockId => _blockId;
  int get subTerritoryId => _subTerritoryId;
  String get name => _name;
  String get description => _description;
  int get status => _status;
  int get createdBy => _createdBy;
  int get modifiedBy => _updatedBy;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Block.map(dynamic object) {
    this._blockId = object['id'];
    this._subTerritoryId = object['subterritory_id'];
    this._name = object['name'];
    this._description = object['description'];
    this._status = object['status'];
    this._createdBy = object['created_by'];
    this._updatedBy = object['updated_by'];
    this._createdAt = object['created_at'];
    this._updatedAt = object['updated_at'];
  }

  Block.fromMap(Map<String, dynamic> map) {
    this._blockId = map['id'];
    this._subTerritoryId = map['subterritory_id'];
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

    map['block_id'] = this._blockId;
    map['subterritory_id'] = this._subTerritoryId;
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