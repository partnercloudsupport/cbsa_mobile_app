import 'dart:async';

import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:http/http.dart' show Client, Response;
import 'dart:convert';

class PaymentService {
  static final Client client = Client();

  static Future<Response> makePayment(Map<String, dynamic> map) async {
    String url = await BaseService.fetchSubDomain();
    var response = await client.post(
      '${url}invoice/makepayment',
      headers: BaseService.headers,
      body: jsonEncode(map),
    );
    return response;
  }
}