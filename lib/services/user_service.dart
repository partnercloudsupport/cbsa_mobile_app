import 'dart:async';

import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:http/http.dart' show Client, Response;
import '../models/login.dart';
import 'dart:convert';

class UserService {
  static final Client client = Client();

  static Future<Response> login(LoginModel loginModel) async {
    String url = await BaseService.fetchSubDomain();
    print(url);
    var response = await client.post(
      '${url}mlogin',
      headers: BaseService.headers,
      body: jsonEncode(loginModel.toMap()),
    );
    print(response.toString());
    return response;
  }
}