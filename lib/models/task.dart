import 'dart:convert';

class Tasks {
  int _id;
  // String _date;
  String _name;
  String _description;
  String _dueDate;
  int _status;
  // String _comments;
  int _assignedto;
  int _createdby;
  // String _taskStage;
  int _leadid;

  setId(int id){
    this._id=id;
  }
  
  Tasks(this._name,this._description,this._dueDate,this._assignedto,this._createdby,this._leadid);

  Tasks.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._description = obj['description'];
    this._dueDate = obj['duedate'];
    // this._status = obj['status'];
    this._assignedto = obj['assignedto'];
    // this._createdby = obj['createdby'];
    // this._leadid = obj['leadid'];
  }
 
  int get id => _id;
  String get name => _name;
  String get description => _description;
  String get duedate => _dueDate;
  int get status => _status;
  int get assignedto => _assignedto;
  int get createdby => _createdby;
  int get leadid => _leadid;
 
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['description'] = _description;
    map['duedate'] = _dueDate;
    map['status'] = _status;
    map['assignedto'] = _assignedto;
    map['createdby'] = _createdby;
    map['leadid'] = _leadid;
    return map;
  }
 
  Tasks.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._description = map['description'];
    this._dueDate = map['duedate'];
    this._status = map['status'];
    this._assignedto = map['assignedto'];
    this._createdby = map['createdby'];
    this._leadid = map['leadid'];
  }
}