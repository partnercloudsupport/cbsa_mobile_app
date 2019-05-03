class Setups {
  int _id;
  String _firstName;
  String _lastName;
  String _organizationName;
  String _language;
  String _subDomain;
  
  Setups(this._firstName, this._lastName, this._organizationName, this._language, this._subDomain);

  Setups.map(dynamic obj) {
    this._firstName = obj['firstName'];
    this._lastName = obj['lastName'];
    this._organizationName = obj['organizationName'];
    this._language = obj['language'];
    this._subDomain = obj['subDomain'];
  }
 
  int get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get organizationName => _organizationName;
  String get language => _language;
  String get subDomain => _subDomain;
 
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['organizationName'] = _organizationName;
    map['language'] = _language;
    map['subDomain'] = _subDomain;

    return map;
  }
 
  Setups.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._firstName = map['firstName'];
    this._lastName = map['lastName'];
    this._organizationName = map['organizationName'];
    this._language = map['language'];
    this._subDomain = map['subDomain'];
  }
}