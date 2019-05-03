import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/lead_conversion.dart';
import 'package:scoped_model/scoped_model.dart';

class LeadConversionModel extends Model {
  List _leadConversions = [];

  // getters
  List get leadConversion => _leadConversions;
  
  // save lead conversion
  void saveLeadConversion(LeadConversion leadConversion) async {
    var db = new DatabaseHelper();
    int a = await db.saveLeadConversion(leadConversion);

    Lead lead = await db.getLead(leadConversion.leadId);
    lead.setStatus('Ready');

    int b = await db.updateLead(lead);
    notifyListeners();
  }

  // get lead conversion
  Future<LeadConversion> getLeadConversion(int id) async {
    var db = new DatabaseHelper();
    LeadConversion leadConversion = await db.getLeadConversion(id);
    notifyListeners();

    return leadConversion;
  }

  // get all lead conversions
  void fetchAllLeadConversions() async {
    var db = new DatabaseHelper();
    List list = await db.getAllLeadConversions();
    this._leadConversions = list;
    
    notifyListeners();
  }
}