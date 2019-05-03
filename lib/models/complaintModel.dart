class Complaint{
  int _id;
  int _customerid;
  int _complainttypeid;
  String _complain;
  String _comment;
  int _created_by;
  int _escalatedto;
  int _status;
  String _reaction;
  String _created_at;
  String _updated_at;


  Complaint(this._customerid,this._complainttypeid,this._complain,this._comment,this._created_by);

  int get id => _id;
  int get customerid => _customerid;
  int get complainttypeid=> _complainttypeid;
  String get complain => _complain;
  String get comment => _comment;
  int get created_by => _created_by;

  Complaint.fromMap(Map<String, dynamic> json) {
    _id = json['id'];
    _customerid = json['customerid'];
    _complainttypeid = json['complaintypeid'];
    _escalatedto = json['escalatedto'];
    _status = json['status'];
    _created_by = json['created_by'];
    _complain = json['complain'];
    _comment = json['comment'];
    _reaction = json['reaction'];
    _created_at = json['created_at'];
    _updated_at = json['updated_at'];
  }

  Map<String, dynamic> toRemoteMap() {
    var map = new Map<String, dynamic>();
    map['customerid'] = _customerid;
    map['complaintypeid'] = _complainttypeid;
    map['complain'] = _complain;
    map['comment'] = _comment;
    map['created_by'] = _created_by;
    return map;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['customerid'] = this._customerid;
    data['complaintypeid'] = this._complainttypeid;
    data['escalatedto'] = this._escalatedto;
    data['status'] = this._status;
    data['created_by'] = this._created_by;
    data['complain'] = this._complain;
    data['comment'] = this._comment;
    data['reaction'] = this._reaction;
    data['created_at'] = this._created_at;
    data['updated_at'] = this._updated_at;
    return data;
  }
}