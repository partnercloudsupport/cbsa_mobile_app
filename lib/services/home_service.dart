import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/user.dart';
import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:dio/dio.dart';

class HomeService {
  static Future<List<Response>> fetchInitialRemoteData() async {
    String url = await BaseService.fetchSubDomain();
    List<Response> responses = await Future.wait([
      Dio().get(url + 'complain/mget',
          options: Options(headers: {
            'Accept': 'application/json'
          })),
      Dio().get(url + 'interruptiontypes',
          options: Options(headers: {
            'Accept': 'application/json'
          })),
      Dio().get(
          url + 'complaintstype/mobileget',
          options: Options(headers: {
            'Accept': 'application/json'
          })),
    ]);
    return responses;
  }
}
