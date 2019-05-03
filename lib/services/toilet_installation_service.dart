import 'dart:async';
import 'dart:convert';

import 'package:cbsa_mobile_app/models/toilet_installation.dart';
import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:http/http.dart' as http;

class ToiletInstallationService {

  static Future<http.Response> saveToiletInstallation(ToiletInstallationModel toiletInstallation) async {
    String url = await BaseService.fetchSubDomain();

    var response = await http.post(
      '${url}installedtoilets/save',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(toiletInstallation.toApiMap())
    );

    return response;
  }
}