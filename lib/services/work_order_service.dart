import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:http/http.dart' show Client, Response;

class WorkOrderService {
  static final Client client = Client();

  static Future<Response> fetchWorkOrders() async {
    String url = await BaseService.fetchSubDomain();

    var dbClient = DatabaseHelper();
    Map user = await dbClient.getUserObject();

    int userId = user['user_id'];

    var response = await client.get('${url}getassigneditems/$userId');
    return response;
  }
}