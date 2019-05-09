import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/complaintModel.dart';
import 'package:cbsa_mobile_app/models/complaintTypeModel.dart';
import 'package:cbsa_mobile_app/models/interruptionTypeModel.dart';
import 'package:cbsa_mobile_app/models/user.dart';
import 'package:cbsa_mobile_app/models/work_order.dart';
import 'package:cbsa_mobile_app/scoped_model/initial_setup_model.dart';
import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
import 'package:cbsa_mobile_app/services/home_service.dart';
import 'package:cbsa_mobile_app/services/work_order_service.dart';
import 'package:cbsa_mobile_app/setup_models.dart/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridItem {
  String title;
  Icon icon;
  GridItem({this.title, this.icon});
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;
  var qrsize = 100.0;
  bool maximized = false;
  SharedPreferences prefs;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  GlobalKey globalKey = new GlobalKey();
  GlobalKey globalKey1 = new GlobalKey();
  String _dataString = "Hello from this QR";
  String _inputErrorText;

  final TextEditingController _textController = TextEditingController();
  String _username, _email, _initial = 'D';
  List<GridItem> operations = <GridItem>[
    new GridItem(
      title: 'Leads',
      icon: Icon(
        Icons.person_pin,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Direct Orders',
      icon: Icon(
        Icons.shop_two,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Secondary Approvals',
      icon: Icon(
        Icons.playlist_add_check,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Customers',
      icon: Icon(
        Icons.list,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Tasks',
      icon: Icon(
        Icons.play_for_work,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Archives',
      icon: Icon(
        Icons.library_books,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Reminders',
      icon: Icon(
        Icons.alarm,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Work Orders',
      icon: Icon(
        Icons.description,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Toilet Servicing',
      icon: Icon(
        Icons.alarm,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Payments',
      icon: Icon(
        Icons.monetization_on,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('logo');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        _showNotificationWithDefaultSound(message['notification']['title'],
            message['notification']['body'], message['data']['type']);
      },
      onResume: (Map<String, dynamic> message) {
        _showNotificationWithDefaultSound(message['notification']['title'],
            message['notification']['body'], message['data']['type']);
      },
      onLaunch: (Map<String, dynamic> message) {
        _showNotificationWithDefaultSound(message['notification']['title'],
            message['notification']['body'], message['data']['type']);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      prefs.setString('firebase_token', token);
    });

    fetchWorkOrders();
    fetchInitialRemoteData();
  }

  _showNotificationWithDefaultSound(
      String title, String body, String type) async {
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
      payload: type,
    );
  }

  Future onSelectNotification(String payload) async {
    switch (payload) {
      case 'customer':
        Navigator.of(context).pushNamed('customers');
        break;
      case 'inspecshedule':
        Navigator.of(context).pushNamed('customers');
        break;
      case 'toiinstall':
        break;
      case 'healthinspection':
        break;
      case 'complain':
        break;
      case 'inspecshedule':
        break;
      case 'leadchange':
        break;
    }
  }

  // Fetch Initial data
  void fetchInitialRemoteData() async {
    var db = new DatabaseHelper();
    HomeService.fetchInitialRemoteData().then((response) {
      (List.from(response[0].data))
          .forEach((l) => db.saveComplaint(Complaint.fromMap(l)));
      (List.from(response[1].data))
          .forEach((t) => db.saveInterruptionType(InterruptionType.fromMap(t)));
      (List.from(response[2].data)).forEach((i) => {
            db.saveComplaintType(ComplaintType.fromMap(i)),
          });
    });
  }

  void fetchWorkOrders() async {
    var response = await WorkOrderService.fetchWorkOrders();
    var decodedResponse = jsonDecode(response.body);

    var db = DatabaseHelper();
    db.clearAssignedWorkOrdersTable();

    for (var i in decodedResponse) {
      Map map = Map.from(i['lead']);
      map['workorderid'] = i['workorderid'];
      map['installationdate'] = i['installationdate'];

      await db.saveAssignedWorkOrder(WorkOrderModel.map(map));
    }
  }

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<User> fetchUser() async {
    var db = new DatabaseHelper();
    return await db.getUser();
  }

  void showQrDialog(InitialSetupModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: FittedBox(
          fit: BoxFit.contain,
          child: RepaintBoundary(
            key: globalKey1,
            child: Container(
              width: 200.0,
              height: 200.0,
              child: QrImage(
                data: model.userObject.length != 0
                    ? model.userObject['email']
                    : '',
                size: 200.0,
                onError: (ex) {
                  print("[QR] ERROR - $ex");
                  setState(() {
                    _inputErrorText =
                        "Error! Maybe your input value is too long?";
                  });
                },
              ),
            ),
          ),
        ));
      },
    );
  }

  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }

  _getGridViewItems(BuildContext context) {
    List<Widget> allWidgets = new List<Widget>();
    for (int i = 0; i < operations.length; i++) {
      var widget = homeCard(operations[i].title, operations[i].icon);
      allWidgets.add(widget);
    }
    return allWidgets;
  }

  Widget homeCard(String title, Icon icon) {
    return InkWell(
      child: Card(
        elevation: 15.0,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              Text('$title'),
            ],
          ),
        ),
      ),
      onTap: () {
        switch (title) {
          case 'Leads':
            Navigator.pushNamed(context, '/lead');
            break;
          case 'Tasks':
            Navigator.pushNamed(context, '/task');
            break;
          case 'Archives':
            Navigator.pushNamed(context, '/archive');
            break;
          case 'Direct Orders':
            Navigator.pushNamed(context, '/directorder');
            break;
          case 'Customers':
            Navigator.pushNamed(context, '/customers');
            break;
          case 'Work Orders':
            Navigator.pushNamed(context, '/workorders');
            break;
          case 'Toilet Servicing':
            Navigator.pushNamed(context, '/toiletservicing');
            break;
          case 'Secondary Approvals':
            Navigator.pushNamed(context, '/secondaryapprovals');
            break;
          case 'Payments':
            Navigator.pushNamed(context, '/payments');
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: new InitialSetupModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'CBSA',
          ),
        ),
        drawer: ScopedModelDescendant<InitialSetupModel>(
          builder: (context, child, model) {
            model.fetchUserObject();
            return Drawer(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        accountName: Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text(
                            model.userObject.length != 0
                                ? model.userObject['name']
                                : '',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        accountEmail: Text(
                          model.userObject.length != 0
                              ? model.userObject['email']
                              : '',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        currentAccountPicture: CircleAvatar(
                          child: Text(
                            _initial,
                            style: TextStyle(fontSize: 35.0),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              flex: 6,
                              child: ListView(
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(
                                      Icons.home,
                                      color: Colors.black,
                                    ),
                                    title: Text('Home'),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushNamed('/home');
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.info,
                                      color: Colors.black,
                                    ),
                                    title: Text('About'),
                                    onTap: () {
                                      Navigator.of(context).pushNamed('/');
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.settings,
                                      color: Colors.black,
                                    ),
                                    title: Text('Health Inspections'),
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/healthinspection');
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.settings,
                                      color: Colors.black,
                                    ),
                                    title: Text('Complaints'),
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/complaints');
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.settings,
                                      color: Colors.black,
                                    ),
                                    title: Text('Settings'),
                                    onTap: () {
                                      Navigator.of(context).pushNamed('/');
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: FlatButton.icon(
                                      onPressed: () {
                                        prefs.remove('isloggedin');
                                        Navigator.pushReplacementNamed(
                                            context, '/login');
                                      },
                                      icon: Icon(Icons.power_settings_new),
                                      label: Text(
                                        'Logout',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        showQrDialog(model);
                                      },
                                      child: RepaintBoundary(
                                        key: globalKey,
                                        child: QrImage(
                                          data: model.userObject.length != 0
                                              ? model.userObject['email']
                                              : '',
                                          size: qrsize,
                                          onError: (ex) {
                                            print("[QR] ERROR - $ex");
                                            setState(() {
                                              _inputErrorText =
                                                  "Error! Maybe your input value is too long?";
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        body: ScopedModelDescendant<InitialSetupModel>(
            builder: (context, child, model) {
          return GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 1.08,
            padding: EdgeInsets.all(16.0),
            children: _getGridViewItems(context),
          );
        }),
      ),
    );
  }
}
