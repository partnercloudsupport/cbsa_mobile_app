class User {
  int _id;
  int _userId;
  String _username;
  String _email;
  String _password;
  String _token;

  User(this._userId,this._username,this._email,this._password,this._token);

  User.map(dynamic obj) {
    this._userId = obj['userId'];
    this._username = obj['username'];
    this._email = obj['email'];
    this._password = obj['password'];
    this._token = obj['token'];
  }
 
  int get id => _id;
  int get userId => _userId;
  String get username => _username;
  String get email => _email;
  String get password => _password;
  String get token => _token;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['userId'] = _userId;
    map['username'] = _username;
    map['email'] = _email;
    map['password'] = _password;
    map['token'] = _token;

    return map;
  }
 
  User.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._userId = map['userId'];
    this._username = map['username'];
    this._email = map['email'];
    this._password = map['password'];
    this._token = map['token'];
  }
}