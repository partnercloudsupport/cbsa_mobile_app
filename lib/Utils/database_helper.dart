import 'dart:async';

import 'package:cbsa_mobile_app/models/complaintModel.dart';
import 'package:cbsa_mobile_app/models/complaintTypeModel.dart';
import 'package:cbsa_mobile_app/models/customer.dart';
import 'package:cbsa_mobile_app/models/direct_order.dart';
import 'package:cbsa_mobile_app/models/followUp.dart';
import 'package:cbsa_mobile_app/models/health_inspection.dart';
import 'package:cbsa_mobile_app/models/health_inspection_customer.dart';
import 'package:cbsa_mobile_app/models/interruptionTypeModel.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/lead_conversion.dart';
import 'package:cbsa_mobile_app/models/order.dart';
import 'package:cbsa_mobile_app/models/payment.dart';
import 'package:cbsa_mobile_app/models/sa_work_order.dart';
import 'package:cbsa_mobile_app/models/setup.dart';
import 'package:cbsa_mobile_app/models/task.dart';
import 'package:cbsa_mobile_app/models/toilet_installation.dart';
import 'package:cbsa_mobile_app/models/toilet_servicing.dart';
import 'package:cbsa_mobile_app/models/user.dart';
import 'package:cbsa_mobile_app/models/work_order.dart';
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
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
 static final DatabaseHelper _instance = new DatabaseHelper.internal();
 
  factory DatabaseHelper() => _instance;
 
 //Tasks
  final String tableTasks = 'Tasks';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnDescription = 'description';
  final String columnDueDate = 'duedate';
  final String columnStatus = 'status';
  final String columnAssignedTo = 'assignedto';
  final String columnCreatedBy = 'createdby';
  final String columnLeadId = 'leadid';
  //Leads
  final String tableLeads = 'Leads';
  final String columnfirstName = 'firstName';
  final String columnLastName = 'lastName';
  final String columnOtherNames = 'otherNames';
  final String columnTerritory = 'territory';
  final String columnSubTerritory = 'subTerritory';
  final String columnBlock ='block';
  final String columnGender ='gender';
  final String columnPrimaryTelephone ='primaryTelephone';
  final String columnSecondaryTelephone ='secondaryTelephone';
  final String columnReferredBy='referredBy';
  final String columnToiletType ='toiletType';
  final String columnNoOfToilets ='noOfToilets';
  final String columnNoOfMaleAdults = 'noOfMaleAdults';
  final String columnNoOfFemaleAdults = 'noOfFemaleAdults';
  final String columnNoOfMaleChildren = 'noOfMaleChildren';
  final String columnNoOfFemaleChildren = 'noOfFemaleChildren';
  final String columnLatitude = 'latitude';
  final String columnLongitude = 'longitude';
  final String columnInfoSourceSelected = 'infoSourceSelected';
  final String columnLeadType = 'leadType';
  final String columnDisability = 'disability';
  final String columnReasonsSelected = 'reasonsSelected';
  final String columnComment = 'comments';
  final String columnServiceProvider = 'serviceProvider';
  final String columnTelephoneType = 'telephoneType';
  final String columnSalariedWorker = 'salariedWorker';
  final String columnPaymentDate = 'paymentDate';
  final String columnServicesSelected = 'servicesSelected';
  final String columnTypeSelected = 'typeSelected';
  final String columnSecuritySelected = 'securitySelected';
  final String columnPrivacySelected = 'privacySelected';
  final String columnFollowUpDate = 'followUpDate';
  final String columnInstallDate = 'installDate';
  final String columnSiteInspectionDate = 'siteInspectionDate';
  final String columnAddress = 'address';
  final String columnStartTime = 'startTime';
  final String columnEndTime = 'endTime'; 
  final String columnArchived = 'archived';
  final String columnArchiveDate = 'archiveDate';
  final String columnArchiveStage = 'archiveStage';
 
  //Follow Ups
  final String tableFollowUps = 'FollowUp';
  final String columnUpdatedAt = 'updated_at';
  final String columncomment = 'comment';
  final String columnCreatedAt = 'created_at';
  final String columnIsSpacePrepared = 'isspaceprepared';
  final String columnSpacePrepareState = 'spacepreparestate';
  final String columnPayState = 'paystate';
  final String columnIsInterested = 'isinterested';
  final String columnFollowupDate = 'folupdate';
  final String columnType = 'type';
  final String columnIsPresent = 'ispresent';
  final String columnInspectionDate = "inspectiondate";
  final String columnInstallationDate = 'installdate';
  // final String columnAssignedTo = 'assignedto';
  // final String columnCreatedBy ='createdby';
  final String columnWasLeadReached = 'wasleadreached';
  //Lead Conversion
  final String tableLeadConversion ='LeadConversion';
  final String customerImage = 'customerImage';
  final String houseHoldImage = 'houseHoldImage';
  final String landmarkImage = 'landmarkImage';
  final String mobileMoneyCode = 'mobileMoneyCode';
  final String payer = 'payer';
  final String payerFirstName ='payerFirstName';
  final String payerLastName ='payerLastName';
  final String relationship ='relationship';
  final String payerPrimaryPhoneNumber = 'payerPrimaryPhoneNumber';
  final String payerSecondaryPhoneNumber ='payerSecondaryPhoneNumber';
  final String payerOccupation = 'payerOccupation';
  final String paymentMethodSelected = 'paymentMethodSelected';
  final String documentPath  ='documentPath';
  final String accountId = 'accountId';
  final String date ='date';
  final String leadId = 'leadId';
  final String createdBy ='createdBy';
  //DirectOrder
  final String tableDirectOrder ='DirectOrder';
  //Setup
  final String tableSetup = 'setup';
  final String columnOrganizationName ='organizationName';
  final String columnSubDomain ='subDomain';
  final String columnLanguage ='language';
  //User 
  final String tableUser = 'User';
  final String columnUserId = 'userId';
  final String columnUsername = 'username';
  final String columnEmail = 'email';
  final String columnPassword = 'password';
  final String columnToken = 'token';


  static Database _db;
 
  DatabaseHelper.internal();
 
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
 
  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'cbsa.db');
      await deleteDatabase(path); 
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
 
  void _onCreate(Database db, int newVersion) async {
    // LEADS TABLE
    await db.execute(
      'CREATE TABLE leads(id INTEGER PRIMARY KEY, fname TEXT, lname TEXT, onames TEXT, uuid TEXT, ' +
      'terrisectownid INTEGER, subterrizonecomid INTEGER, block INTEGER, gender TEXT, pritelephone TEXT, sectelephone TEXT, ' +
      'referredby TEXT, toilettypeid INTEGER, numoftoilets INTEGER, numofmaleadults INTEGER, numoffemaleadults INTEGER, ' + 
      'numofmalechild INTEGER, numofemalechild INTEGER, lat DOUBLE, lng DOUBLE, soofinfo TEXT, ' +
      'leadtype INTEGER, disability TEXT, resofenroll TEXT, status TEXT, follupdate TEXT, inspectiondate TEXT, installdate TEXT, comments TEXT, created_by INTEGER, teleserpro INTEGER, ' +
      'teletype INTEGER, issalworker TEXT, dateofpay INTEGER, opaidservices TEXT, toiletprivacy TEXT, toilettype TEXT, toiletsecu TEXT, ' +
      'type TEXT, approved INTEGER, archived INTEGER, archivedat TEXT, archiveddate TEXT, address TEXT, created_at TEXT, updated_at TEXT)'
    );
    // LEADS CONVERSION TABLE
    await db.execute(
      'CREATE TABLE leadconversions(id INTEGER PRIMARY KEY, leadid INTEGER, dateofconv TEXT, mobilemoneycode TEXT, ' +
      'payeefname TEXT, payeelname TEXT, relationship TEXT, payeepritele TEXT, payeesectele TEXT, payeeoccupation TEXT, ' +
      'paymentmethod TEXT, createdby INTEGER, householdsavings TEXT, prioccupation TEXT, secoccupation TEXT, ' +
      'homeownership TEXT, customerimageurl TEXT, landmarkimageurl TEXT, householdimageurl TEXT, status INTEGER, ' +
      'created_at TEXT, updated_at TEXT)'
    );
    // ORDERS TABLE
    await db.execute(
      'CREATE TABLE orders(id INTEGER PRIMARY KEY, leadid INTEGER, type TEXT, inspectiondate TEXT, installationdate TEXT, ' +
      'status INTEGER, accountnumber TEXT, createdby INTEGER, created_at TEXT, updated_at TEXT)'
    );
    // ASSIGNED WORK ORDERS TABLE
    await db.execute(
      'CREATE TABLE assignedWorkOrders(id INTEGER PRIMARY KEY, fname TEXT, lname TEXT, onames TEXT, uuid TEXT, ' +
      'terrisectownid INTEGER, subterrizonecomid INTEGER, block INTEGER, gender TEXT, pritelephone TEXT, sectelephone TEXT, ' +
      'referredby TEXT, toilettypeid INTEGER, numoftoilets INTEGER, numofmaleadults INTEGER, numoffemaleadults INTEGER, ' + 
      'numofmalechild INTEGER, numofemalechild INTEGER, lat DOUBLE, lng DOUBLE, soofinfo TEXT, ' +
      'leadtype INTEGER, disability TEXT, resofenroll TEXT, status TEXT, follupdate TEXT, inspectiondate TEXT, installdate TEXT, comments TEXT, created_by INTEGER, teleserpro INTEGER, ' +
      'teletype INTEGER, issalworker TEXT, dateofpay INTEGER, opaidservices TEXT, toiletprivacy TEXT, toilettype TEXT, toiletsecu TEXT, ' +
      'type TEXT, approved INTEGER, archived INTEGER, archivedat TEXT, archiveddate TEXT, address TEXT, created_at TEXT, updated_at TEXT, workorderid INTEGER, installationdate TEXT)'
    );
    // APPROVED LEADS WORK ORDERS TABLE
    await db.execute(
      'CREATE TABLE secondaryApprovalWorkOrders(id INTEGER PRIMARY KEY, fname TEXT, lname TEXT, onames TEXT, uuid TEXT, ' +
      'terrisectownid INTEGER, subterrizonecomid INTEGER, block INTEGER, gender TEXT, pritelephone TEXT, sectelephone TEXT, ' +
      'referredby TEXT, toilettypeid INTEGER, numoftoilets INTEGER, numofmaleadults INTEGER, numoffemaleadults INTEGER, ' + 
      'numofmalechild INTEGER, numofemalechild INTEGER, lat DOUBLE, lng DOUBLE, soofinfo TEXT, ' +
      'leadtype INTEGER, disability TEXT, resofenroll TEXT, status TEXT, follupdate TEXT, inspectiondate TEXT, installdate TEXT, comments TEXT, created_by INTEGER, teleserpro INTEGER, ' +
      'teletype INTEGER, issalworker TEXT, dateofpay INTEGER, opaidservices TEXT, toiletprivacy TEXT, toilettype TEXT, toiletsecu TEXT, ' +
      'type TEXT, approved INTEGER, archived INTEGER, archivedat TEXT, archiveddate TEXT, address TEXT, created_at TEXT, updated_at TEXT, workorderid INTEGER, transportdate TEXT)'
    );
    // CUSTOMERS TABLE
    await db.execute(
      'CREATE TABLE customers(id INTEGER PRIMARY KEY, leadid INTEGER, dateofconv TEXT, accountnumber TEXT, status INTEGER, updated_at TEXT, created_at TEXT)'
    );
    // BARREL COUNT TABLE
    await db.execute(
      '''CREATE TABLE BarrelCount($columnId INTEGER PRIMARY KEY, userid INTEGER,wastecolid INTEGER,recordedon TEXT,numofbarrels INTEGER,
      emptyreturned INTEGER, emptyfilled INTEGER, serverid INTEGER)'''
    );
    // HEALTH INSPECTION CUSTOMERS
    await db.execute(
      'CREATE TABLE healthInspectionCustomers(id INTEGER PRIMARY KEY, customerid INTEGER, fname TEXT, lname TEXT, onames TEXT, uuid TEXT, ' +
      'terrisectownid INTEGER, subterrizonecomid INTEGER, block INTEGER, gender TEXT, pritelephone TEXT, sectelephone TEXT, ' +
      'referredby TEXT, toilettypeid INTEGER, numoftoilets INTEGER, numofmaleadults INTEGER, numoffemaleadults INTEGER, ' + 
      'numofmalechild INTEGER, numofemalechild INTEGER, lat DOUBLE, lng DOUBLE, soofinfo TEXT, ' +
      'leadtype INTEGER, disability TEXT, resofenroll TEXT, status TEXT, follupdate TEXT, inspectiondate TEXT, installdate TEXT, comments TEXT, created_by INTEGER, teleserpro INTEGER, ' +
      'teletype INTEGER, issalworker TEXT, dateofpay INTEGER, opaidservices TEXT, toiletprivacy TEXT, toilettype TEXT, toiletsecu TEXT, ' +
      'type TEXT, approved INTEGER, archived INTEGER, archivedat TEXT, archiveddate TEXT, address TEXT, created_at TEXT, updated_at TEXT)'
    );
    // TOILET INSTALLATIONS
    await db.execute(
      'CREATE TABLE toiletInstallation(id INTEGER PRIMARY KEY, leadid INTEGER, userid INTEGER, date TEXT, qrcode TEXT, serialno TEXT, items TEXT, toiletimage TEXT)'
    );
    // PAYMENTS
    await db.execute(
      'CREATE TABLE payments(id INTEGER PRIMARY KEY, customerId INTEGER, accountId TEXT, dateOfPayment TEXT, amount TEXT, paymentType TEXT)'
    );
    // SERVICE INTERRUPTION TYPE TABLE
    await db.execute(
      '''CREATE TABLE InterruptionType($columnId INTEGER PRIMARY KEY, name TEXT,description TEXT,imageurl TEXT,status INTEGER,created_at TEXT,updated_at TEXT)'''
    );
    // COMPLAINT TYPE TABLE
    await db.execute(
      '''CREATE TABLE ComplaintType($columnId INTEGER PRIMARY KEY, name TEXT,description TEXT,status INTEGER,created_by INTEGER,updated_by INTEGER,created_at TEXT,updated_at TEXT)'''
    );
    // COMPLAINT TABLE
    await db.execute(
      '''CREATE TABLE Complaints($columnId INTEGER PRIMARY KEY, customerid INTEGER,complaintypeid INTEGER,escalatedto INTEGER,status INTEGER,created_by INTEGER,complain TEXT,comment TEXT,reaction TEXT,created_at TEXT,updated_at TEXT)'''
    );



    await db.execute(
        '''CREATE TABLE $tableTasks($columnId INTEGER PRIMARY KEY, $columnName TEXT,
        $columnDescription TEXT,$columnDueDate TEXT,$columnStatus INTEGER,$columnAssignedTo INTEGER,
        $columnCreatedBy INTEGER,$columnLeadId INTEGER)''');
    // await db.execute(
    //     '''CREATE TABLE $tableLeads($columnId INTEGER PRIMARY KEY, $columnfirstName TEXT, 
    //     $columnLastName TEXT,$columnOtherNames TEXT,$columnTerritory INTEGER,$columnSubTerritory INTEGER,
    //     $columnBlock TEXT,$columnGender TEXT,$columnPrimaryTelephone TEXT,$columnSecondaryTelephone TEXT,
    //     $columnReferredBy TEXT,$columnToiletType INTEGER,$columnNoOfToilets INTEGER,$columnNoOfMaleAdults INTEGER,
    //     $columnNoOfFemaleAdults INTEGER,$columnNoOfMaleChildren INTEGER,$columnNoOfFemaleChildren INTEGER,
    //     $columnLatitude DOUBLE,$columnLongitude DOUBLE,$columnInfoSourceSelected BLOB,$columnLeadType INTEGER,
    //     $columnDisability TEXT,$columnReasonsSelected BLOB,$columnStatus TEXT,$columnComment TEXT, $columnCreatedBy TEXT,
    //     $columnServiceProvider TEXT,$columnTelephoneType TEXT,$columnSalariedWorker TEXT,
    //     $columnPaymentDate TEXT,$columnServicesSelected BLOB,$columnTypeSelected BLOB,$columnSecuritySelected BLOB,
    //     $columnPrivacySelected BLOB,$columnFollowUpDate TEXT,$columnInstallDate TEXT,$columnSiteInspectionDate TEXT,
    //     $columnAddress TEXT,$columnStartTime TEXT,$columnEndTime TEXT,$columnArchived INTEGER,$columnArchiveDate TEXT,$columnArchiveStage TEXT)
    //     ''');
await db.execute(
        '''CREATE TABLE $tableFollowUps($columnId INTEGER PRIMARY KEY, $columnLeadId INTEGER,$columnWasLeadReached TEXT,
        $columnCreatedBy TEXT, $columnAssignedTo INTEGER, $columnIsPresent INTEGER,$columnType TEXT,$columnFollowupDate TEXT, 
        $columnIsInterested TEXT, $columncomment TEXT,$columnPayState TEXT, $columnSpacePrepareState TEXT,
        $columnIsSpacePrepared TEXT, $columnCreatedAt TEXT,$columnUpdatedAt TEXT,$columnInspectionDate TEXT, $columnInstallationDate TEXT)''');    
await db.execute(
      '''CREATE TABLE $tableLeadConversion($columnId INTEGER PRIMARY KEY, $customerImage BLOB, $houseHoldImage BLOB,
        $landmarkImage BLOB,$mobileMoneyCode TEXT,$payer TEXT,$payerFirstName TEXT,$payerLastName TEXT,
        $relationship TEXT, $payerPrimaryPhoneNumber TEXT,$payerSecondaryPhoneNumber TEXT,$payerOccupation TEXT,
        $paymentMethodSelected BLOB,$documentPath BLOB,$accountId TEXT,$date TEXT,$leadId INTEGER,$createdBy INTEGER)''');
    await db.execute(
      '''CREATE TABLE $tableDirectOrder($columnId INTEGER PRIMARY KEY, $columnfirstName TEXT, 
        $columnLastName TEXT,$columnOtherNames TEXT,$columnTerritory TEXT,$columnSubTerritory TEXT,
        $columnBlock TEXT,$columnGender TEXT,$columnPrimaryTelephone TEXT,$columnSecondaryTelephone TEXT,
        $columnReferredBy TEXT,$columnToiletType TEXT,$columnNoOfToilets INTEGER,$columnNoOfMaleAdults INTEGER,
        $columnNoOfFemaleAdults INTEGER,$columnNoOfMaleChildren INTEGER,$columnNoOfFemaleChildren INTEGER,
        $columnLatitude DOUBLE,$columnLongitude DOUBLE,$columnInfoSourceSelected BLOB,$columnLeadType TEXT,
        $columnDisability TEXT,$columnReasonsSelected BLOB,$columnStatus TEXT,$columnComment TEXT,
        $columnServiceProvider TEXT,$columnTelephoneType TEXT,$columnSalariedWorker TEXT,
        $columnPaymentDate TEXT,$columnServicesSelected BLOB,$columnTypeSelected BLOB,$columnSecuritySelected BLOB,
        $columnPrivacySelected BLOB,$columnFollowUpDate TEXT,$columnInstallDate TEXT,$columnSiteInspectionDate TEXT,
        $columnAddress TEXT,$columnStartTime TEXT,$columnEndTime TEXT,$columnArchived INTEGER,$columnArchiveDate TEXT,$columnArchiveStage TEXT,
      $customerImage BLOB, $houseHoldImage BLOB,
        $landmarkImage BLOB,$mobileMoneyCode TEXT,$payer TEXT,$payerFirstName TEXT,$payerLastName TEXT,
        $relationship TEXT, $payerPrimaryPhoneNumber TEXT,$payerSecondaryPhoneNumber TEXT,$payerOccupation TEXT,
        $paymentMethodSelected BLOB,$documentPath BLOB,$accountId TEXT,$date TEXT,$createdBy INTEGER)''');
    await db.execute(
        '''CREATE TABLE $tableSetup($columnId INTEGER PRIMARY KEY, $columnfirstName TEXT, $columnLastName TEXT,
        $columnOrganizationName TEXT, $columnLanguage TEXT, $columnSubDomain TEXT)''');
    await db.execute(
        '''CREATE TABLE $tableUser($columnId INTEGER PRIMARY KEY, $columnUserId INTEGER, $columnUsername TEXT, $columnEmail TEXT,
        $columnPassword TEXT, $columnToken TEXT)''');

    // Initial Set Up Tables

    // user table
    await db.execute('CREATE TABLE userObject(id INTEGER PRIMARY KEY, user_id INTEGER, name TEXT, email TEXT, email_verified_at TEXT, status INTEGER, position TEXT, activation_token TEXT, created_at TEXT, updated_at TEXT)');
    
    // territories table
    await db.execute('CREATE TABLE territories(id INTEGER PRIMARY KEY, territory_id INTEGER, name TEXT, description TEXT, status INTEGER, created_by INTEGER, updated_by INTEGER, created_at TEXT, updated_at TEXT)');
    
    // sub-territories table
    await db.execute('CREATE TABLE subTerritories(id INTEGER PRIMARY KEY, subterritory_id INTEGER, territory_id INTEGER, name TEXT, description TEXT, status INTEGER, created_by INTEGER, updated_by INTEGER, created_at TEXT, updated_at TEXT)');
    
    // blocks table
    await db.execute('CREATE TABLE blocks(id INTEGER PRIMARY KEY, block_id INTEGER, subterritory_id INTEGER, name TEXT, description TEXT, status INTEGER, created_by INTEGER, updated_by INTEGER, created_at TEXT, updated_at TEXT)');
    
    // lead types table
    await db.execute('CREATE TABLE leadTypes(id INTEGER PRIMARY KEY, lead_id INTEGER, name TEXT, description TEXT, status INTEGER, created_by INTEGER, updated_by INTEGER, created_at TEXT, updated_at TEXT)');
    
    // information sources table
    await db.execute('CREATE TABLE informationSources(id INTEGER PRIMARY KEY, information_source_id INTEGER, name TEXT, description TEXT, status INTEGER, created_by INTEGER, updated_by INTEGER, created_at TEXT, updated_at TEXT)');
    
    // service providers table
    await db.execute('CREATE TABLE serviceProviders(id INTEGER PRIMARY KEY, service_provider_id INTEGER, name TEXT, description TEXT, status INTEGER, created_by INTEGER, updated_by INTEGER, created_at TEXT, updated_at TEXT)');

    // toilet types table
    await db.execute('CREATE TABLE toiletTypes(id INTEGER PRIMARY KEY, toilet_type_id INTEGER, name TEXT, description TEXT, unitPrice INTEGER, status INTEGER, created_by INTEGER, updated_by INTEGER, created_at TEXT, updated_at TEXT)');
    
    // enrollment reasons table
    await db.execute('CREATE TABLE enrollmentReasons(id INTEGER PRIMARY KEY, enrollment_reason_id INTEGER, name TEXT, description TEXT, status INTEGER, created_by INTEGER, updated_by INTEGER, created_at TEXT, updated_at TEXT)');
    
    // telephone types table
    await db.execute('CREATE TABLE telephoneTypes(id INTEGER PRIMARY KEY, telephone_type_id INTEGER, name TEXT, description TEXT, status INTEGER, created_by INTEGER, updated_by INTEGER, created_at TEXT, updated_at TEXT)');
    
    // other paid services table
    await db.execute('CREATE TABLE paidServices(id INTEGER PRIMARY KEY, paid_service_id INTEGER, name TEXT, description TEXT, status INTEGER, created_by INTEGER, updated_by INTEGER, created_at TEXT, updated_at TEXT)');
    
    // toilet privacy table
    await db.execute('CREATE TABLE toiletPrivacy(id INTEGER PRIMARY KEY, toilet_privacy_id INTEGER, name TEXT, description TEXT, status INTEGER, created_by INTEGER, updated_by INTEGER, created_at TEXT, updated_at TEXT)');
    
    // // toilet type table
    await db.execute('CREATE TABLE toiletType(id INTEGER PRIMARY KEY, toilet_type_id INTEGER, name TEXT, description TEXT, status INTEGER, created_by INTEGER, updated_by INTEGER, created_at TEXT, updated_at TEXT)');
    
    // toilet security table
    await db.execute('CREATE TABLE toiletSecurity(id INTEGER PRIMARY KEY, toilet_security_id INTEGER, name TEXT, description TEXT, status INTEGER, created_by INTEGER, updated_by INTEGER, created_at TEXT, updated_at TEXT)');

    // items table
    await db.execute('CREATE TABLE items(id INTEGER PRIMARY KEY, item_id INTEGER, name TEXT, description TEXT, status INTEGER, created_by INTEGER, updated_by INTEGER, created_at TEXT, updated_at TEXT)');

    // work orders table
    await db.execute('CREATE TABLE workOrders(id INTEGER PRIMARY KEY, work_order_id INTEGER, name TEXT, description TEXT, toilet_type_id INTEGER, status INTEGER, qr_code TEXT, image_url TEXT, created_by INTEGER, created_at TEXT, updated_at TEXT)');

    // work order items table
    await db.execute('CREATE TABLE workOrderItems(id INTEGER PRIMARY KEY, work_order_item_id INTEGER, work_order_id INTEGER, item_id INTEGER, quantity INTEGER, status INTEGER, created_at TEXT, updated_at TEXT)');

    // health inspection schedules table
    await db.execute('CREATE TABLE healthInspectionSchedules(id INTEGER PRIMARY KEY, subterritory_id INTEGER, assigned_to INTEGER, repetitive TEXT, interval TEXT, inspection_day TEXT, start_date TEXT, created_at TEXT, updated_at TEXT)');
  }

  // Initial Set Up Tables CRUD Actions
  // User Table
  // Insert
  Future saveUserObject(UserObject userObject) async {
    var dbClient = await db;
    var result = await dbClient.insert('userObject', userObject.toMap());
    return result;
  }
  // Read
  Future<Map> getUserObject() async {
    var dbClient = await db;
    var result = await dbClient.query('userObject');
    return result.first;
  }
  // Delete
  void deleteUserObjectTable() async {
    var dbClient = await db;
    dbClient.delete('userObject');
  }
  // 

  // Territories Table
  // Insert
  Future saveTerritory(Territory territory) async {
    var dbClient = await db;
    // dbClient.delete('territories');
    var result = await dbClient.insert('territories', territory.toMap());
    return result;
  }
  // Read
  Future<List> getAllTerritories() async {
    var dbClient = await db;
    var result = await dbClient.query('territories');
    return result.toList();
  }
  Future<Territory> getTerritory(int territoryId) async {
    var dbClient = await db;
    var result = await dbClient.query('territories', where: 'territory_id = ?', whereArgs: [territoryId]);
    if(result.length > 0) {
      return Territory.map(result.first);
    }
    return null;
  }
  dynamic getTerritoryId(String name) async {
    var dbClient = await db;
    var result = await dbClient.query('territories', where: 'name = ?', whereArgs: [name]);
    if(result.length > 0) {
      return result.first['territory_id'];
    }
    return null;
  }
  // Delete
  void deleteTerritoriesTable() async {
    var dbClient = await db;
    dbClient.delete('territories');
  }
  // 

  // Sub Territories Table
  // Insert
  Future saveSubTerritory(SubTerritory subTerritory) async {
    var dbClient = await db;
    // dbClient.delete('subTerritories');
    var result = await dbClient.insert('subTerritories', subTerritory.toMap());
    return result;
  }
  // Read
  Future<List> getAllSubTerritories() async {
    var dbClient = await db;
    var result = await dbClient.query('subTerritories');
    return result.toList();
  }
  Future<SubTerritory> getSubTerritory(int subTerritoryId) async {
    var dbClient = await db;
    var result = await dbClient.query('subTerritories', where: 'subterritory_id = ?', whereArgs: [subTerritoryId]);
    if(result.length > 0) {
      return SubTerritory.map(result.first);
    }
    return null;
  }
  // Delete
  void deleteSubTerritoriesTable() async {
    var dbClient = await db;
    dbClient.delete('subTerritories');
  }
  // 

  // Blocks Table
  // Insert
  Future saveBlock(Block block) async {
    var dbClient = await db;
    // dbClient.delete('blocks');
    var result = await dbClient.insert('blocks', block.toMap());
    return result;
  }
  // Read
  Future<List> getAllBlocks() async {
    var dbClient = await db;
    var result = await dbClient.query('blocks');
    return result.toList();
  }
  Future<Block> getBlock(int blockId) async {
    var dbClient = await db;
    var result = await dbClient.query('blocks', where: 'block_id = ?', whereArgs: [blockId]);
    if(result.length > 0) {
      return Block.map(result.first);
    }
    return null;
  }
  // Delete
  void deleteBlocksTable() async {
    var dbClient = await db;
    dbClient.delete('blocks');
  }
  // 

  // Lead Types Table
  // Insert
  Future saveLeadType(LeadType leadType) async {
    var dbClient = await db;
    // dbClient.delete('leadTypes');
    var result = await dbClient.insert('leadTypes', leadType.toMap());
    return result;
  }
  // Read
  Future<List> getAllLeadTypes() async {
    var dbClient = await db;
    var result = await dbClient.query('leadTypes');
    return result.toList();
  }
  Future<LeadType> getLeadType(int id) async {
    var dbClient = await db;
    var result = await dbClient.query('leadTypes', where: 'id = ?', whereArgs: [id]);
    return LeadType.map(result.first);
  }
  // Delete
  void deleteLeadTypesTable() async {
    var dbClient = await db;
    dbClient.delete('leadTypes');
  }
  // 

  // Information Sources Table
  // Insert
  Future saveInformationSource(InformationSource informationSource) async {
    var dbClient = await db;
    // dbClient.delete('informationSources');
    var result = await dbClient.insert('informationSources', informationSource.toMap());
    return result;
  }
  // Read
  Future<List> getAllInformationSources() async {
    var dbClient = await db;
    var result = await dbClient.query('informationSources');
    return result.toList();
  }

  Future<InformationSource> getInformationSource(int id) async {
    var dbClient = await db;
    var result = await dbClient.query('informationSources', where: 'id = ?', whereArgs: [id]);
    if(result.length > 0) {
      return InformationSource.map(result.first);
    }
    return null;
  }

  Future<int> getInformationSourceId(String name) async {
    var dbClient = await db;
    var result = await dbClient.query('informationSources', where: 'name = ?', whereArgs: [name]);
    if(result.length > 0) {
      return result.first['information_source_id'];
    }
    return null;
  }
  // Delete
  void deleteInformationSourcesTable() async {
    var dbClient = await db;
    dbClient.delete('informationSources');
  }
  // 

  // Service Providers Table
  // Insert
  Future saveServiceProvider(ServiceProvider serviceProvider) async {
    var dbClient = await db;
    // dbClient.delete('serviceProviders');
    var result = await dbClient.insert('serviceProviders', serviceProvider.toMap());
    return result;
  }
  // Read
  Future<List> getAllServiceProviders() async {
    var dbClient = await db;
    var result = await dbClient.query('serviceProviders');
    return result.toList();
  }
  Future<ServiceProvider> getServiceProvider(int serviceProviderId) async {
    var dbClient = await db;
    var result = await dbClient.query('serviceProviders', where: 'service_provider_id = ?', whereArgs: [serviceProviderId]);
    if(result.length > 0) {
      return ServiceProvider.map(result.first);
    }
    return null;
  }
  // Delete
  void deleteServiceProvidersTable() async {
    var dbClient = await db;
    dbClient.delete('serviceProviders');
  }
  // 

  // Toilet Types Table
  // Insert
  Future saveToiletType(ToiletType toiletType) async {
    var dbClient = await db;
    // dbClient.delete('toiletTypes');
    var result = await dbClient.insert('toiletTypes', toiletType.toMap());
    return result;
  }
  // Read
  Future<List> getAllToiletTypes() async {
    var dbClient = await db;
    var result = await dbClient.query('toiletTypes');
    return result.toList();
  }
  Future<ToiletType> getToiletType(int id) async {
    var dbClient = await db;
    var result = await dbClient.query('toiletTypes', where: 'id = ?', whereArgs: [id]);
    if(result.length > 0) {
      return ToiletType.map(result.first);
    }
    return null;
  }
  // Delete
  void deleteToiletTypesTable() async {
    var dbClient = await db;
    dbClient.delete('toiletTypes');
  }
  // 

  // Enrollment Reasons Table
  // Insert
  Future saveEnrollmentReason(EnrollmentReason enrollmentReason) async {
    var dbClient = await db;
    // dbClient.delete('enrollmentReasons');
    var result = await dbClient.insert('enrollmentReasons', enrollmentReason.toMap());
    return result;
  }
  // Read
  Future<List> getAllEnrollmentReasons() async {
    var dbClient = await db;
    var result = await dbClient.query('enrollmentReasons');
    return result.toList();
  }
  Future<EnrollmentReason> getEnrollmentReason(int id) async {
    var dbClient = await db;
    var result = await dbClient.query('enrollmentReasons', where: 'id = ?', whereArgs: [id]);
    if(result.length > 0) {
      return EnrollmentReason.map(result.first);
    }
    return null;
  }
  Future<int> getEnrollmentReasonId(String name) async {
    var dbClient = await db;
    var result = await dbClient.query('enrollmentReasons', where: 'name = ?', whereArgs: [name]);
    if(result.length > 0) {
      return result.first['enrollment_reason_id'];
    }
    return null;
  }
  // Delete
  void deleteEnrollmentReasonsTable() async {
    var dbClient = await db;
    dbClient.delete('enrollmentReasons');
  }
  // 

  // Telephone Types Table
  // Insert
  Future saveTelephoneType(TelephoneType telephoneType) async {
    var dbClient = await db;
    // dbClient.delete('telephoneTypes');
    var result = await dbClient.insert('telephoneTypes', telephoneType.toMap());
    return result;
  }
  // Read
  Future<List> getAllTelephoneTypes() async {
    var dbClient = await db;
    var result = await dbClient.query('telephoneTypes');
    return result.toList();
  }
  Future<TelephoneType> getTelephoneType(int id) async {
    var dbClient = await db;
    var result = await dbClient.query('telephoneTypes', where: 'id = ?', whereArgs: [id]);
    if(result.length > 0) {
      return TelephoneType.map(result.first);
    }
    return null;
  }
  // Delete
  void deleteTelephoneTypesTable() async {
    var dbClient = await db;
    dbClient.delete('telephoneTypes');
  }
  // 

  // Paid Services Table
  // Insert
  Future savePaidService(PaidService paidService) async {
    var dbClient = await db;
    // dbClient.delete('paidServices');
    var result = await dbClient.insert('paidServices', paidService.toMap());
    return result;
  }
  // Read
  Future<List> getAllPaidServices() async {
    var dbClient = await db;
    var result = await dbClient.query('paidServices');
    return result.toList();
  }
  Future<PaidService> getPaidService(int id) async {
    var dbClient = await db;
    var result = await dbClient.query('paidServices', where: 'id = ?', whereArgs: [id]);
    if(result.length > 0) {
      return PaidService.map(result.first);
    }
    return null;
  }
  Future<int> getPaidServiceId(String name) async {
    var dbClient = await db;
    var result = await dbClient.query('paidServices', where: 'name = ?', whereArgs: [name]);
    if(result.length > 0) {
      return result.first['paid_service_id'];
    }
    return null;
  }
  // Delete
  void deletePaidServicesTable() async {
    var dbClient = await db;
    dbClient.delete('paidServices');
  }
  // 

  // Toilet Privacy Table
  // Insert
  Future saveToiletPrivacy(ToiletPrivacy toiletPrivacy) async {
    var dbClient = await db;
    // dbClient.delete('toiletPrivacy');
    var result = await dbClient.insert('toiletPrivacy', toiletPrivacy.toMap());
    return result;
  }
  // Read
  Future<List> getAllToiletPrivacy() async {
    var dbClient = await db;
    var result = await dbClient.query('toiletPrivacy');
    return result.toList();
  }
  Future<ToiletPrivacy> getToiletPrivacy(int id) async {
    var dbClient = await db;
    var result = await dbClient.query('toiletPrivacy', where: 'id = ?', whereArgs: [id]);
    if(result.length > 0) {
      return ToiletPrivacy.map(result.first);
    }
    return null;
  }
  Future<int> getToiletPrivacyId(String name) async {
    var dbClient = await db;
    var result = await dbClient.query('toiletPrivacy', where: 'name = ?', whereArgs: [name]);
    if(result.length > 0) {
      return result.first['toilet_privacy_id'];
    }
    return null;
  }
  // Delete
  void deleteToiletPrivacyTable() async {
    var dbClient = await db;
    dbClient.delete('toiletPrivacy');
  }
  // 

  // Toilet Type Table
  // Insert
  Future saveToiletTypeCA(ToiletTypeCA toiletType) async {
    var dbClient = await db;
    // dbClient.delete('toiletSecurity');
    var result = await dbClient.insert('toiletType', toiletType.toMap());
    return result;
  }
  // Read
  Future<List> getAllToiletTypeCA() async {
    var dbClient = await db;
    var result = await dbClient.query('toiletType');
    return result.toList();
  }
  Future<ToiletTypeCA> getToiletTypeCA(int id) async {
    var dbClient = await db;
    var result = await dbClient.query('toiletType', where: 'id = ?', whereArgs: [id]);
    if(result.length > 0) {
      return ToiletTypeCA.map(result.first);
    }
    return null;
  }
  Future<int> getToiletTypeIdCA(String name) async {
    var dbClient = await db;
    var result = await dbClient.query('toiletType', where: 'name = ?', whereArgs: [name]);
    if(result.length > 0) {
      return result.first['toilet_type_id'];
    }
    return null;
  }
  // Delete
  void deleteToiletTypeCATable() async {
    var dbClient = await db;
    dbClient.delete('toiletType');
  }
  // 
  
  // Toilet Security Table
  // Insert
  Future saveToiletSecurity(ToiletSecurity toiletSecurity) async {
    var dbClient = await db;
    // dbClient.delete('toiletSecurity');
    var result = await dbClient.insert('toiletSecurity', toiletSecurity.toMap());
    return result;
  }
  // Read
  Future<List> getAllToiletSecurity() async {
    var dbClient = await db;
    var result = await dbClient.query('toiletSecurity');
    return result.toList();
  }
  Future<ToiletSecurity> getToiletSecurity(int id) async {
    var dbClient = await db;
    var result = await dbClient.query('toiletSecurity', where: 'id = ?', whereArgs: [id]);
    if(result.length > 0) {
      return ToiletSecurity.map(result.first);
    }
    return null;
  }
  Future<int> getToiletSecurityId(String name) async {
    var dbClient = await db;
    var result = await dbClient.query('toiletSecurity', where: 'name = ?', whereArgs: [name]);
    if(result.length > 0) {
      return result.first['toilet_security_id'];
    }
    return null;
  }
  // Delete
  void deleteToiletSecurityTable() async {
    var dbClient = await db;
    dbClient.delete('toiletSecurity');
  }
  // 

  // Items Table
  // Insert
  Future saveItem(Item item) async {
    var dbClient = await db;
    var result = await dbClient.insert('items', item.toMap());
    return result;
  }
  // Read
  Future<List> getAllItems() async {
    var dbClient = await db;
    var result = await dbClient.query('items');
    return result.toList();
  }
  Future<Map> getItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.query('items', where: 'item_id = ?', whereArgs: [id]);
    if(result.length > 0) {
      return result.first;
    }
    return null;
  }
  Future<int> getItemId(String name) async {
    var dbClient = await db;
    var result = await dbClient.query('items', where: 'name = ?', whereArgs: [name]);
    if(result.length > 0) {
      return result.first['item_id'];
    }
    return null;
  }
  // Delete
  void deleteItemsTable() async {
    var dbClient = await db;
    dbClient.delete('items');
  }
  // 

  // Work Orders Table
  // Insert
  Future saveWorkOrder(WorkOrder workOrder) async {
    var dbClient = await db;
    var result = await dbClient.insert('workOrders', workOrder.toMap());
    return result;
  }
  // Read
  Future<List> getAllWorkOrders() async {
    var dbClient = await db;
    var result = await dbClient.query('workOrders');
    return result.toList();
  }
  Future<Map> getWorkOrder(int id) async {
    var dbClient = await db;
    var result = await dbClient.query('workOrders', where: 'work_order_id = ?', whereArgs: [id]);
    if(result.length > 0) {
      return result.first;
    }
    return null;
  }
  Future<int> getWorkOrderId(String name) async {
    var dbClient = await db;
    var result = await dbClient.query('workOrders', where: 'name = ?', whereArgs: [name]);
    if(result.length > 0) {
      return result.first['work_order_id'];
    }
    return null;
  }
  // Delete
  void deleteWorkOrdersTable() async {
    var dbClient = await db;
    dbClient.delete('workOrders');
  }
  // 

  // Work Order Items Table
  // Insert
  Future saveWorkOrderItem(WorkOrderItem workOrderItem) async {
    var dbClient = await db;
    var result = await dbClient.insert('workOrderItems', workOrderItem.toMap());
    return result;
  }
  // Read
  Future<List> getAllWorkOrderItems() async {
    var dbClient = await db;
    var result = await dbClient.query('workOrderItems');
    return result.toList();
  }
  Future<int> getWorkOrderItemId(String name) async {
    var dbClient = await db;
    var result = await dbClient.query('workOrderItems', where: 'name = ?', whereArgs: [name]);
    if(result.length > 0) {
      return result.first['work_order_item_id'];
    }
    return null;
  }
  Future<List> getWorkOrderItems(int workOrderId) async {
    var dbClient = await db;
    var result = await dbClient.query('workOrderItems', where: 'work_order_id = ?', whereArgs: [workOrderId]);
    if(result.length > 0) {
      return result;
    }
    return null;
  }
  // Delete
  void deleteWorkOrderItemsTable() async {
    var dbClient = await db;
    dbClient.delete('workOrderItems');
  }
  // 

  // Health Inspection Schedules Table
  // Insert
  Future saveHealthInspectionSchedule(HealthInspectionSchedule healthInspectionSchedule) async {
    var dbClient = await db;
    var result = await dbClient.insert('healthInspectionSchedules', healthInspectionSchedule.toMap());
    return result;
  }
  // Read
  Future<List> getAllHealthInspectionSchedules() async {
    var dbClient = await db;
    var result = await dbClient.query('healthInspectionSchedules');
    return result.toList();
  }
  Future<HealthInspectionSchedule> getHealthInspectionSchedule(int healthInspectionScheduleId) async {
    var dbClient = await db;
    var result = await dbClient.query('healthInspectionSchedules', where: 'id = ?', whereArgs: [healthInspectionScheduleId]);
    if(result.length > 0) {
      return HealthInspectionSchedule.fromMap(result.first);
    }
    return null;
  }
  Future<HealthInspectionSchedule> getSubterritoryHISchedule(int subTerritoryId) async {
    var dbClient = await db;
    var result = await dbClient.query('healthInspectionSchedules', where: 'subterritory_id = ?', whereArgs: [subTerritoryId]);
    if(result.length > 0) {
      return HealthInspectionSchedule.fromMap(result.first);
    }
    return null;
  }
  // Delete
  void deleteHealthInspectionSchedulesTable() async {
    var dbClient = await db;
    dbClient.delete('healthInspectionSchedules');
  }
  // 


  // LEADS TABLE CRUD ACTIONS

  Future<int> saveLead(Lead lead) async {
    var dbClient = await db;
    var result = await dbClient.insert('leads', lead.toMap());
    return result;
  }

  Future<List> getAllLeads() async {
    var dbClient = await db;
    var result = await dbClient.query('leads');
    return result.toList();
  }

  Future<Lead> getLead(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query('leads', where: 'id = ?', whereArgs: [id]);
    if (result.length > 0) {
      return new Lead.map(result.first);
    }
    return null;
  }

  Future<List> getAllOpenLeads() async {
    var dbClient = await db;
    var result = await dbClient.query('leads', where: 'status = ?', whereArgs: ['Open']);
    return result;
  }

  Future<List> getAllReadyLeads() async {
    var dbClient = await db;
    var result = await dbClient.query('leads', where: 'status = ? AND type = ?', whereArgs: ['Ready', 'indirectorder']);
    return result;
  }

  Future<List> getDirectOrders() async {
    var dbClient = await db;
    var result = await dbClient.query('leads', where: 'type = ?', whereArgs: ['DirectOrder']);
    return result;
  }

  Future<List> getAllOpportunityLeads() async {
    var dbClient = await db;
    var result = await dbClient.query('leads', where: 'status = ? OR status = ?', whereArgs: ['Opportunity', 'opportunity']);
    return result;
  }

  Future<List> getAllPendingOpportunityLeads() async {
    var dbClient = await db;
    var result = await dbClient.query('leads', where: 'status = ? AND approved = ?', whereArgs: ['Opportunity', 15]);
    return result;
  }

  Future<List> getAllApprovedOpportunityLeads() async {
    var dbClient = await db;
    var result = await dbClient.query('leads', where: '(status = ? OR status = ?) AND approved == ?', whereArgs: ['Opportunity', 'opportunity', 18]);
    return result;
  }

  Future<List> getAllActiveLeads() async {
    var dbClient = await db;
    var result = await dbClient.query('leads', where: 'status = ?', whereArgs: ['active']);
    return result;
  }

  Future<int> updateLead(Lead lead) async {
    var dbClient = await db;
    return await dbClient.update('leads', lead.toMap(), where: 'id = ?', whereArgs: [lead.id]);
  }

  // check last two
  Future<int> updateLeadStatus(int id, String status) async {
    var dbClient = await db;
    return await dbClient.update('leads', {'status': status}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> archiveLead(int id, Lead lead) async{
    var dbClient = await db;
    return await dbClient.update('leads', lead.toMap(), where: 'id = ?', whereArgs: [lead.id]);
  }

  // Delete
  void deleteLeadsTable() async {
    var dbClient = await db;
    dbClient.delete('leads');
  }
  // 

  ///////////////


  // LEAD CONVERSIONS TABLE CRUD ACTIONS

  Future<int> saveLeadConversion(LeadConversion leadConversion) async {
    var dbClient = await db;
    // print(leadConversion.toApiMap());
    var result = await dbClient.insert('leadconversions', leadConversion.toMap());
    return result;
  }
  Future<List> getAllLeadConversions() async {
    var dbClient = await db;
    var result = await dbClient.query('leadconversions');
    return result.toList();
  }
  Future<LeadConversion> getLeadConversion(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query('leadconversions', where: 'id = ?', whereArgs: [id]);
    if (result.length > 0) {
      return new LeadConversion.fromMap(result.first);
    }
    return null;
  }
  Future<int> updateLeadConversion(LeadConversion leadConversion) async {
    var dbClient = await db;
    return await dbClient.update('leadconversions', leadConversion.toMap(), where: 'leadid = ?', whereArgs: [leadConversion.leadId]);
  }

  // Delete
  Future deleteLeadConversionsTable() async {
    var dbClient = await db;
    await dbClient.delete('leadConversions');
  }
  // 

  ///////////////
  
  
  // ORDERS TABLE CRUD ACTIONS

  Future<int> saveOrder(Order order) async {
    var dbClient = await db;
    var result = await dbClient.insert('orders', order.toMap());
    return result;
  }

  Future<List> getAllOrders() async {
    var dbClient = await db;
    var result = await dbClient.query('orders');
    return result.toList();
  }

  Future<Order> getOrder(int leadId) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query('orders', where: 'leadid = ?', whereArgs: [leadId]);
    if (result.length > 0) {
      return new Order.map(result.first);
    }
    return null;
  }

  Future<int> updateOrder(Order order) async {
    var dbClient = await db;
    return await dbClient.update('orders', order.toMap(), where: 'leadid = ?', whereArgs: [order.leadId]);
  }

  // Delete
  Future deleteOrdersTable() async {
    var dbClient = await db;
    await dbClient.delete('orders');
  }
  // 

  ///////////////
  
  // ASSIGNED WORK ORDERS TABLE CRUD ACTIONS

  Future<int> saveAssignedWorkOrder(WorkOrderModel workOrder) async {
    var dbClient = await db;
    var result = await dbClient.insert('assignedWorkOrders', workOrder.toMap());
    return result;
  }

  Future<List> getAllAssignedWorkOrders() async {
    var dbClient = await db;
    var result = await dbClient.query('assignedWorkOrders');
    return result.toList();
  }

  Future<List> getUncompletedWorkOrders() async {
    var dbClient = await db;
    var result = await dbClient.query('assignedWorkOrders', where: 'status = ? OR status = ?', whereArgs: ['Ready', 'ready']);
    return result.toList();
  }

  Future<WorkOrderModel> getAssignedWorkOrder(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query('assignedWorkOrders', where: 'id = ?', whereArgs: [id]);
    if (result.length > 0) {
      return new WorkOrderModel.map(result.first);
    }
    return null;
  }

  Future<int> updateAssignedWorkOrderStatus(int id) async {
    var dbClient = await db;
    return await dbClient.update('assignedWorkOrders', {'status': 'active'}, where: 'id = ?', whereArgs: [id]);
  }

  void clearAssignedWorkOrdersTable() async {
    var dbClient = await db;
    dbClient.delete('assignedWorkOrders');
  }

  // Delete
  Future deleteAssignedWorkOrdersTable() async {
    var dbClient = await db;
    await dbClient.delete('assignedWorkOrders');
  }
  // 

  ///////////////

  // CUSTOMER TABLE CRUD ACTIONS
  Future<int> saveCustomer(Customer customer) async {
    var dbClient = await db;
    var result = await dbClient.insert('customers', customer.toMap());
    return result;
  }

  Future<int> updateCustomer(Customer customer) async {
    var dbClient = await db;
    return await dbClient.update('customers', customer.toMap(), where: 'id = ?', whereArgs: [customer.id]);
  }

  Future<Customer> getCustomer(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query('customers', where: 'leadid = ?', whereArgs: [id]);
    if (result.length > 0) {
      return new Customer.map(result.first);
    }
    return null;
  }

  Future<List> getCustomerType(int statusId) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query('customers', where: 'status = ?', whereArgs: [statusId]);
    if (result.length > 0) {
      return result.toList();
    }
    return null;
  }

  Future<List> getAllCustomers() async {
    var dbClient = await db;
    var result = await dbClient.query('customers');
    return result.toList();
  }

  // Delete
  Future deleteCustomersTable() async {
    var dbClient = await db;
    await dbClient.delete('customers');
  }
  // 

  ///////////////

  // SECONDARY APPROVAL WORK ORDERS TABLE CRUD ACTIONS

  Future<int> saveSAWorkOrder(SAWorkOrderModel saWorkOrder) async {
    var dbClient = await db;
    var result = await dbClient.insert('secondaryApprovalWorkOrders', saWorkOrder.toMap());
    return result;
  }

  Future<List> getAllSAWorkOrders() async {
    var dbClient = await db;
    var result = await dbClient.query('secondaryApprovalWorkOrders');
    return result.toList();
  }

  // Future<List> getUncompletedWorkOrders() async {
  //   var dbClient = await db;
  //   var result = await dbClient.query('assignedWorkOrders', where: 'status = ?', whereArgs: ['Ready']);
  //   return result.toList();
  // }

  Future<SAWorkOrderModel> getSAWorkOrder(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query('secondaryApprovalWorkOrders', where: 'id = ?', whereArgs: [id]);
    if (result.length > 0) {
      return new SAWorkOrderModel.map(result.first);
    }
    return null;
  }

  // Future<int> updateAssignedWorkOrderStatus(int id) async {
  //   var dbClient = await db;
  //   return await dbClient.update('assignedWorkOrders', {'status': 'active'}, where: 'id = ?', whereArgs: [id]);
  // }

  void clearSAWorkOrdersTable() async {
    var dbClient = await db;
    dbClient.delete('secondaryApprovalWorkOrders');
  }

  ///////////////

  // BARREL COUNT TABLE CRUD ACTIONS

   Future saveBarrelCount(BarrelCountModel barrelcount) async {
    var dbClient = await db;
    var result = await dbClient.insert('BarrelCount', barrelcount.toMap());
    return result;
  }
  Future<List> getBarrelCount() async {
    var dbClient = await db;
    var result = await dbClient.query('BarrelCount');
    return result;
  }
  Future<int> deleteBarrelCount(int id) async {
    var dbClient = await db;
    var result = await dbClient.delete('BarrelCount',where: 'serverid=?',whereArgs: [id]);
    return result;
  }
  Future<int> updateBarrelCount(BarrelCountModel barrelcount) async {
    var dbClient = await db;
    return await dbClient.update('leads', barrelcount.toMap(), where: 'id = ?', whereArgs: [barrelcount.id]);
  }

  ///////////////
  
  // HEALTH INSPECTIONS CUSTOMERS TABLE CRUD ACTIONS

  Future<int> saveHICustomer(HICustomer customer) async {
    var dbClient = await db;
    var result = await dbClient.insert('healthInspectionCustomers', customer.toMap());
    return result;
  }

  Future<List> getAllHICustomers() async {
    var dbClient = await db;
    var result = await dbClient.query('healthInspectionCustomers');
    return result.toList();
  }

  Future<HICustomer> getHICustomer(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query('healthInspectionCustomers', where: 'id = ?', whereArgs: [id]);
    if (result.length > 0) {
      return new HICustomer.map(result.first);
    }
    return null;
  }

  Future<int> updateHICustomer(HICustomer customer) async {
    var dbClient = await db;
    return await dbClient.update('healthInspectionCustomers', customer.toMap(), where: 'id = ?', whereArgs: [customer.id]);
  }

  // Delete
  void deleteHICustomersTable() async {
    var dbClient = await db;
    dbClient.delete('leads');
  }
  // 

  // PAYMENTS TABLE CRUD ACTIONS

  Future<int> savePayment(Payment payment) async {
    var dbClient = await db;
    var result = await dbClient.insert('payments', payment.toMap());
    return result;
  }

  Future<Payment> getPayment(int customerId) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query('payments', where: 'customerId = ?', whereArgs: [customerId]);
    if (result.length > 0) {
      return new Payment.map(result.first);
    }
    return null;
  }

  Future<List> getAllPayments() async {
    var dbClient = await db;
    var result = await dbClient.query('payments');
    return result.toList();
  }

  // Delete
  Future deletePaymentsTable() async {
    var dbClient = await db;
    await dbClient.delete('payments');
  }
  // 

  ///////////////
  
  // Complaint Type Table
  // Insert
  Future saveComplaintType(ComplaintType complaintType) async {
    var dbClient = await db;
    var result;
    await dbClient.delete('ComplaintType');
    result = await dbClient.insert('ComplaintType', complaintType.toMap());
    return result;
  }
  // Read
  Future<List> getComplaintTypes() async {
    var dbClient = await db;
    var result = await dbClient.query('ComplaintType');
    return result.toList();
  }
  Future<ComplaintType> getComplaintType(int id) async {
    var dbClient = await db;
    var result = await dbClient.query('ComplaintType', where: 'id = ?', whereArgs: [id]);
    if(result.length > 0) {
      return ComplaintType.fromMap(result.first);
    }
    return null;
  }
  // Delete
  void deleteComplaintTypes() async {
    var dbClient = await db;
    dbClient.delete('ComplaintType');
  }

  // Interruption Type Table
  // Insert
  Future saveInterruptionType(InterruptionType interruptionType) async {
    var dbClient = await db;
    var result;
    await dbClient.delete('InterruptionType');
    result = await dbClient.insert('InterruptionType', interruptionType.toMap());
    return result;
  }
  // Read
  Future<List> getInterruptionTypes() async {
    var dbClient = await db;
    var result = await dbClient.query('InterruptionType');
    return result.toList();
  }
  Future<InterruptionType> getInterruptionType(int id) async {
    var dbClient = await db;
    var result = await dbClient.query('InterruptionType', where: 'id = ?', whereArgs: [id]);
    if(result.length > 0) {
      return InterruptionType.fromMap(result.first);
    }
    return null;
  }
  // Delete
  void deleteInterruptionTypes() async {
    var dbClient = await db;
    dbClient.delete('InterruptionType');
  }

   // COMPLAINTS Table
  // Insert
  Future saveComplaint(Complaint complaint) async {
    var dbClient = await db;
    await dbClient.delete('Complaints',where: 'id>?',whereArgs: [0]);
    var result;
    result = await dbClient.insert('Complaints', complaint.toMap());
    return result;
  }
  // Read
  Future<List> getComplaints() async {
    var dbClient = await db;
    var result = await dbClient.query('Complaints');
    return result.toList();
  }
  Future<Complaint> getComplaint(int id) async {
    var dbClient = await db;
    var result = await dbClient.query('Complaints', where: 'id = ?', whereArgs: [id]);
    if(result.length > 0) {
      return Complaint.fromMap(result.first);
    }
    return null;
  }
  // Delete
  void deleteComplaint() async {
    var dbClient = await db;
    dbClient.delete('Complaints');
  }
 
  Future<int> saveTask(Tasks task) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableTasks, task.toMap());
    return result;
  }

  // Future<int> saveLead(Leads lead) async {
  //   var dbClient = await db;
  //   var result = await dbClient.insert(tableLeads, lead.toMap());
  //   return result;
  // }

  //  Future<int> saveDirectOrder(DirectOrders directOrder) async {
  //   var dbClient = await db;
  //   var result = await dbClient.insert(tableDirectOrder, directOrder.toMap());
  //   return result;
  // }

  // Future<int> saveSetup(Setups setup) async {
  //   var dbClient = await db;
  //   List<Map<String,dynamic>> a = await dbClient.rawQuery('SELECT * FROM $tableSetup');
  //   var result;
  //   if(a.length==0){
      
  //     result = await dbClient.insert(tableSetup, setup.toMap());
  //   }
  //   else{
  //     Setups setups = Setups.fromMap(a.first);
  //     print(setups.id);

  //     // String query = 'UPDATE $tableSetup SET firstName=\'${setups.firstName}\', lastName=\'${setups.lastName}\', organizationName=\'${setups.organizationName}\', language=\'${setups.organizationName}\', subDomain=\'${setups.subDomain}\' WHERE id=${setup.id}';
  //     // await dbClient.transaction((transaction) async {
  //     //   return await transaction.rawQuery(query);
  //     // });

  //     // result = await dbClient.update(tableSetup, setups.toMap(), where: "$columnId = ?", whereArgs: [setups.id]);
  //   }

  //   List<Map<String,dynamic>> b= await dbClient.rawQuery('SELECT * FROM $tableSetup');
  //   print(b.first['firstName']);
  //   // print(a.first['firstName']);
  //   // return result;
  // }

  Future<int> saveSetup(Setups setup) async {
    var dbClient = await db;
    
    var result = await dbClient.insert(tableSetup, setup.toMap());
    return result;
    // List<Map<String,dynamic>> a = await dbClient.rawQuery('SELECT * FROM $tableSetup');
    // print(a.last);


  }

  

  Future<int> saveFollowUp(FollowUps followup) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableFollowUps, followup.toMap());
    return result;
  }
 
  Future<List> getAllTasks() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableTasks');
    return result.toList();
  }

  // Future<List> getAllLeads() async {
  //   var dbClient = await db;
  //   var result = await dbClient.rawQuery('SELECT * FROM $tableLeads');
  //   return result.toList();
  // }

  

  Future<List> getAllFollowUps() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableFollowUps');
    return result.toList();
  }

  Future<List> getAllDirectOrders() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableDirectOrder');
    return result.toList();
  }
 
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableTasks'));
  }
 
  Future<Tasks> getTask(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery('SELECT * FROM $tableTasks WHERE $columnId = $id');
    if (result.length > 0) {
      return new Tasks.fromMap(result.first);
    }
    return null;
  }

  Future<Setups> getSetup() async {
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery('SELECT * FROM $tableSetup');
    if (result.length > 0) {
      return new Setups.fromMap(result.last);
    }
    return null;
  }


  //  Future<DirectOrders> getDirectOrder(int id) async {
  //   var dbClient = await db;
  //   List<Map> result = await dbClient.rawQuery('SELECT * FROM $tableDirectOrder WHERE $columnId = $id');
  //   if (result.length > 0) {
  //     return new DirectOrders.map(result.first);
  //   }
  //   return null;
  // }

  // Future<Leads> getLead(int id) async {
  //   var dbClient = await db;
  //   List<Map> result = await dbClient.rawQuery('SELECT * FROM $tableLeads WHERE $columnId = $id');
  //   if (result.length > 0) {
  //     return new Leads.map(result.first);
  //   }
  //   return null;
  // }

  

   Future<FollowUps> getFollowUp(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery('SELECT * FROM $tableFollowUps WHERE $columnId = $id');
    if (result.length > 0) {
      return new FollowUps.fromMap(result.first);
    }
    return null;
  }

  // Future<int> archiveLead(int id, Leads lead) async{
  //   var dbClient = await db;
  //   return await dbClient.update(tableLeads, lead.toMap(), where: "$columnId = ?", whereArgs: [lead.id]);
  // }

  // Future<int> archiveDirectOrder(int id, DirectOrders lead) async{
  //   var dbClient = await db;
  //   return await dbClient.update(tableDirectOrder, lead.toMap(), where: "$columnId = ?", whereArgs: [lead.id]);
  // }
 
  Future<int> deleteNote(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableTasks, where: '$columnId = ?', whereArgs: [id]);
  }
 
  // Future<int> updateLead(Leads lead) async {
  //   var dbClient = await db;
  //   return await dbClient.update(tableLeads, lead.toMap(), where: "$columnId = ?", whereArgs: [lead.id]);
  // }

  Future<int> updateTask(Tasks task) async {
    var dbClient = await db;
    return await dbClient.update(tableTasks, task.toMap(), where: "$columnId = ?", whereArgs: [task.id]);
  }

  Future<int> updateFollowup(FollowUps followup) async {
    var dbClient = await db;
    return await dbClient.update(tableFollowUps, followup.toMap(), where: "$columnId = ?", whereArgs: [followup.id]);
  }

  // Future<int> updateLeadStatus(int id,Leads lead) async {
  //   var dbClient = await db;
  //   return await dbClient.update(tableLeads, lead.toMap(), where: "$columnId = ?", whereArgs: [lead.id]);
  // }

  // Future<int> updateDirectOrder(DirectOrders directOrder) async {
  //   var dbClient = await db;
  //   return await dbClient.update(tableDirectOrder, directOrder.toMap(), where: "$columnId = ?", whereArgs: [directOrder.id]);
  //   // print(directOrder.toMap());
  // }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    List users = await dbClient.rawQuery('SELECT * FROM $tableUser');
    int result;
    if (users.length==0) {
      result = await dbClient.insert(tableUser, user.toMap());
    }
    else{
      result = await dbClient.update(tableUser, user.toMap(), where: "$columnId = ?", whereArgs: [users.first['id']]);
    }
    return result;
  }

  Future<User> getUser() async {
    var dbClient = await db;
    List result = await dbClient.rawQuery('SELECT * FROM $tableUser');
    return User.fromMap(result.first);
  }

  // Toilet Installation CRUD actions
  // Insert
  Future saveToiletInstallation(ToiletInstallationModel toiletInstallation) async {
    var dbClient = await db;
    var result = await dbClient.insert('toiletInstallation', toiletInstallation.toMap());
    return result;
  }
  // Read
  Future<List> getAllToiletInstallations() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM toiletInstallation');
    return result.toList();
  }

  Future<ToiletInstallationModel> getToiletInstallation(int leadid) async {
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery('SELECT * FROM toiletInstallation WHERE leadid = $leadid');
    if (result.length > 0) {
      return new ToiletInstallationModel.map(result.first);
    }
    return null;
  }
  // Update
  Future<int> updateToiletInstallation(ToiletInstallationModel toiletInstallation) async {
    var dbClient = await db;
    return await dbClient.update('toiletInstallation', toiletInstallation.toMap(), where: 'id = ?', whereArgs: [toiletInstallation.id]);
  }
  // Delete
  Future<int> deleteToiletInstallation(int id) async {
    var dbClient = await db;
    return await dbClient.delete('toiletInstallation', where: 'id = ?', whereArgs: [id]);
  }
  Future deleteToiletInstallationTable() async {
    var dbClient = await db;
    await dbClient.delete('toiletInstallation');
  }
  //



  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}