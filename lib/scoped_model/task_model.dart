import 'dart:async';
import 'dart:convert';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/direct_order.dart';
import 'package:cbsa_mobile_app/models/followUp.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/lead_conversion.dart';
import 'package:cbsa_mobile_app/models/setup.dart';
import 'package:cbsa_mobile_app/models/task.dart';
import 'package:cbsa_mobile_app/models/user.dart';
import 'package:cbsa_mobile_app/services/follow_up_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:scoped_model/scoped_model.dart';

class TaskModel extends Model {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List _tasks = [];
  Tasks _task ;

  List _leads = [];
  Lead _lead ;

  Setups _setup;

  List _followups = [];
  FollowUps _followup;

  List _leadFollowups = [];
  Lead _leadFollowup;

  List _leadArchives = [];
  Lead _leadArchive;
  // DirectOrders _directOrder;

  List _leadConversions = [];
  LeadConversion _leadConversion;

  List _archivedDirectOrders = [];
  List _notArchivedDirectOrders = [];

  List get leadArchives => _leadArchives;

  List _orders = [];
  List _opportunities = [];
  List _tasksById = [];
  List _followupsById = [];
  List _directOrders = [];

  List get tasks => _tasks;
  List get tasksById => _tasksById;
  List get followupsById => _followupsById;
  Tasks get task => _task;

  List get leads => _leads;
  Lead get lead => _lead;

  List get directOrders => _directOrders;
  // DirectOrders get directOrder => _directOrder;

  List get notArchivedDirectOrders => _notArchivedDirectOrders;
  List get archivedDirectOrders => _archivedDirectOrders;

  List get leadFollowups => _leadFollowups;
  Lead get leadFollowup => _leadFollowup;

  List get leadConversions => _leadConversions;
  LeadConversion get leadConversion => _leadConversion;

  List get orders => _orders;
  List get opportunities => _opportunities;

  List get followups => _followups;
  FollowUps get followup => _followup;

  Setups get setup => _setup;

  TaskModel(){
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher'); 
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
  }

  void rescheduleFollowup(int id,String date) async{
    var db = new DatabaseHelper();
    FollowUps a = (await db.getFollowUp(id));
    a.setRescheduleDate(date);
    await db.updateFollowup(a);
    notifyListeners();
  }

  updateRemoteFollowup(FollowUps followup) async{
    Response response = await FollowUpService.updateFollowUp(followup, followup.id);
    print(response);
  }

  updateFollowup(FollowUps followup) async{
    var db = new DatabaseHelper();
    int result = await db.updateFollowup(followup);
    notifyListeners();
  }

  Future<int> rescheduleRemoteFollowup(var followup,String followupdate) async{
    FollowUps object = FollowUps.fromMap(followup);
    object.setFollowupDate(followupdate);
    Response response = await FollowUpService.updateFollowUp(object, object.id);
    if(jsonDecode(response.body)['status']==200){
      return 1;
    }else{
      return 0;
    }
  }

  Future<int> archiveRemoteFollowup(int id) async{
    Response response = await FollowUpService.archiveFollowup(id);
    if(jsonDecode(response.body)['status']==200){
      return 1;
    }else{
      return 0;
    }
  }

  Future onSelectNotification(String payload) async {
    // Navigator.push(context, route)
    // showDialog(
    //   context: context,
    //   builder: (_) {
    //     return new AlertDialog(
    //       title: Text("PayLoad"),
    //       content: Text("Payload : $payload"),
    //     );
    //   },
    // );
  }

  Future _showNotification(String title,String body) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  Future _scheduleNotification(DateTime date,String title,String body) async {
    var scheduledNotificationDateTime = date;
    var androidPlatformChannelSpecifics =
        new AndroidNotificationDetails('a',
            'b', 'c');
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        title,
        body,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  void addTask(Tasks task) async{
    var db = new DatabaseHelper();
    await db.saveTask(task);
    _scheduleNotification(DateTime.parse(task.duedate), 'Task Reminder', task.name);
    notifyListeners();
  }

  Future<int> addLead(Lead lead) async{
    var db = new DatabaseHelper();
    var x = await db.saveLead(lead);
    notifyListeners();
    return x;
  }

  Future addSetup(Setups setup) async{
    var db = new DatabaseHelper();
    await db.saveSetup(setup);
    notifyListeners();
  }

  // void addDirectOrder(DirectOrders directOrder) async{
  //   var db = new DatabaseHelper();
  //   await db.saveDirectOrder(directOrder);
  //   notifyListeners();
  // }

  void addLeadConversion(LeadConversion leadConversion) async{
    var db = new DatabaseHelper();
    int b=await db.saveLeadConversion(leadConversion);
    Lead a = (await db.getLead(leadConversion.leadId));
    a.setStatus('Ready');
    int c = await db.updateLead(a);
    notifyListeners();
  }

  void addFollowUp(FollowUps followup) async{
    var db = new DatabaseHelper();
    int a =await db.saveFollowUp(followup);
    notifyListeners();
  }

  void fetchTasks() async{
    var db = new DatabaseHelper();
    List a= (await db.getAllTasks());
    _tasks=a;
    notifyListeners();
  }

  void fetchLeads() async{
    var db = new DatabaseHelper();
    List a= (await db.getAllLeads());
    _leadFollowups = a.where((leads) => leads['status']=='Follow Up' && leads['archived']==10).toList();
    _leadArchives = a.where((leads) => leads['status']=='Follow Up' && leads['archived']==11).toList();
    _orders = a.where((leads) => leads['status']=='Ready').toList();
    _opportunities = a.where((leads) => leads['status']=='Opportunity').toList();
    _leads=a;
    // a.forEach((lead){
    //   var fullName = lead['firstName'] + ' ' + lead['lastName'];
    //   var date = DateTime.parse(lead['followUpDate']);
    //   if(date.day==DateTime.now().day && date.month==DateTime.now().month && date.year==DateTime.now().year){
    //     _scheduleNotification(DateTime.parse(lead['followUpDate']),'Follow up on lead',fullName);
    //   }
    // });
    notifyListeners();
  }

  void fetchFollowUps() async{
    var db = new DatabaseHelper();
    List a = (await db.getAllFollowUps());
    _followups = a;
    notifyListeners();
  }

  void fetchDirectOrders() async{
    var db = new DatabaseHelper();
    List a = (await db.getAllDirectOrders());
    _notArchivedDirectOrders = a.where((leads) => leads['status']=='Follow Up' && leads['archived']==10).toList();
    _archivedDirectOrders = a.where((leads) => leads['status']=='Follow Up' && leads['archived']==11).toList();
    // print(_archivedDirectOrders);
    _directOrders = a;
    notifyListeners();
  }

  void fetchLeadConversions() async{
    var db = new DatabaseHelper();
    List a = (await db.getAllLeadConversions());
    _leadConversions = a;
    notifyListeners();
  }

  void fetchTask(int id) async{
   var mytask = _tasks.where((lead) => lead['id']==id).toList();
    _task=Tasks.map(mytask.first);
    notifyListeners();
  }

  Future fetchSetup() async{
    var db = new DatabaseHelper();
    Setups mysetup = await db.getSetup();
    _setup = mysetup;
    // print(Setups.map(mysetup));
    notifyListeners();
  }

  // void fetchDirectOrder(int id) async{
  //  var mytask = _directOrders.where((dorder) => dorder['id']==id).toList();
  //   _directOrder=DirectOrders.map(mytask.first);
  //   notifyListeners();
  // }

  void fetchTasksById(int id) async{
    var mytasks = _tasks.where((lead) => lead['id']==id).toList();
    _tasksById=mytasks;
    notifyListeners();
  }

  void fetchLead(int id) async{
    var mylead = _leads.where((lead) => lead['id']==id).toList();
    _lead=Lead.map(mylead.first);
    notifyListeners();
  }

  void fetchLeadConversion(int id) async{
    var mylead = _leadConversions.where((leadconversion) => leadconversion['id']==id).toList();
    _leadConversion=LeadConversion.map(mylead.first);
    notifyListeners();
  }

  void fetchfollowUp(int id) async{
    var myfollowup = _followups.where((followup) => followup['id']==id).toList();
    _followup=FollowUps.map(myfollowup.first);
    notifyListeners();
  }

  void fetchfollowUpsById(int id) async{
    var myfollowups = _followups.where((followup) => followup['leadid']==id).toList();
    _followupsById=myfollowups;
    notifyListeners();
  }

  // void updateLeadStatus(int id, String status) async{
  //   var db = new DatabaseHelper();
  //   Lead a= (await db.getLead(id));
  //   a.setStatus(status);
  //   await db.updateLeadStatus(id,a);
  //   notifyListeners();
  // }

  void archiveLead(int id) async{
    var db = new DatabaseHelper();
    Lead a = (await db.getLead(id));
    a.setArchived(11);
    await db.archiveLead(id, a);
    notifyListeners();
  }

  // void archiveDirectOrder(int id) async{
  //   var db = new DatabaseHelper();
  //   DirectOrders a = (await db.getDirectOrder(id));
  //   a.setArchived(11);
  //   await db.archiveDirectOrder(id, a);
  //   notifyListeners();
  // }

  // void updateDirectOrder(DirectOrders directOrder) async{
  //   var db = new DatabaseHelper();
  //   await db.updateDirectOrder(directOrder);
  //   notifyListeners();
  // }

  

  void unarchiveLead(List<int> ids) async{
    var db = new DatabaseHelper();
    ids.forEach((id) async{
      Lead a = (await db.getLead(id));
      a.setArchived(10);
      await db.archiveLead(id, a);
    });
    notifyListeners();
  }

  void updateLead(Lead lead) async{
    var db = new DatabaseHelper();
    await db.updateLead(lead);
    notifyListeners();
  }

   void updateTask(Tasks task) async{
    var db = new DatabaseHelper();
    await db.updateTask(task);
    notifyListeners();
  }

  Future<int> addUser(User user) async{
    var db = new DatabaseHelper();
    int a =await db.saveUser(user);
    notifyListeners();
    return a;
  }
}