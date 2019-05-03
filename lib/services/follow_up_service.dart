import 'dart:async';
import 'dart:convert';


import 'package:cbsa_mobile_app/models/followUp.dart';
import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:http/http.dart' show Client, Response;

class FollowUpService {
  static final Client client = new Client();

  static Future<Response> createFollowUp(FollowUps followUp) async {
    String url = await BaseService.fetchSubDomain();

    var response = await client.post(
      '${url}followup/save', 
      headers: BaseService.headers,
      body: json.encode(followUp.toMap()),
    );
    return response;
  }

   static Future<Response> updateFollowUp(FollowUps followUp,int id) async {
    String url = await BaseService.fetchSubDomain();
    var response = await client.post(
      '${url}followup/update/${id}', 
      headers: BaseService.headers,
      body: json.encode(followUp.toMap()),
    );
    return response;
  }

  static Future<Response> archiveFollowup(int id) async{
    String url = await BaseService.fetchSubDomain();
    var response = await client.post(
      '${url}followup/archive/$id', 
      headers: BaseService.headers,
    );
    return response;
  }
}