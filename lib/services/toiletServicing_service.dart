import 'dart:async';

import 'package:cbsa_mobile_app/models/toilet_servicing.dart';
import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:http/http.dart' show Client, Response;
import '../models/login.dart';
import 'dart:convert';

class ToiletServicingService {
  static final Client client = Client();

  static Future<Response> fetchServicedToilets(int id) async {
    String url = await BaseService.fetchSubDomain();
    var response = await client.get(
      '${url}toiletserviced/mobileget/$id',
      headers: BaseService.headers,
    );
    return response;
  }

  // static Future<Response> fetchBarrelCount(int id) async {
  //   String url = await BaseService.fetchSubDomain();
  //   var response = await client.get(
  //     '${url}toiletserviced/mobileget/$id',
  //     headers: BaseService.headers,
  //   );
  //   return response;
  // }

  static Future<Response> serviceToilet(ToiletServicingModel model) async {
    String url = await BaseService.fetchSubDomain();
    var response = await client.post(
      '${url}toiletserviced/save',
      headers: BaseService.headers,
      body: jsonEncode(model.toMap()),
    );
    return response;
  }

  static Future<Response> serviceAdhocToilet(ToiletServicingModel model) async {
    String url = await BaseService.fetchSubDomain();
    var response = await client.post(
      '${url}adhocservice/save',
      headers: BaseService.headers,
      body: jsonEncode(model.toMap()),
    );
    return response;
  }

  static Future<Response> requestQrCode(AdhocServicingModel model) async {
    String url = await BaseService.fetchSubDomain();
    var response = await client.post(
      '${url}Requestqr/save',
      headers: BaseService.headers,
      body: jsonEncode(model.toMap()),
    );
    return response;
  }

  static Future<Response> recordBarrelCount(BarrelCountModel model) async {
    String url = await BaseService.fetchSubDomain();
    var response = await client.post(
      '${url}barrelcount/save',
      headers: BaseService.headers,
      body: jsonEncode(model.toMap()),
    );
    return response;
  }

  static Future<Response> updateBarrelCount(BarrelCountModel model) async {
    String url = await BaseService.fetchSubDomain();
    var response = await client.post(
      '${url}barrelcount/update/${model.serverid}',
      headers: BaseService.headers,
      body: jsonEncode(model.toMap()),
    );
    return response;
  }

  static Future<Response> reportServiceInterruption(ServiceInterruption model) async {
    String url = await BaseService.fetchSubDomain();
    var response = await client.post(
      '${url}reportserinter/save',
      headers: BaseService.headers,
      body: jsonEncode(model.toMap()),
    );
    print(response.statusCode);
    return response;
  }
}