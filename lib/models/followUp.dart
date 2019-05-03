class FollowUps {
  int _id;
  int _leadid;
  String _wasleadreached;
  int _createdby;
  int _assignedto; //
  int _ispresent;
  String _type;
  String _folupdate;
  String _isinterested;
  String _comment;
  String _paystate;
  String _spacepreparestate; //
  String _isspaceprepared;
  String _created_at;
  String _updated_at;
  String _inspectiondate;
  String _installdate;

  FollowUps(this._leadid,this._wasleadreached,this._type,
  this._folupdate,this._isinterested,this._comment,this._paystate,this._isspaceprepared,this._inspectiondate,this._installdate);

  setId(int id){
    this._id=id;
  }

  setFollowupDate(String followupdate){
    this._folupdate = followupdate;
  }

  void setRescheduleDate(String value){
    this._folupdate=value;
  }

  FollowUps.map(dynamic obj) {
    this._id = obj['id'];
    this._leadid = obj['leadid'];
    this._wasleadreached = obj['wasleadreached'];
    this._createdby = obj['createdby'];
    this._assignedto = obj['assignedto'];
    this._ispresent = obj['ispresent'];
    this._type = obj['type'];
    this._folupdate = obj['folupdate'];
    this._isinterested = obj['isinterested'];
    this._comment = obj['comment'];
    this._paystate = obj['paystate'];
    this._spacepreparestate = obj['spacepreparestate'];
    this._isspaceprepared = obj['isspaceprepared'];
    this._created_at = obj['created_at'];
    this._updated_at = obj['updated_at'];
    this._inspectiondate = obj['inspectiondate'];
    this._installdate = obj['installdate'];
  }
 
  int get id => _id;
  int get leadid => _leadid;
  String get wasleadreached => _wasleadreached;
  int get createdby => _createdby;
  int get assignedto => _assignedto;
  int get ispresent => _ispresent;
  String get type => _type;
  String get folupdate => _folupdate;
  String get isinterested => _isinterested;
  String get comment =>_comment;
  String get paystate => _paystate;
  String get spacepreparestate => _spacepreparestate;
  String get created_at => _created_at;
  String get updated_at => _updated_at;
  String get inspectiondate => _inspectiondate;
  String get installationdate => _installdate;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['leadid'] = _leadid;
    map['wasleadreached'] =_wasleadreached;
    map['createdby'] = _createdby;
    map['assignedto'] =_assignedto;
    map['ispresent'] = _ispresent;
    map['type'] = _type;
    map['folupdate'] = _folupdate;
    map['isinterested'] = _isinterested;
    map['comment'] = _comment;
    map['paystate'] =_paystate;
    map['spacepreparestate'] =_spacepreparestate;
    map['isspaceprepared'] =_isspaceprepared;
    map['created_at'] = _created_at;
    map['updated_at'] =_updated_at;
    map['inspectiondate'] =_inspectiondate;
    map['installdate'] =_installdate;
    return map;
  }
 
  FollowUps.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._leadid = map['leadid'];
    this._wasleadreached = map['wasleadreached'];
    // this._assignedto = map['assignedto'];
    // this._ispresent = map['ispresent'];
    this._type = map['type'];
    this._folupdate = map['folupdate'];
    this._isinterested = map['isinterested'];
    // this._comment = map['comment'];
    this._paystate = map['paystate'];
    // this._spacepreparestate = map['spacepreparestate'];
    this._isspaceprepared = map['isspaceprepared'];
    this._created_at = map['created_at'];
    this._updated_at = map['updated_at'];
    // this._inspectiondate = map['inspectiondate'];
    // this._installdate = map['installdate'];
  }
}