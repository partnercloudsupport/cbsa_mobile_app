import 'dart:async';

import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/complaintModel.dart';
import 'package:cbsa_mobile_app/models/complaintTypeModel.dart';
import 'package:cbsa_mobile_app/models/customer.dart';
import 'package:cbsa_mobile_app/models/interruptionTypeModel.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/lead_conversion.dart';
import 'package:cbsa_mobile_app/models/toilet_installation.dart';
import 'package:cbsa_mobile_app/services/customer_service.dart';
import 'package:cbsa_mobile_app/setup_models.dart/block.dart';
import 'package:cbsa_mobile_app/setup_models.dart/enrollment_reason.dart';
import 'package:cbsa_mobile_app/setup_models.dart/health_inspection_schedule.dart';
import 'package:cbsa_mobile_app/setup_models.dart/information_source.dart';
import 'package:cbsa_mobile_app/setup_models.dart/item.dart';
import 'package:cbsa_mobile_app/setup_models.dart/lead_type.dart';
import 'package:cbsa_mobile_app/setup_models.dart/paid_service.dart';
import 'package:cbsa_mobile_app/setup_models.dart/service_provider.dart';
import 'package:cbsa_mobile_app/setup_models.dart/sub_territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/telephone_type.dart';
import 'package:cbsa_mobile_app/setup_models.dart/territory.dart';
import 'package:cbsa_mobile_app/setup_models.dart/toilet_privacy.dart';
import 'package:cbsa_mobile_app/setup_models.dart/toilet_security.dart';
import 'package:cbsa_mobile_app/setup_models.dart/toilet_type.dart';
import 'package:cbsa_mobile_app/setup_models.dart/toilet_type_ca.dart';
import 'package:cbsa_mobile_app/setup_models.dart/user.dart';
import 'package:cbsa_mobile_app/setup_models.dart/work_order.dart';
import 'package:cbsa_mobile_app/setup_models.dart/work_order_item.dart';
import 'package:dio/dio.dart';
import 'package:scoped_model/scoped_model.dart';

class InitialSetupModel extends Model {
  Map _userObject = {};
  List _territories = [];
  List _subTerritories = [];
  List _blocks = [];
  List _leadTypes = [];
  List _informationSources = [];
  List _toiletTypes = [];
  List _serviceProviders = [];
  List _enrollmentReasons = [];
  List _telephoneTypes = [];
  List _paidServices = [];
  List _toiletPrivacy = [];
  List _toiletTypeCA = [];
  List _toiletSecurity = [];
  List _items = [];
  List _workOrders = [];
  List _workOrderItems = [];
  List _healthInspectionSchedules = [];

  Territory _territory = Territory.empty();
  SubTerritory _subTerritory = SubTerritory.empty();
  Block _block = Block.empty();
  LeadType _leadType = LeadType.empty();
  TelephoneType _telephoneType = TelephoneType.empty();
  HealthInspectionSchedule _healthInspectionSchedule;

  // Getters
  Map get userObject => _userObject;
  List get territories => _territories;
  List get subTerritories => _subTerritories;
  List get blocks => _blocks;
  List get leadTypes => _leadTypes;
  List get informationSources => _informationSources;
  List get toiletTypes => _toiletTypes;
  List get serviceProviders => _serviceProviders;
  List get enrollmentReasons => _enrollmentReasons;
  List get telephoneTypes => _telephoneTypes;
  List get paidServices => _paidServices;
  List get toiletPrivacy => _toiletPrivacy;
  List get toiletTypeCA => _toiletTypeCA;
  List get toiletSecurity => _toiletSecurity;
  List get items => _items;
  List get workOrders => _workOrders;
  List get workOrderItems => _workOrderItems;
  List get healthInspectionSchedules => _healthInspectionSchedules;

  Territory get territory => _territory;
  SubTerritory get subTerritory => _subTerritory;
  Block get block => _block;
  LeadType get leadType => _leadType;
  TelephoneType get telephoneType => _telephoneType;
  HealthInspectionSchedule get healthInspectionSchedule => _healthInspectionSchedule;


   // Complaints 
  void fetchComplaintsIntoDb() async {
    var dbClient = DatabaseHelper();
    Response response = await CustomerService.getComplaints();
    List.from(response.data).forEach((i) async {
      await dbClient.saveComplaint(Complaint.fromMap(i));
    });
  }

  // Fetch Interruption Types
  void fetchInterruptionsIntoDb() async {
    var dbClient = DatabaseHelper();
    Response response = await CustomerService.getInterruptionTypes();
    List.from(response.data).forEach((i) async {
      await dbClient.saveInterruptionType(InterruptionType.fromMap(i));
    });
  }

  // Fetch Complaint Types
  void fetchComplaintTypesIntoDb() async {
    var dbClient = DatabaseHelper();
    Response response = await CustomerService.getComplaintTypes();
    List.from(response.data).forEach((i) async {
      await dbClient.saveComplaintType(ComplaintType.fromMap(i));
    });
  }

  // User Object
  Future<int> saveUserObject(UserObject userObject) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteUserObjectTable();
    int a = await dbClient.saveUserObject(userObject);
    notifyListeners();

    return a;
  }
  void fetchUserObject() async {
    var dbClient = DatabaseHelper();
    var result = await dbClient.getUserObject();
    this._userObject = result;

    notifyListeners();
  }

  // Territories
  void saveTerritories(List territoryList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteTerritoriesTable();
    for(var territory in territoryList) {
      await dbClient.saveTerritory(Territory.map(territory));
    }

    notifyListeners();
  }
  void fetchAllTerritories() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllTerritories();
    this._territories = list;

    notifyListeners();
  }
  dynamic getTerritoryId(String name) async {
    var dbClient = DatabaseHelper();
    int id = await dbClient.getTerritoryId(name);
    return id;
  }
  void getTerritory(int territoryId) async {
    var dbClient = DatabaseHelper();
    Territory territory = await dbClient.getTerritory(territoryId);
    this._territory = territory;

    notifyListeners();
  }

  // Sub Territories
  void saveSubTerritories(List subTerritoryList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteSubTerritoriesTable();
    for(int i = 0; i < subTerritoryList.length; i++) {
      await dbClient.saveSubTerritory(SubTerritory.map(subTerritoryList[i]));
    }

    notifyListeners();
  }
  void fetchAllSubTerritories() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllSubTerritories();
    this._subTerritories = list;

    notifyListeners();
  }

  // Blocks
  void saveBlocks(List blockList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteBlocksTable();
    for(int i = 0; i < blockList.length; i++) {
      await dbClient.saveBlock(Block.map(blockList[i]));
    }

    notifyListeners();
  }
  void fetchAllBlocks() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllBlocks();
    this._blocks = list;

    notifyListeners();
  }

  // Lead Types
  void saveLeadTypes(List leadTypeList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteLeadTypesTable();
    for(int i = 0; i < leadTypeList.length; i++) {
      await dbClient.saveLeadType(LeadType.map(leadTypeList[i]));
    }

    notifyListeners();
  }
  void fetchAllLeadTypes() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllLeadTypes();
    this._leadTypes = list;

    notifyListeners();
  }

  // Information Sources
  void saveInformationSources(List informationSourceList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteInformationSourcesTable();
    for(int i = 0; i < informationSourceList.length; i++) {
      await dbClient.saveInformationSource(InformationSource.map(informationSourceList[i]));
    }

    notifyListeners();
  }
  void fetchAllInformationSources() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllInformationSources();
    this._informationSources = list;

    notifyListeners();
  }
  Future<int> getInformationSourceId(String name) async {
    var dbClient = DatabaseHelper();
    int id = await dbClient.getInformationSourceId(name);
    return id;
  }

  // Telephone Service Providers
  void saveServiceProviders(List serviceProvidersList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteServiceProvidersTable();
    for(int i = 0; i < serviceProvidersList.length; i++) {
      await dbClient.saveServiceProvider(ServiceProvider.map(serviceProvidersList[i]));
    }

    notifyListeners();
  }
  void fetchAllServiceProviders() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllServiceProviders();
    this._serviceProviders = list;

    notifyListeners();
  }

  // Toilet Types
  void saveToiletTypes(List toiletTypeList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteToiletTypesTable();
    for(int i = 0; i < toiletTypeList.length; i++) {
      await dbClient.saveToiletType(ToiletType.map(toiletTypeList[i]));
    }

    notifyListeners();
  }
  void fetchAllToiletTypes() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllToiletTypes();
    this._toiletTypes = list;

    notifyListeners();
  }

  // Enrollment Reasons
  void saveEnrollmentReasons(List enrollmentReasonList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteEnrollmentReasonsTable();
    for(int i = 0; i < enrollmentReasonList.length; i++) {
      await dbClient.saveEnrollmentReason(EnrollmentReason.map(enrollmentReasonList[i]));
    }

    notifyListeners();
  }
  void fetchAllEnrollmentReasons() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllEnrollmentReasons();
    this._enrollmentReasons = list;

    notifyListeners();
  }
  Future<int> getEnrollmentReasonId(String name) async {
    var dbClient = DatabaseHelper();
    int id = await dbClient.getEnrollmentReasonId(name);
    return id;
  }

  // Telephone Types
  void saveTelephoneTypes(List telephoneTypeList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteTelephoneTypesTable();
    for(int i = 0; i < telephoneTypeList.length; i++) {
      await dbClient.saveTelephoneType(TelephoneType.map(telephoneTypeList[i]));
    }

    notifyListeners();
  }
  void fetchAllTelephoneTypes() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllTelephoneTypes();
    this._telephoneTypes = list;

    notifyListeners();
  }

  // Paid Services
  void savePaidServices(List paidServicesList) async {
    var dbClient = DatabaseHelper();
    dbClient.deletePaidServicesTable();
    for(int i = 0; i < paidServicesList.length; i++) {
      await dbClient.savePaidService(PaidService.map(paidServicesList[i]));
    }

    notifyListeners();
  }
  void fetchAllPaidServices() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllPaidServices();
    this._paidServices = list;
    print(list);

    notifyListeners();
  }
  Future<int> getPaidServiceId(String name) async {
    var dbClient = DatabaseHelper();
    int id = await dbClient.getPaidServiceId(name);
    return id;
  }

  // Toilet Privacy
  void saveToiletPrivacy(List toiletPrivacyList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteToiletPrivacyTable();
    for(int i = 0; i < toiletPrivacyList.length; i++) {
      await dbClient.saveToiletPrivacy(ToiletPrivacy.map(toiletPrivacyList[i]));
    }

    notifyListeners();
  }
  void fetchAllToiletPrivacy() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllToiletPrivacy();
    this._toiletPrivacy = list;
    print(list);

    notifyListeners();
  }
  Future<int> getToiletPrivacyId(String name) async {
    var dbClient = DatabaseHelper();
    int id = await dbClient.getToiletPrivacyId(name);
    return id;
  }

  // Toilet Type
  void saveToiletTypesCA(List toiletTypeList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteToiletTypeCATable();
    for(int i = 0; i < toiletTypeList.length; i++) {
      await dbClient.saveToiletTypeCA(ToiletTypeCA.map(toiletTypeList[i]));
    }

    notifyListeners();
  }
  void fetchAllToiletTypesCA() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllToiletTypeCA();
    this._toiletTypeCA = list;
    print(list);

    notifyListeners();
  }
  Future<int> getToiletTypeIdCA(String name) async {
    var dbClient = DatabaseHelper();
    int id = await dbClient.getToiletTypeIdCA(name);
    return id;
  }

  // Toilet Security
  void saveToiletSecurity(List toiletSecurityList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteToiletSecurityTable();
    for(int i = 0; i < toiletSecurityList.length; i++) {
      await dbClient.saveToiletSecurity(ToiletSecurity.map(toiletSecurityList[i]));
    }

    notifyListeners();
  }
  void fetchAllToiletSecurity() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllToiletSecurity();
    this._toiletSecurity = list;
    print(list);

    notifyListeners();
  }
  Future<int> getToiletSecurityId(String name) async {
    var dbClient = DatabaseHelper();
    int id = await dbClient.getToiletSecurityId(name);
    return id;
  }

  // Items
  void saveItems(List itemList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteItemsTable();
    for(int i = 0; i < itemList.length; i++) {
      await dbClient.saveItem(Item.map(itemList[i]));
    }

    notifyListeners();
  }
  void fetchAllItems() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllItems();
    this._items = list;
    print(list);

    notifyListeners();
  }
  Future<int> getItemId(String name) async {
    var dbClient = DatabaseHelper();
    int id = await dbClient.getItemId(name);
    return id;
  }

  // Work Orders
  void saveWorkOrders(List workOrderList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteWorkOrdersTable();
    for(int i = 0; i < workOrderList.length; i++) {
      await dbClient.saveWorkOrder(WorkOrder.map(workOrderList[i]));
    }

    notifyListeners();
  }
  void fetchAllWorkOrders() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllWorkOrders();
    this._workOrders = list;
    print(list);

    notifyListeners();
  }
  Future<int> getWorkOrderId(String name) async {
    var dbClient = DatabaseHelper();
    int id = await dbClient.getWorkOrderId(name);
    return id;
  }

  // Work Order Items
  void saveWorkOrderItems(List workOrderItemList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteWorkOrderItemsTable();
    for(int i = 0; i < workOrderItemList.length; i++) {
      await dbClient.saveWorkOrderItem(WorkOrderItem.map(workOrderItemList[i]));
    }

    notifyListeners();
  }
  void fetchAllWorkOrderItems() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllWorkOrderItems();
    this._workOrderItems = list;
    print(list);

    notifyListeners();
  }
  Future<int> getWorkOrderItemId(String name) async {
    var dbClient = DatabaseHelper();
    int id = await dbClient.getWorkOrderItemId(name);
    return id;
  }

  // Leads
  void saveLeads(List leadList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteLeadsTable();
    for(int i = 0; i < leadList.length; i++) {
      await dbClient.saveLead(Lead.map(leadList[i]));
    }
    notifyListeners();
  }

  // Health Inspection Schedules
  void saveHealthInspectionSchedules(List healthInspectionSchedules) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteHealthInspectionSchedulesTable();
    for(var territory in healthInspectionSchedules) {
      await dbClient.saveHealthInspectionSchedule(HealthInspectionSchedule.map(territory));
    }

    notifyListeners();
  }
  void fetchAllHealthInspectionSchedules() async {
    var dbClient = DatabaseHelper();
    List list = await dbClient.getAllHealthInspectionSchedules();
    this._healthInspectionSchedules = list;

    notifyListeners();
  }
  void getHealthInspectionSchedule(int subTerritoryId) async {
    var dbClient = DatabaseHelper();
    HealthInspectionSchedule healthInspectionSchedule = await dbClient.getHealthInspectionSchedule(subTerritoryId);
    this._healthInspectionSchedule = healthInspectionSchedule;

    notifyListeners();
  }
  void getSubterritoryHISchedule(int subTerritoryId) async {
    var dbClient = DatabaseHelper();
    HealthInspectionSchedule healthInspectionSchedule = await dbClient.getSubterritoryHISchedule(subTerritoryId);
    this._healthInspectionSchedule = healthInspectionSchedule;

    notifyListeners();
  }

  // Lead Conversions
  void saveLeadConversions(List leadConversionList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteLeadConversionsTable();
    for(int i = 0; i < leadConversionList.length; i++) {
      await dbClient.saveLeadConversion(LeadConversion.map(leadConversionList[i]));
    }
    
    notifyListeners();
  }

  // Customers
  void saveCustomers(List customersList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteCustomersTable();
    for(int i = 0; i < customersList.length; i++) {
      await dbClient.saveCustomer(Customer.map(customersList[i]));
    }
    
    notifyListeners();
  }

  // Toilet Installations
  void saveToiletInstallations(List installationsList) async {
    var dbClient = DatabaseHelper();
    dbClient.deleteToiletInstallationTable();
    for(int i = 0; i < installationsList.length; i++) {
      await dbClient.saveToiletInstallation(ToiletInstallationModel.map(installationsList[i]));
    }
    
    notifyListeners();
  }
}