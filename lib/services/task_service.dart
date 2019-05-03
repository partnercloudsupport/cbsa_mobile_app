import 'dart:async';
import 'dart:convert';
import 'package:cbsa_mobile_app/models/task.dart';
import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:http/http.dart' show Client, Response;

class TaskService {
  static final Client client = new Client();

  static Future<Response> createTask(Tasks task) async {
    String url = await BaseService.fetchSubDomain();

    var response = await client.post(
      '${url}task/save', 
      headers: BaseService.headers,
      body: json.encode(task.toMap()),
    );

    return response;
  }

  static Future<Response> updateTask(Tasks task,int id) async {
    String url = await BaseService.fetchSubDomain();
    var response = await client.post(
      '${url}task/update/${id}', 
      headers: BaseService.headers,
      body: json.encode(task.toMap()),
    );

    return response;
  }
}