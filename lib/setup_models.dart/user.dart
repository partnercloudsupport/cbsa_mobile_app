class UserObject {
  int _id;
  int _userId;
  String _name;
  String _email;
  String _emailVerifiedAt;
  int _status;
  String _position;
  String _activationToken;
  String _createdAt;
  String _updatedAt;

  UserObject(this._userId, this._name, this._email, this._emailVerifiedAt, this._status, this._position, this._activationToken, this._createdAt, this._updatedAt);

  // Getters
  int get id => _id;
  int get userId => _userId;
  String get name => _name;
  String get email => _email;
  String get emailVerifiedAt => _emailVerifiedAt;
  int get status => _status;
  String get position => _position;
  String get activationToken => _activationToken;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  UserObject.map(dynamic object) {
    this._userId = object['id'];
    this._name = object['name'];
    this._email = object['email'];
    this._emailVerifiedAt = object['email_verified_at'];
    this._status = object['status'];
    this._position = object['position'];
    this._activationToken = object['activation_token'];
    this._createdAt = object['created_at'];
    this._updatedAt = object['updated_at'];
  }

  UserObject.fromMap(Map<String, dynamic> map) {
    this._userId = map['id'];
    this._name = map['name'];
    this._email = map['email'];
    this._emailVerifiedAt = map['email_verified_at'];
    this._status = map['status'];
    this._position = map['position'];
    this._activationToken = map['activation_token'];
    this._createdAt = map['created_at'];
    this._updatedAt = map['updated_at'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(_id != null)
      map['id'] = _id;

    map['user_id'] = this._userId;
    map['name'] = this._name;
    map['email'] = this._email;
    map['email_verified_at'] = this._emailVerifiedAt;
    map['status'] = this._status;
    map['position'] = this._position;
    map['activation_token'] = this._activationToken;
    map['created_at'] = this._createdAt;
    map['updated_at'] = this._updatedAt;

    return map;
  }
}