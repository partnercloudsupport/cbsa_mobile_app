class Payment {
  int _id;
  int _customerId;
  String _accountId;
  String _dateOfPayment;
  String _amount;
  String _paymentType;

  Payment(this._customerId, this._accountId, this._dateOfPayment, this._amount, this._paymentType);

  int get id => _id;
  int get customerId => _customerId;
  String get accountID => _accountId;
  String get dateOfPayment => _dateOfPayment;
  String get amount => _amount;
  String get paymentType => _paymentType;

  Payment.map(dynamic object) {
    this._id = object['id'];
    this._customerId = object['customerId'];
    this._accountId = object['accountId'];
    this._dateOfPayment = object['dateOfPayment'];
    this._amount = object['amount'];
    this._paymentType = object['paymentType'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['customerId'] = this._customerId;
    map['accountId'] = this._accountId;
    map['dateOfPayment'] = this._dateOfPayment;
    map['amount'] = this._amount;
    map['paymentType'] = this._paymentType;

    return map;
  }
}