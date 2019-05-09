import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/app_translations.dart';
import 'package:cbsa_mobile_app/models/work_order.dart';
import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
import 'package:cbsa_mobile_app/screens/toilet_installation_and_servicing/toilet_installation_screen.dart';
import 'package:cbsa_mobile_app/setup_models.dart/item.dart';
import 'package:cbsa_mobile_app/setup_models.dart/sub_territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/toilet_type.dart';
import 'package:cbsa_mobile_app/setup_models.dart/work_order.dart';
import 'package:cbsa_mobile_app/setup_models.dart/work_order_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class WorkOrderView extends StatefulWidget {
  final WorkOrderModel workOrder;

  const WorkOrderView({Key key, this.workOrder}) : super(key: key);

  @override
  _WorkOrderViewState createState() => _WorkOrderViewState();
}

class _WorkOrderViewState extends State<WorkOrderView> {
  void initState() {
    super.initState();
  }

  Widget _name() {
    return (Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(AppTranslations.of(context).text("name")),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.centerRight,
              child: Text(
                widget.workOrder.firstName + ' ' + widget.workOrder.lastName,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Future<SubTerritory> _getSubTerritory(int id) async {
    var db = DatabaseHelper();
    SubTerritory subTerritory= await db.getSubTerritory(id);

    return subTerritory;
  }

  Widget _territory() {
    return FutureBuilder(
      future: _getSubTerritory(widget.workOrder.subTerritory),
      builder: (BuildContext context, AsyncSnapshot<SubTerritory> snapshot) {
        return Container(
          padding: EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(AppTranslations.of(context).text("subTerritory")),
              ),
              snapshot.hasData
                  ? Expanded(
                      child: Align(
                        alignment: FractionalOffset.centerRight,
                        child: Text(
                          snapshot.data.name,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Align(
                        alignment: FractionalOffset.centerRight,
                        child: Text(
                          'null',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _address() {
    return (Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(AppTranslations.of(context).text("address")),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: FractionalOffset.centerRight,
              child: Text(
                widget.workOrder.address,
                style: TextStyle(fontSize: 15),
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    ));
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
              Expanded(
                child: Text(AppTranslations.of(context).text("toiletType")),
              ),
              snapshot.hasData
                  ? Expanded(
                      child: Align(
                        alignment: FractionalOffset.centerRight,
                        child: Text(
                          snapshot.data.name,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Align(
                        alignment: FractionalOffset.centerRight,
                        child: Text(
                          'null',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
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
              Expanded(
                child: Text(AppTranslations.of(context).text("workOrder")),
              ),
              snapshot.hasData
                  ? Expanded(
                      child: Align(
                        alignment: FractionalOffset.centerRight,
                        child: Text(
                          snapshot.data.name,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Align(
                        alignment: FractionalOffset.centerRight,
                        child: Text(
                          'null',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
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
    for (var i in result) {
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
        return (Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: FractionalOffset.centerLeft,
              child: Text(AppTranslations.of(context).text("itemsRequired")),
            ),
            snapshot.hasData
                ? Column(
                    children: snapshot.data
                        .map((item) => Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  item['item'].name +
                                      ' (' +
                                      item['quantity'].toString() +
                                      ')',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ))
                        .toList())
                : Text(
                    'null',
                    style: TextStyle(fontSize: 15),
                  ),
          ],
        ));
      },
    );
  }

  Widget _toiletInstallationDate() {
    String installationDate = DateFormat.yMMMd()
        .format(DateTime.parse(widget.workOrder.toiletInstallationDate));
    return (Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(AppTranslations.of(context).text("toiletInstallationDate")),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.centerRight,
              child: Text(
                installationDate,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _toiletInstallationLink() {
    return (Container(
      padding: EdgeInsets.only(top: 15),
      child: Align(
        alignment: FractionalOffset.center,
        child: GestureDetector(
          child: Text(
            AppTranslations.of(context).text("installToilet"),
            style: TextStyle(color: Colors.blue, fontSize: 18),
          ),
          onTap: () async {
            List itemList = await getItemList();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ToiletInstallation(
                          itemList: itemList,
                          leadId: widget.workOrder.id,
                          workOrderId: widget.workOrder.workOrderId
                        )));
          },
        ),
      ),
    ));
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
                    _toiletInstallationDate(),
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
