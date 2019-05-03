import 'dart:async';
import 'dart:convert';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/complaintModel.dart';
import 'package:cbsa_mobile_app/models/interruptionTypeModel.dart';
import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:dio/dio.dart';

class CustomerService {
  static DatabaseHelper db;

  static Future<Response> updateCustomers() async {
    String url = await BaseService.fetchSubDomain();
    var response = await Dio().get(
      url + 'customer/mobileget',
      options: Options(headers: BaseService.headers),
    );
    return response;
  }

  static Future<Response> getInterruptionTypes() async {
    String url = await BaseService.fetchSubDomain();
    var response = await Dio().get(
      url + 'interruptiontypes',
      options: Options(headers: BaseService.headers),
    );
    return response;
  }

  static Future<Response> getComplaintTypes() async {
    String url = await BaseService.fetchSubDomain();
    var response = await Dio().get(
      url + 'complaintstype/mobileget',
      options: Options(headers: BaseService.headers),
    );
    return response;
  }

  static Future<Response> saveComplaint(Complaint model) async {
    String url = await BaseService.fetchSubDomain();
    var response = await Dio().post(
      url + 'complain/save',
      options: Options(headers: BaseService.headers),
      data: jsonEncode(model.toRemoteMap()),
    );
    return response;
  }

  static Future<Response> getComplaints() async {
    String url = await BaseService.fetchSubDomain();
    var response = await Dio().get(
      url + 'complain/mget',
      options: Options(headers: BaseService.headers),
    );
    return response;
  }
}