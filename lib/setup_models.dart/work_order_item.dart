class WorkOrderItem {
  int _id;
  int _workOrderItemId;
  int _workOrderId;
  int _itemId;
  int _quantity;
  int _status;
  String _createdAt;
  String _updatedAt;

  WorkOrderItem(this._workOrderItemId, this._workOrderId, this._itemId, this._quantity, this._status,
  this._createdAt, this._updatedAt);

  // Getters
  int get id => _id;
  int get workOrderItemId => _workOrderItemId;
  int get workOrderId => _workOrderId;
  int get itemId => _itemId;
  int get quantity => _quantity;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  WorkOrderItem.map(dynamic object) {
    this._workOrderItemId = object['id'];
    this._workOrderId = object['workorderid'];
    this._itemId = object['item_id'];
    this._quantity = object['quantity'];
    this._status = object['status'];
    this._createdAt = object['created_at'];
    this._updatedAt = object['updated_at'];
  }

  WorkOrderItem.fromMap(Map<String, dynamic> map) {
    this._workOrderItemId = map['id'];
    this._workOrderId = map['workorderid'];
    this._itemId = map['item_id'];
    this._quantity = map['quantity'];
    this._status = map['status'];
    this._createdAt = map['created_at'];
    this._updatedAt = map['updated_at'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(_id != null) {
      map['id'] = _id;
    }

    map['work_order_item_id'] = this._workOrderItemId;
    map['work_order_id'] = this._workOrderId;
    map['item_id'] = this._itemId;
    map['quantity'] = this._quantity;
    map['status'] = this._status;
    map['created_at'] = this._createdAt;
    map['updated_at'] = this._updatedAt;

    return map;
  }
}