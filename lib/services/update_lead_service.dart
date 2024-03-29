import 'dart:async';

import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:http/http.dart' show Client, Response;
import 'dart:convert';

class UpdateLeadService {
  static final Client client = Client();

  static Future<Response> updateLead(Map<String, dynamic> lead, int id) async {
    String url = await BaseService.fetchSubDomain();
    var response = await client.post(
      '${url}lead/update/$id',
      headers: BaseService.headers,
      body: jsonEncode(lead),
    );
    return response;
  }
}