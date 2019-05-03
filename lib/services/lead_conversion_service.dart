import 'dart:async';
import 'dart:convert';

import 'package:cbsa_mobile_app/models/lead_conversion.dart';
import 'package:cbsa_mobile_app/services/base_service.dart';
import 'package:http/http.dart' as http;

class LeadConversionService {

  static Future<http.Response> saveLeadConversion(LeadConversion leadConversion) async {
    String url = await BaseService.fetchSubDomain();
    
    var response = await http.post(
      '${url}leadconversion/save',
      headers:{
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(leadConversion.toApiMap())
    );
    
    return response;
  }
}