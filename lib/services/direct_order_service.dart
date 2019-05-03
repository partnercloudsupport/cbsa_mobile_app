import 'dart:async';
import 'dart:convert';
import 'package:cbsa_mobile_app/models/direct_order.dart';
import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:http/http.dart' show Client, Response;

class DirectOrderService {
  static final Client client = Client();

  static Future<Response> saveDirectOrder(DirectOrder directOrder) async {
    String url = await BaseService.fetchSubDomain();
    
    var response = await client.post(
      '${url}directorder/save',
      headers: BaseService.headers,
      body: jsonEncode(directOrder.toApiMap()),
    );
    return response;
  }

  static Future<Response> updateDirectOrder(DirectOrder directOrder, int id) async {
    String url = await BaseService.fetchSubDomain();
    
    var response = await client.post(
      '${url}directorder/update/$id',
      headers: BaseService.headers,
      body: jsonEncode(directOrder.toApiMap()),
    );
    return response;
  }
}