import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:scoped_model/scoped_model.dart';

class LeadModel extends Model {
  Lead _lead;
  List _leads = [];
  List _openLeads = [];
  List _readyLeads = [];
  List _directOrders = [];
  List _opportunityLeads = [];
  List _pendingLeads = [];
  List _approvedLeads = [];
  List _leadConversions = [];
  List<Lead> _activeLeads = [];

  // getters
  Lead get lead => _lead;
  List get leads => _leads;
  List get openLeads => _openLeads;
  List get readyLeads => _readyLeads;
  List get directOrders => _directOrders;
  List get opportunityLeads => _opportunityLeads;
  List get pendingLeads => _pendingLeads;
  List get approvedLeads => _approvedLeads;
  List get leadConversions => _leadConversions;
  List<Lead> get activeLeads => _activeLeads;

  // save lead
  Future<int> saveLead(Lead lead) async {
    var db = new DatabaseHelper();
    var x = await db.saveLead(lead);
    notifyListeners();

    return x;
  }

  // get lead
  Future<Lead> fetchLead(int id) async {
    var db = new DatabaseHelper();
    Lead lead = await db.getLead(id);

    return lead;
  }

  void getLead(int id) async {
    var db = new DatabaseHelper();
    Lead lead = await db.getLead(id);
    this._lead = lead;

    notifyListeners();
  }

  // get all leads
  void fetchAllLeads() async {
    var db = new DatabaseHelper();
    List list = await db.getAllLeads();
    this._leads = list;

    notifyListeners();
  }

  // get all follow up leads
  void fetchAllOpenLeads() async {
    var db = new DatabaseHelper();
    List list = await db.getAllOpenLeads();
    this._openLeads = list;

    notifyListeners();
  }

  // get all ready leads
  void fetchAllReadyLeads() async {
    var db = new DatabaseHelper();
    List list = await db.getAllReadyLeads();
    this._readyLeads = list;

    notifyListeners();
  }

  // get all direct orders
  void fetchAllDirectOrders() async {
    var db = new DatabaseHelper();
    List list = await db.getDirectOrders();
    this._directOrders = list;

    notifyListeners();
  }

  // get all opportunity leads
  void fetchAllOpportunityLeads() async {
    var db = new DatabaseHelper();
    List list = await db.getAllOpportunityLeads();
    this._opportunityLeads = list;

    notifyListeners();
  }

  // get all pending opportunity leads
  void fetchAllPendingLeads() async {
    var db = new DatabaseHelper();
    List list = await db.getAllPendingOpportunityLeads();
    this._pendingLeads = list;

    notifyListeners();
  }

  // get all approved opportunity leads
  void fetchAllApprovedLeads() async {
    var db = new DatabaseHelper();
    List list = await db.getAllApprovedOpportunityLeads();
    this._approvedLeads = list;

    notifyListeners();
  }

  // update lead
  Future<int> updateLead(Lead lead) async {
    var db = new DatabaseHelper();
    int x = await db.updateLead(lead);
    notifyListeners();

    return x;
  }

  // update lead status
  // archive lead

  // get lead conversions
  void fetchAllLeadConversions() async {
    var db = new DatabaseHelper();
    List list = await db.getAllLeadConversions();
    this._leadConversions = list;

    notifyListeners();
  }

  // get active leads
  void fetchAllActiveLeads() async {
    var db = new DatabaseHelper();
    List list = await db.getAllActiveLeads();
    List<Lead> activeCustomers;
    if(list.length > 0) {
      activeCustomers = list.map((item) {
        return Lead.map(item);
      }).toList();
    }
    this._activeLeads = activeCustomers;

    notifyListeners();
  }
}