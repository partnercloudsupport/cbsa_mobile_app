import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/sa_work_order.dart';
import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
import 'package:cbsa_mobile_app/screens/secondary_approval/sa_get_items_screen.dart';
import 'package:cbsa_mobile_app/setup_models.dart/item.dart';
import 'package:cbsa_mobile_app/setup_models.dart/territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/toilet_type.dart';
import 'package:cbsa_mobile_app/setup_models.dart/work_order.dart';
import 'package:cbsa_mobile_app/setup_models.dart/work_order_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class SAWorkOrderView extends StatefulWidget {
  final SAWorkOrderModel workOrder;

  const SAWorkOrderView({Key key, this.workOrder}) : super(key: key);

  @override
  _SAWorkOrderViewState createState() => _SAWorkOrderViewState();
}

class _SAWorkOrderViewState extends State<SAWorkOrderView> {
  void initState() {
    super.initState();
  }

  Widget _name() {
    return(
      Container(
        padding: EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Name:'),
            Text(widget.workOrder.firstName + ' ' + widget.workOrder.lastName, style: TextStyle(fontSize: 15),)
          ],
        ),
      )
    );
  }

  Future<Territory> _getTerritory(int id) async {
    var db = DatabaseHelper();
    Territory territory = await db.getTerritory(id);
    
    return territory;
  }

  Widget _territory() {
    return FutureBuilder(
      future: _getTerritory(widget.workOrder.territory),
      builder: (BuildContext context, AsyncSnapshot<Territory> snapshot) {
        return Container(
          padding: EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Territory:'),
              snapshot.hasData
              ? Text(snapshot.data.name, style: TextStyle(fontSize: 15),)
              : Text('null', style: TextStyle(fontSize: 15),)
            ],
          ),
        );
      },
    );
  }

  Widget _address() {
    return(
      Container(
        padding: EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Address:'),
            Text(widget.workOrder.address, style: TextStyle(fontSize: 15),)
          ],
        ),
      )
    );
  }

  Future<ToiletType> _getToiletType(int id) async {
    var db = DatabaseHelper();
    ToiletType toiletType = await db.getToiletType(id);
    
    return toiletType;
  }

  Widget _toiletType() {
    return FutureBuilder(
      future: _getToiletType(widget.workOrder.toiletType),
      builder: (BuildContext context, AsyncSnapshot<ToiletType> snapshot) {
        return Container(
          padding: EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Toilet Type:'),
              snapshot.hasData
              ? Text(snapshot.data.name, style: TextStyle(fontSize: 15),)
              : Text('null', style: TextStyle(fontSize: 15),)
            ],
          ),
        );
      },
    );
  }

  Future<WorkOrder> _getWorkOrder(int id) async {
    var db = DatabaseHelper();
    var result = await db.getWorkOrder(id);

    return WorkOrder.map(result);
  }

  Widget _workOrder() {
    return FutureBuilder(
      future: _getWorkOrder(widget.workOrder.workOrderId),
      builder: (BuildContext context, AsyncSnapshot<WorkOrder> snapshot) {
        return Container(
          padding: EdgeInsets.only(bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Work Order:'),
              snapshot.hasData
              ? Text(snapshot.data.name, style: TextStyle(fontSize: 15),)
              : Text('null', style: TextStyle(fontSize: 15),)
            ],
          ),
        );
      },
    );
  }

  Future<List<Map>> getItemList() async {
    var db = DatabaseHelper();
    List<Map> itemList = [];

    var result = await db.getWorkOrderItems(widget.workOrder.workOrderId);
    for(var i in result) {
      WorkOrderItem workOrderItem = WorkOrderItem.map(i);
      Item item = await getItem(workOrderItem.itemId);
      int itemQuantity = workOrderItem.quantity;
      Map map = {'item': item, 'quantity': itemQuantity};
      itemList.add(map);
    }
    
    return itemList;
  }

  Future<Item> getItem(int itemId) async {
    var db = DatabaseHelper();

    var result = await db.getItem(itemId);
    Item item = Item.map(result);
    return item;
  }

  Widget _itemList() {
    return FutureBuilder(
      future: getItemList(),
      builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
        return(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: FractionalOffset.centerLeft,
                child: Text('Items Required:'),
              ),
              snapshot.hasData
              ? Column(
                children: snapshot.data.map((item) => Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(item['item'].name + ' (' + item['quantity'].toString() + ')', style: TextStyle(fontSize: 15),),
                  ),
                )).toList()
              )
              : Text('null', style: TextStyle(fontSize: 15),),
            ],
          )
        );
      },
    );
  }

  Widget _transportDate() {
    String transportDate = DateFormat.yMMMd().format(DateTime.parse(widget.workOrder.transportDate));
    return(
      Container(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Transport Date:'),
            Text(transportDate, style: TextStyle(fontSize: 15),)
          ],
        ),
      )
    );
  }

  Widget _toiletInstallationLink() {
    return(
      Container(
        padding: EdgeInsets.only(top: 15),
        child: Align(
          alignment: FractionalOffset.center,
          child: GestureDetector(
            child: Text('Install Toilet >', style: TextStyle(color: Colors.blue, fontSize: 18),),
            onTap: () async {
              List itemList = await getItemList();
              Navigator.push(context, MaterialPageRoute(builder: (context) => GetSAWorkOrderItems(itemList: itemList, leadId: widget.workOrder.id,)));
            },
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Order'),
      ),
      body: ScopedModel<TaskModel>(
        model: TaskModel(),
        child: Container(
          padding: EdgeInsets.all(30),
          child: ScopedModelDescendant<TaskModel>(
            builder: (context, child, model) {
              return Container(
                child: ListView(
                  children: <Widget>[
                    _name(),
                    _territory(),
                    _address(),
                    _toiletType(),
                    _workOrder(),
                    _itemList(),
                    _transportDate(),
                    _toiletInstallationLink()
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}