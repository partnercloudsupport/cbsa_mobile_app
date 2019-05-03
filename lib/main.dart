import 'package:cbsa_mobile_app/screens/archive/archive_screen.dart';
import 'package:cbsa_mobile_app/screens/complaint_management/complaints_screen.dart';
import 'package:cbsa_mobile_app/screens/customers/customers_screen.dart';
import 'package:cbsa_mobile_app/screens/direct_order/direct_order_record_screen.dart';
import 'package:cbsa_mobile_app/screens/direct_order/direct_orders_screen.dart';
import 'package:cbsa_mobile_app/screens/health_inspection/health_inspections.dart';
import 'package:cbsa_mobile_app/screens/home/home_screen.dart';
import 'package:cbsa_mobile_app/screens/lead/leads_screen.dart';
import 'package:cbsa_mobile_app/screens/lead/new_lead_screen.dart';
import 'package:cbsa_mobile_app/screens/lead_conversion/lead_conversion_screen.dart';
import 'package:cbsa_mobile_app/screens/login/faq_screen.dart';
import 'package:cbsa_mobile_app/screens/login/forgot_password_screen.dart';
import 'package:cbsa_mobile_app/screens/login/login_screen.dart';
import 'package:cbsa_mobile_app/screens/login/terms_screen.dart';
import 'package:cbsa_mobile_app/screens/order/order_screen.dart';
import 'package:cbsa_mobile_app/screens/payments/payments_screen.dart';
import 'package:cbsa_mobile_app/screens/secondary_approval/secondary_approvals_screen.dart';
import 'package:cbsa_mobile_app/screens/splash/splash_screen.dart';
import 'package:cbsa_mobile_app/screens/tasks/all_tasks_screen.dart';
import 'package:cbsa_mobile_app/screens/toilet_installation_and_servicing/new_barrel_count.dart';
import 'package:cbsa_mobile_app/screens/toilet_installation_and_servicing/service_toilet.dart';
import 'package:cbsa_mobile_app/screens/toilet_installation_and_servicing/toilet_servicing_records.dart';
import 'package:cbsa_mobile_app/screens/work_orders/work_orders_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  SharedPreferences prefs;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
  }

  initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
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
    print(payload);
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.cyan.shade300,
        primarySwatch: Colors.cyan,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/forgotpassword': (context) => ForgotPassword(),
        '/termsofuse': (context) => TermsOfUse(),
        '/faq': (context) => FAQs(),
        '/home': (context) => Home(),
        '/lead': (context) => LeadsScreen(),
        '/task': (context) => AllTasks(),
        '/newlead': (context) => NewLead(),
        '/directorder': (context) => DirectOrderList(),
        '/newdirectorder': (context) => DirectOrderRecord(),
        '/order': (context) => Order(),
        '/archive': (context) => Archive(),
        '/newleadconversion': (context) => NewLeadConversion(),
        '/workorders': (context) => WorkOrders(),
        '/toiletservicing': (context) => ServiceToilet(),
        '/healthinspection': (context) => HealthInspections(),
        '/complaints': (context) => Complaints(),
        '/login': (context) => Login(),
        '/barrelcount': (context) => BarrelCount(),
        '/toiletservicingrecords': (context) => ToiletServicingRecords(),
        '/secondaryapprovals': (context) => SecondaryApprovalsScreen(),
        '/customers': (context) => Customers(),
        '/payments': (context) => Payments(),
      },
    );
  }
}
