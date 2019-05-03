import 'dart:async';
import 'dart:convert';

import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:http/http.dart' show Client, Response;

class SecondaryApprovalsService {
  static final Client client = Client();

  static Future<Response> getApprovedLeads() async {
    String url = await BaseService.fetchSubDomain();
    var response = await client.get('${url}lead/secapprovedleads');
    // var response = await client.get('${url}getassigneditems');

    // print(response.body);
    return response;
  }

  static Future<Response> submitItems(Map<String, dynamic> map) async {
    String url = await BaseService.fetchSubDomain();
    var response = await client.post(
      '${url}workflow/update',
      headers: BaseService.headers,
      body: jsonEncode(map)
    );
    return response;
  }
}