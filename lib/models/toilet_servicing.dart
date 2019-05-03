class ToiletServicingModel{
  String _qrcode;
  String _servicedon=DateTime.now().toString();
  int _servicedby;

  ToiletServicingModel(this._qrcode,this._servicedby);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['qrcode'] = _qrcode;
    map['servicedon'] = _servicedon;
    map['servicedby'] = _servicedby;
    return map;
  }
}

class ServiceInterruption{
  int _customerid;
  int _createdby;
  int _interruptionid;
  String _reportedon;

  ServiceInterruption(this._customerid,this._createdby,this._interruptionid);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['customerid'] = _customerid;
    map['createdby'] = _createdby;
    map['interruptionid'] = _interruptionid;
    map['reportedon'] = DateTime.now().toString();
    return map;
  }
}

class AdhocServicingModel{
  String _qrcode;
  String _requestedon=DateTime.now().toString();
  int _createdby;

  AdhocServicingModel(this._qrcode,this._createdby);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['qrcode'] = _qrcode;
    map['requestedon'] = _requestedon;
    map['createdby'] = _createdby;
    return map;
  }
}

class BarrelCountModel{
  int _numofbarrels;
  int _emptyreturned;
  int _emptyfilled;
  int _wastecolid;
  int _userid;
  int _id;
  int _serverid;
  String _recordedon = DateTime.now().toString();

  BarrelCountModel(this._id,this._userid,this._numofbarrels,this._emptyreturned,this._emptyfilled,this._wastecolid);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['userid'] = _userid;
    map['numofbarrels'] = _numofbarrels;
    map['emptyreturned'] = _emptyreturned;
    map['emptyfilled'] = _emptyfilled;
    map['recordedon'] = _recordedon;
    map['wastecolid'] = _wastecolid;
    map['serverid']=_serverid;
    return map;
  }

  setServerId(int id){
    this._serverid=id;
  }

  int get noofbarrels => _numofbarrels;
  int get nooffullbarrels => _emptyfilled;
  int get noofemptybarrels => _emptyreturned;
  int get id => _id;
  int get wastecolid => _wastecolid;
  int get serverid => _serverid;

   BarrelCountModel.fromMap(Map<String, dynamic> map) {
    this._userid= map['userid'];
    this._wastecolid = map['wastecolid'];
    this._recordedon = map['recordedon'];
    this._numofbarrels = map['numofbarrels'];
    this._emptyreturned = map['emptyreturned'];
    this._emptyfilled = map['emptyfilled'];
    this._id=map['id'];
    this._serverid=map['id'];
  }
}
