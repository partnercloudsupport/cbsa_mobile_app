import 'dart:async';
import 'dart:convert';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:http/http.dart' show Client, Response;

class HealthInspectionService {
  static final Client client = Client();

  static Future<Response> fetchCustomers() async {
    String url = await BaseService.fetchSubDomain();

    var dbClient = DatabaseHelper();
    Map user = await dbClient.getUserObject();

    int userId = user['user_id'];

    var response = await client.get('${url}groupinspection/assigned/$userId');
    return response;
  }

  static Future<Response> submitInspection(Map<String, dynamic> map) async {
    String url = await BaseService.fetchSubDomain();

    var response = await client.post(
      '${url}inspection/save',
      headers: BaseService.headers,
      body: jsonEncode(map)
    );
    return response;
  }

  static Future<Response> rescheduleInspection(Map<String, dynamic> map) async {
    String url = await BaseService.fetchSubDomain();

    var response = await client.post(
      '${url}healthinsp/update',
      headers: BaseService.headers,
      body: jsonEncode(map)
    );
    return response;
  }
}