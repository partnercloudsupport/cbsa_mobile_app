import 'dart:async';

import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:http/http.dart' show Client, Response;
import 'dart:convert';

class LeadService {
  static final Client client = Client();

  static Future<Response> saveLead(Lead lead) async {
    String url = await BaseService.fetchSubDomain();
    var response = await client.post(
      '${url}lead/save',
      headers: BaseService.headers,
      body: jsonEncode(lead.toApiMap()),
    );
    return response;
  }
}