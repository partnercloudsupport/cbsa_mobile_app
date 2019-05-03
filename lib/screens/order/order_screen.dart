import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
import 'package:cbsa_mobile_app/screens/follow_ups/followup_screen.dart';
import 'package:cbsa_mobile_app/screens/lead/update_lead_screen.dart';
import 'package:cbsa_mobile_app/screens/lead/view_lead_screen.dart';
import 'package:cbsa_mobile_app/screens/tasks/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  bool allowSelect = false;
  var selectedLeadRecords = <int>[];
  var selectedOrderRecords = <int>[];
  Icon selectIcon = Icon(Icons.check_box_outline_blank);

  void showAlertDialog(String message, TaskModel model, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: message == 'archive' ? Text('Archive Record') : Text(''),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                model.archiveLead(model.leadFollowups[index]['id']);
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  buildListView(TaskModel model, int index) {
    String firstName = model.orders[index]['firstName'].toString() ;
    String lastName = model.orders[index]['lastName'].toString();
    String initials =  firstName.substring(0, 1).toUpperCase() +
        lastName.substring(0, 1).toUpperCase();
    // DateTime date = model.orders[index]['followUpDate']==null? DateTime:  DateTime.parse(model.orders[index]['followUpDate']);
    // String formattedDate = date.day.toString() +
    //     ' - ' +
    //     date.month.toString() +
    //     ' - ' +
    //     date.year.toString();
    return GestureDetector(
      onTap: () {
        model.fetchLead(model.orders[index]['id']);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ViewLead(
        //           lead: model.lead,
        //         ),
        //   ),
        // );
      },
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 5.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Hero(
                          tag: initials,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(initials),
                            radius: 30.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(firstName + ' ' + lastName),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(model.orders[index]['primaryTelephone']),
                        SizedBox(
                          height: 10.0,
                        ),
                        // Text(formattedDate),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            model.fetchLead(model.orders[index]['id']);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => UpdateLead(
                            //           lead: model.lead,
                            //         ),
                            //   ),
                            // );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Visibility(
                    visible: allowSelect,
                    child: Checkbox(
                      value: selectedOrderRecords
                          .contains(model.orders[index]['id']),
                      onChanged: (value) {
                        if (value) {
                          selectedOrderRecords
                              .add(model.orders[index]['id']);
                        } else {
                          selectedOrderRecords
                              .remove(model.orders[index]['id']);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text('Tasks'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Task(
                                    initials: initials,
                                    fullName: firstName + ' ' + lastName,
                                    id: model.orders[index]['id'],
                                  ),
                            ),
                          );
                        },
                      ),
                      FlatButton(
                        child: Text('FollowUps'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Followups(
                                    initials: initials,
                                    fullName: firstName + ' ' + lastName,
                                    id: model.orders[index]['id'],
                                  ),
                            ),
                          );
                        },
                      ),
                      FlatButton(
                        child: Text('Archive'),
                        onPressed: () {
                          showAlertDialog('archive', model, index);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Orders'),
          // bottom: TabBar(
          //   tabs: [
          //     Tab(
          //       icon: Icon(Icons.insert_drive_file),
          //       text: 'Leads',
          //     ),
          //     Tab(
          //       icon: Icon(Icons.shopping_basket),
          //       text: 'Orders',
          //     ),
          //   ],
          // ),
        ),
        body: ScopedModel<TaskModel>(
          model: TaskModel(),
          child: TabBarView(
            children: <Widget>[
              ScopedModelDescendant<TaskModel>(
                builder: (context, child, model) {
                  model.fetchLeads();
                  return model.orders.length==0 ? Center(child: Text('No Orders Available',style: TextStyle(fontSize: 18.0,color: Colors.white),),):
                  Column(
                    children: <Widget>[
                      Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Row(
                                children: <Widget>[
                                  Visibility(
                                    visible: allowSelect,
                                    child: Checkbox(
                                      value: selectedOrderRecords.length ==
                                          model.orders.length,
                                      onChanged: (value) {
                                        if (value) {
                                          setState(() {
                                            selectedOrderRecords.clear();
                                            model.orders.forEach(
                                                (leads) => selectedOrderRecords
                                                    .add(leads['id']));
                                          });
                                        } else {
                                          setState(() {
                                            model.orders.forEach(
                                                (leads) => selectedOrderRecords
                                                    .remove(leads['id']));
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  FlatButton(
                                    color: Colors.white,
                                    child: Text('Select'),
                                    onPressed: () {
                                      setState(
                                        () {
                                          if (allowSelect) {
                                            allowSelect = false;
                                            selectedOrderRecords.clear();
                                          } else {
                                            allowSelect = true;
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 7.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton(
                                    color: Colors.white,
                                    child: Text('Add Task'),
                                    onPressed: selectedOrderRecords.isEmpty &&
                                            allowSelect == false
                                        ? null
                                        : () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) => Task(
                                            //           id: selectedOrderRecords,
                                            //         ),
                                            //   ),
                                            // );
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: model.orders.length,
                          itemBuilder: (BuildContext context, index) {
                            return buildListView(model, index);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              // ScopedModelDescendant<TaskModel>(
              //   builder: (context, child, model) {
              //     model.fetchLeads();
              //     return Column(
              //       children: <Widget>[
              //         Card(
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: <Widget>[
              //               Padding(
              //                 padding: EdgeInsets.all(0.0),
              //                 child: Row(
              //                   children: <Widget>[
              //                     Visibility(
              //                       visible: allowSelect,
              //                       child: Checkbox(
              //                         value: selectedLeadRecords.length ==
              //                             model.leadFollowups.length,
              //                         onChanged: (value) {
              //                           if (value) {
              //                             setState(() {
              //                               selectedLeadRecords.clear();
              //                               model.leadFollowups.forEach(
              //                                   (leads) => selectedLeadRecords
              //                                       .add(leads['id']));
              //                             });
              //                           } else {
              //                             setState(() {
              //                               model.leadFollowups.forEach(
              //                                   (leads) => selectedLeadRecords
              //                                       .remove(leads['id']));
              //                             });
              //                           }
              //                         },
              //                       ),
              //                     ),
              //                     FlatButton(
              //                       color: Colors.white,
              //                       child: Text('Select'),
              //                       onPressed: () {
              //                         setState(
              //                           () {
              //                             if (allowSelect) {
              //                               allowSelect = false;
              //                               selectedLeadRecords.clear();
              //                             } else {
              //                               allowSelect = true;
              //                             }
              //                           },
              //                         );
              //                       },
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               Padding(
              //                 padding: EdgeInsets.only(right: 7.0),
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.end,
              //                   children: <Widget>[
              //                     FlatButton(
              //                       color: Colors.white,
              //                       child: Text('Add Task'),
              //                       onPressed: selectedLeadRecords.isEmpty &&
              //                               allowSelect == false
              //                           ? null
              //                           : () {
              //                               Navigator.push(
              //                                 context,
              //                                 MaterialPageRoute(
              //                                   builder: (context) => Task(
              //                                         ids: selectedLeadRecords,
              //                                       ),
              //                                 ),
              //                               );
              //                             },
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Expanded(
              //           child: ListView.builder(
              //             itemCount: model.orders.length,
              //             itemBuilder: (BuildContext context, index) {
              //               return buildListView(model, index);
              //             },
              //           ),
              //         ),
              //       ],
              //     );
              //   },
              // ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.insert_drive_file,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/newlead');
          },
        ),
      ),
    );
  }
}
