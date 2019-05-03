// import 'package:cbsa_mobile_app/models/lead.dart';
// import 'package:cbsa_mobile_app/scoped_model/task_model.dart';
// import 'package:flutter/material.dart';
// import 'package:scoped_model/scoped_model.dart';

// class UpdateRecord extends StatefulWidget {
//   final Leads lead;
//   UpdateRecord({Key key,@required this.lead}):super(key:key);

//   @override
//   _UpdateRecordState createState() => _UpdateRecordState();
// }

// class _UpdateRecordState extends State<UpdateRecord> {
//   int _currentStep = 0;
//   final _personalDetailsFormKey = GlobalKey<FormState>();
//   final _toiletInformationFormKey = GlobalKey<FormState>();
//   final _contactInformationFormKey = GlobalKey<FormState>();
//   final _additionalInformationFormKey = GlobalKey<FormState>();
//   final _statusFormKey = GlobalKey<FormState>();
//   bool isLoading = false;
//   String _startTime;
//   String _endTime;

//   String _firstName;
//   String _lastName;
//   String _otherNames;
//   List<String> _territoryList = [
//     'Territory A',
//     'Territory B',
//     'Territory C',
//     'Territory D'
//   ];
//   String _territory = 'Territory A';
//   var _genderList = ['Male', 'Female', 'Other'];
//   String _gender = 'Male';
//   var _subTerritoryList = [
//     'Sub-Territory A',
//     'Sub-Territory B',
//     'Sub-Territory C',
//     'Sub-Territory D'
//   ];
//   String _subTerritory = 'Sub-Territory A';
//   var _blockList = ['Block A', 'Block B', 'Block C', 'Block D'];
//   String _block = 'Block A';
//   int _noOfMaleAdults=0;
//   int _noOfFemaleAdults=0;
//   int _noOfMaleChildren=0;
//   int _noOfFemaleChildren=0;
//   var _disabilityOptions = ['Yes', 'No'];
//   String _disability = 'No';
//   var _leadTypeList = [
//     'Organization',
//     'Individual',
//     'Construction Company',
//     'Church',
//     'School'
//   ];
//   String _leadType = 'Individual';
//   Map<String, bool> _infoSourceList = {
//     'Radio': false,
//     'TV': false,
//     'Social Media': false,
//     'Papers': false
//   };
//   List<String> _infoSourceSelected = [];
//   var _toiletTypeList = ['WC', 'Drop Down', 'Stand Tall'];
//   String _toiletType = 'WC';
//   int _noOfToilets=0;
//   String _address;
//   String _primaryTelephone;
//   String _secondaryTelephone;
//   String _status = 'Follow Up';
//   String _comment;
//   Map<String, bool> _enrollmentReason = {
//     'Personal': false,
//     'Commercial': false
//   };
//   List<String> _reasonsSelected = [];
//   var _serviceProviders = ['MTN', 'Vodafone', 'Airtel-Tigo', 'Glo'];
//   var _serviceProvider = 'MTN';
//   var _telephoneTypes = ['Smart Phone', 'Yam'];
//   var _telephoneType = 'Yam';
//   var _salary = ['Yes', 'No'];
//   var _salariedWorker = 'Yes';
//   Map<String, bool> _paidServices = {
//     'City Water': false,
//     'Trucked Water': false,
//     'Electricity': false
//   };
//   List<String> _servicesSelected = [];
//   Map<String, bool> _privacyList = {
//     'Public': false,
//     'Private': false,
//     'Neighbour': false,
//     'None': false
//   };
//   List<String> _privacySelected = [];
//   Map<String, bool> _typeList = {
//     'Latrine': false,
//     'Squat': false,
//     'Flush': false,
//     'Dry': false
//   };
//   List<String> _typeSelected = [];
//   Map<String, bool> _securityList = {'Safe': false, 'Not Safe': false};
//   List<String> _securitySelected = [];
//   var followUpDate = TextEditingController();
//   String _fUDate;
//   var siteInspectionDate = TextEditingController();
//   String _sIDate;
//   var toiletInstallationDate = TextEditingController();
//   String _tIDate;
//   String _referred ='No';
//   String _referredBy;
//   String _paymentDate;
//   double _latitude=0.0;
//   double _longitude=0.0;

//   //location
//   // var location = new Location();
//   Map<String, double> currentLocation;

//   void initState() {
//     super.initState();

//     setState(() {
//       _startTime = DateTime.now().hour.toString() +
//           ':' +
//           DateTime.now().minute.toString() +
//           ':' +
//           DateTime.now().second.toString();
//     });
//   }

//   // _getLocation() async {
//   //   try {
//   //     currentLocation = await location.getLocation();
//   //   } catch (e) {
//   //     currentLocation = null;
//   //   }
//   //   print(currentLocation);
//   //   setState(() {
//   //     _latitude = currentLocation['latitude'].toString();
//   //     _longitude = currentLocation['longitude'].toString();
//   //   });
//   // }

//   void _showDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: isLoading
//               ? CircularProgressIndicator()
//               : Text('Lead Saved Successfully'),
//           actions: <Widget>[
//             new FlatButton(
//               child: new Text("OK"),
//               onPressed: () {
//                 setState(() {
//                   isLoading = false;
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget getText(String title, String type,TaskModel model) {
//     var initialText = '';
//     switch (type) {
//       case 'firstName':
//         initialText=widget.lead.firstName;
//         break;
//       case 'lastName':
//         initialText=widget.lead.lastName;
//         break;
//       case 'otherNames':
//         initialText=widget.lead.otherNames;
//         break;
//       case 'address':
//         initialText=widget.lead.address;
//         break;
//       case 'paymentDate':
//         initialText=widget.lead.paymentDate;
//         break;
//       case 'referredBy':
//         initialText=widget.lead.referredBy;
//         break;
//       default:
//     }
//     return (TextFormField(
//       initialValue: initialText,
//       decoration:
//           InputDecoration(labelText: title, hasFloatingPlaceholder: true),
//       validator: (value) {
//         if ((type == 'firstName' || type == 'lastName' || type == 'address') &&
//             value.isEmpty) {
//           return 'Required Field';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           if (type == 'firstName')
//             this._firstName = value;
//           else if (type == 'lastName')
//             _lastName = value;
//           else if (type == 'otherNames')
//             _otherNames = value;
//           else if (type == 'disability')
//             _disability = value;
//           else if (type == 'address')
//             _address = value;
//           else if (type == 'referredBy')
//             _referredBy = value;
//           else if (type == 'paymentDate') _paymentDate = value;
//         });
//       },
//     ));
//   }

//   Widget dropDownSelect(String title, String type, List<String> list) {
//     var value;
//     switch (type) {
//       case 'territory':
//         value = this._territory;
//         break;
//       case 'sub-territory':
//         value = this._subTerritory;
//         break;
//       case 'block':
//         value = this._block;
//         break;
//       case 'gender':
//         value = this._gender;
//         break;
//       case 'disability':
//         value = this._disability;
//         break;
//       case 'leadType':
//         value = this._leadType;
//         break;
//       case 'toiletType':
//         value = this._toiletType;
//         break;
//       case 'status':
//         value = this._status;
//         break;
//       case 'serviceProvider':
//         value = this._serviceProvider;
//         break;
//       case 'telephoneType':
//         value = this._telephoneType;
//         break;
//       case 'salariedWorker':
//         value = this._salariedWorker;
//         break;
//       default:
//         value = null;
//     }
//     return (Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Padding(padding: EdgeInsets.only(right: 20), child: Text(title)),
//         DropdownButton<String>(
//           value: value,
//           items: list.map((val) {
//             return DropdownMenuItem<String>(
//               value: val,
//               child: Text(val),
//             );
//           }).toList(),
//           onChanged: (String val) {
//             setState(() {
//               if (type == 'territory')
//                 _territory = val;
//               else if (type == 'sub-territory')
//                 _subTerritory = val;
//               else if (type == 'block')
//                 _block = val;
//               else if (type == 'gender')
//                 _gender = val;
//               else if (type == 'disability')
//                 _disability = val;
//               else if (type == 'leadType')
//                 _leadType = val;
//               else if (type == 'toiletType')
//                 _toiletType = val;
//               else if (type == 'status')
//                 _status = val;
//               else if (type == 'serviceProvider')
//                 _serviceProvider = val;
//               else if (type == 'telephoneType')
//                 _telephoneType = val;
//               else if (type == 'salariedWorker') _salariedWorker = val;
//             });
//           },
//         )
//       ],
//     ));
//   }

//   Widget numberPicker(String title, String type) {
//     return (TextFormField(
//       decoration:
//           InputDecoration(labelText: title, hasFloatingPlaceholder: true),
//       keyboardType: TextInputType.number,
//       validator: (value) {
//         if ((type == 'noOfToilets' || type == 'primaryTelephone') &&
//             value.isEmpty) {
//           return 'Required Field';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           if (type == 'noOfMaleAdults')
//             _noOfMaleAdults = value.isEmpty? 0 : int.parse(value);
//           else if (type == 'noOfFemaleAdults')
//             _noOfFemaleAdults = value.isEmpty? 0 : int.parse(value);
//           else if (type == 'noOfMaleChildren')
//             _noOfMaleChildren = value.isEmpty? 0 : int.parse(value);
//           else if (type == 'noOfFemaleChildren')
//             _noOfFemaleChildren = value.isEmpty? 0 : int.parse(value);
//           else if (type == 'noOfToilets')
//             _noOfToilets = value.isEmpty? 0 : int.parse(value);
//           else if (type == 'primaryTelephone')
//             _primaryTelephone = value;
//           else if (type == 'secondaryTelephone')
//             _secondaryTelephone = value;
//         });
//       },
//     ));
//   }

//   Widget checkBoxSelect(String title, Map<String, bool> list, String type) {
//     return (Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Container(
//           width: 80,
//           child: Text(title),
//         ),
//         Container(
//           width: 200,
//           child: Column(
//             children: list.keys.map((String key) {
//               return CheckboxListTile(
//                 title: Text(key),
//                 value: list[key],
//                 onChanged: (bool value) {
//                   setState(() {
//                     list[key] = value;
//                     if (value == true) {
//                       if (type == 'enrollmentReason') {
//                         _reasonsSelected.add(key);
//                         print(_reasonsSelected);
//                       } else if (type == 'infoSource') {
//                         _infoSourceSelected.add(key);
//                         print(_infoSourceSelected);
//                       } else if (type == 'paidServices') {
//                         _servicesSelected.add(key);
//                         print(_servicesSelected);
//                       } else if (type == 'privacy') {
//                         _privacySelected.add(key);
//                         print(_privacySelected);
//                       } else if (type == 'type') {
//                         _typeSelected.add(key);
//                         print(_typeSelected);
//                       } else if (type == 'security') {
//                         _securitySelected.add(key);
//                         print(_securitySelected);
//                       }
//                     } else {
//                       if (type == 'enrollmentReason') {
//                         _reasonsSelected.remove(key);
//                         print(_reasonsSelected);
//                       } else if (type == 'infoSource') {
//                         _infoSourceSelected.remove(key);
//                         print(_infoSourceSelected);
//                       } else if (type == 'paidServices') {
//                         _servicesSelected.remove(key);
//                         print(_servicesSelected);
//                       } else if (type == 'privacy') {
//                         _privacySelected.remove(key);
//                         print(_privacySelected);
//                       } else if (type == 'type') {
//                         _typeSelected.remove(key);
//                         print(_typeSelected);
//                       } else if (type == 'security') {
//                         _securitySelected.remove(key);
//                         print(_securitySelected);
//                       }
//                     }
//                   });
//                 },
//               );
//             }).toList(),
//           ),
//         )
//       ],
//     ));
//   }

//   Widget getMultilineText(String title, String type) {
//     return (TextFormField(
//       decoration:
//           InputDecoration(labelText: title, hasFloatingPlaceholder: true),
//       keyboardType: TextInputType.multiline,
//       maxLines: 3,
//       onSaved: (value) {
//         setState(() {
//           _comment = value;
//         });
//       },
//     ));
//   }

//   Widget referredBy(TaskModel model) {
//     var referredList = ['Yes', 'No'];
//     return (Column(
//       children: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Padding(
//                 padding: EdgeInsets.only(right: 20), child: Text('Reffered?')),
//             DropdownButton<String>(
//               value: _referred,
//               items: referredList.map((val) {
//                 return DropdownMenuItem<String>(
//                   value: val,
//                   child: Text(val),
//                 );
//               }).toList(),
//               onChanged: (String val) {
//                 setState(() {
//                   _referred = val;
//                 });
//               },
//             )
//           ],
//         ),
//         Container(
//           child: (_referred == 'Yes'
//               ? getText('Name of Referee', 'referredBy',model)
//               : null),
//         )
//       ],
//     ));
//   }

//   Widget salariedWorker(TaskModel model) {
//     return Column(
//       children: <Widget>[
//         dropDownSelect('Salaried Worker:', 'salariedWorker', _salary),
//         Container(
//           child: (_salariedWorker == 'Yes'
//               ? getText('Payment Date', 'paymentDate',model)
//               : null),
//         )
//       ],
//     );
//   }

//   Widget selectStatus() {
//     var statusList = ['Follow Up', 'Ready'];

//     return (Column(
//       children: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Padding(padding: EdgeInsets.only(right: 20), child: Text('Status')),
//             DropdownButton<String>(
//               value: _status,
//               items: statusList.map((val) {
//                 return DropdownMenuItem<String>(
//                   value: val,
//                   child: Text(val),
//                 );
//               }).toList(),
//               onChanged: (String val) {
//                 setState(() {
//                   if (val == 'Follow Up') {
//                     siteInspectionDate.text = '';
//                     toiletInstallationDate.text = '';
//                   } else {
//                     followUpDate.text = '';
//                   }
//                   _status = val;
//                 });
//               },
//             )
//           ],
//         ),
//         Container(
//           child: (_status == 'Follow Up'
//               ? GestureDetector(
//                   onTap: () async {
//                     DateTime datePicked = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2016),
//                         lastDate: DateTime(2030));
//                     setState(() {
//                       followUpDate.text = datePicked.year.toString() +
//                           '-' +
//                           datePicked.month.toString() +
//                           '-' +
//                           datePicked.day.toString();
//                       _fUDate = datePicked.toString();
//                     });
//                   },
//                   child: Container(
//                     padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
//                     child: AbsorbPointer(
//                       child: TextFormField(
//                         textAlign: TextAlign.center,
//                         decoration: InputDecoration(
//                           labelText: 'Follow Up Date',
//                           hasFloatingPlaceholder: true,
//                         ),
//                         controller: followUpDate,
//                         validator: (value) {
//                           if (value.isEmpty) return 'Required Field';
//                         },
//                       ),
//                     ),
//                   ),
//                 )
//               : Column(
//                   children: <Widget>[
//                     GestureDetector(
//                       onTap: () async {
//                         DateTime datePicked = await showDatePicker(
//                             context: context,
//                             initialDate: new DateTime.now(),
//                             firstDate: new DateTime(2016),
//                             lastDate: new DateTime(2030));
//                         setState(() {
//                           siteInspectionDate.text = datePicked.year.toString() +
//                               '-' +
//                               datePicked.month.toString() +
//                               '-' +
//                               datePicked.day.toString();
//                           _sIDate = siteInspectionDate.text;
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
//                         child: AbsorbPointer(
//                           child: TextFormField(
//                             textAlign: TextAlign.center,
//                             decoration: InputDecoration(
//                               labelText: 'Site Inspection Date',
//                               hasFloatingPlaceholder: true,
//                             ),
//                             controller: siteInspectionDate,
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         DateTime datePicked = await showDatePicker(
//                             context: context,
//                             initialDate: new DateTime.now(),
//                             firstDate: new DateTime(2016),
//                             lastDate: new DateTime(2030));
//                         setState(() {
//                           toiletInstallationDate.text =
//                               datePicked.year.toString() +
//                                   '-' +
//                                   datePicked.month.toString() +
//                                   '-' +
//                                   datePicked.day.toString();
//                           _tIDate = toiletInstallationDate.text;
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
//                         child: AbsorbPointer(
//                           child: TextFormField(
//                             textAlign: TextAlign.center,
//                             decoration: InputDecoration(
//                               labelText: 'Toilet Installation Date',
//                               hasFloatingPlaceholder: true,
//                             ),
//                             controller: toiletInstallationDate,
//                             validator: (value) {
//                               if (value.isEmpty) return 'Required Field';
//                             },
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 )),
//         )
//       ],
//     ));
//   }

//   List<Step> _leadDetails(TaskModel model) {
//     return ([
//       Step(
//         title: Text('Personal Details'),
//         content: Form(
//           key: _personalDetailsFormKey,
//           child: Column(
//             children: <Widget>[
//               getText('First Name: ', 'firstName',model),
//               getText('Last Name: ', 'lastName',model),
//               getText('Other Names: ', 'otherNames',model),
//               Divider(),
//               dropDownSelect('Territory:', 'territory', _territoryList),
//               Divider(),
//               dropDownSelect(
//                   'Sub-Territory:', 'sub-territory', _subTerritoryList),
//               Divider(),
//               dropDownSelect('Block:', 'block', _blockList),
//               Divider(),
//               dropDownSelect('Gender:', 'gender', _genderList),
//               Divider(),
//               dropDownSelect('Disability:', 'disability', _disabilityOptions),
//               Divider(),
//               dropDownSelect('Lead Type:', 'leadType', _leadTypeList),
//               Divider(),
//               checkBoxSelect(
//                   'Source of Information:', _infoSourceList, 'infoSource'),
//               Divider(),
//               referredBy(model),
//               Divider()
//             ],
//           ),
//         ),
//         isActive: _currentStep >= 0,
//       ),
//       Step(
//         title: Text('Toilet Information'),
//         content: Form(
//           key: _toiletInformationFormKey,
//           child: Column(
//             children: <Widget>[
//               dropDownSelect('Toilet Type:', 'toiletType', _toiletTypeList),
//               Divider(),
//               numberPicker('Number of Toilets', 'noOfToilets'),
//               Divider(),
//               numberPicker('Number of Male Adults:', 'noOfMaleAdults'),
//               Divider(),
//               numberPicker('Number of Female Adults:', 'noOfFemaleAdults'),
//               Divider(),
//               numberPicker('Number of Male Children:', 'noOfMaleChildren'),
//               Divider(),
//               numberPicker('Number of Female Children:', 'noOfFemaleChildren'),
//               Divider(),
//             ],
//           ),
//         ),
//         isActive: _currentStep >= 1,
//       ),
//       Step(
//         title: Text('Contact Information'),
//         content: Form(
//           key: _contactInformationFormKey,
//           child: Column(
//             children: <Widget>[
//               getText('Address:', 'address',model),
//               Divider(),
//               numberPicker('Primary Telephone:', 'primaryTelephone'),
//               Divider(),
//               numberPicker('Secondary Telephone:', 'secondaryTelephone'),
//             ],
//           ),
//         ),
//         isActive: _currentStep >= 2,
//       ),
//       Step(
//         title: Text('Additional Information'),
//         content: Form(
//           key: _additionalInformationFormKey,
//           child: Column(
//             children: <Widget>[
//               checkBoxSelect('Reason for Enrollment:', _enrollmentReason,
//                   'enrollmentReason'),
//               Divider(),
//               dropDownSelect('Telephone Service Provider:', 'serviceProvider',
//                   _serviceProviders),
//               Divider(),
//               dropDownSelect(
//                   'Telephone Type:', 'telephoneType', _telephoneTypes),
//               Divider(),
//               salariedWorker(model),
//               Divider(),
//               checkBoxSelect(
//                   'Other Paid Services:', _paidServices, 'paidServices'),
//               Divider(),
//               Column(
//                 children: <Widget>[
//                   Text('Current Access To Toilet'),
//                   Divider(),
//                   checkBoxSelect('Privacy:', _privacyList, 'privacy'),
//                   Divider(),
//                   checkBoxSelect('Type:', _typeList, 'type'),
//                   Divider(),
//                   checkBoxSelect('Security:', _securityList, 'security'),
//                   Divider(),
//                 ],
//               ),
//               Divider()
//             ],
//           ),
//         ),
//         isActive: _currentStep >= 3,
//       ),
//       Step(
//         title: Text('Status'),
//         content: Form(
//           key: _statusFormKey,
//           child: Column(
//             children: <Widget>[
//               selectStatus(),
//               Divider(),
//               getMultilineText('Comment', 'comment')
//             ],
//           ),
//         ),
//         isActive: _currentStep >= 4,
//       ),
//     ]);
//   }

//   Widget followUpOrUpdate() {
//     return (_status == 'Follow Up'
//         ? Text('FOLLOW UP DATE: $_fUDate')
//         : Text('TOILET INSTALLATION DATE: $_tIDate'));
//   }

//   void leadData(TaskModel model) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Lead Details'),
//             content: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text('NAME: $_lastName $_firstName'),
//                   Divider(),
//                   Text('TERRITORY: $_territory'),
//                   Divider(),
//                   Text('SUB-TERRITORY: $_subTerritory'),
//                   Divider(),
//                   Text('GENDER: $_gender'),
//                   Divider(),
//                   Text('LEAD TYPE: $_leadType'),
//                   Divider(),
//                   Text('TOILET TYPE: $_toiletType'),
//                   Divider(),
//                   Text('NUMBER OF TOILETS: $_noOfToilets'),
//                   Divider(),
//                   Text('ADDRESS: $_address'),
//                   Divider(),
//                   Text('PRIMARY TELEPHONE: $_primaryTelephone'),
//                   Divider(),
//                   Text('STATUS: $_status'),
//                   Divider(),
//                   followUpOrUpdate()
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text('SAVE'),
//                 onPressed: ()  {
//                   model.addLead(new Leads(
//                       _firstName,
//                       _lastName,
//                       _otherNames,
//                       _territory,
//                       _subTerritory,
//                       _block,
//                       _gender,
//                       _primaryTelephone,
//                       _secondaryTelephone,
//                       _referred,
//                       _toiletType,
//                       _noOfToilets,
//                       _noOfMaleAdults,
//                       _noOfFemaleAdults,
//                       _noOfMaleChildren,
//                       _noOfFemaleChildren,
//                       _latitude,
//                       _longitude,
//                       _infoSourceSelected,
//                       _leadType,
//                       _disability,
//                       _reasonsSelected,
//                       _status,
//                       _comment,
//                       1, // created by
//                       _serviceProvider,
//                       _telephoneType,
//                       _salariedWorker,
//                       _paymentDate,
//                       _servicesSelected,
//                       _typeSelected,
//                       _securitySelected,
//                       _privacySelected,
//                       _fUDate,
//                       _tIDate,
//                       _sIDate,
//                       _address,
//                       _startTime,
//                       _endTime,
//                       null,
//                       null,
//                       null),);

//                   // try {
//                   //   currentLocation = await location.getLocation();
//                   //   setState(() {
//                   //     _latitude = currentLocation['latitude'];
//                   //     _longitude = currentLocation['longitude'];
//                   //   });
//                   //   setState(() {
//                   //     _endTime = DateTime.now().hour.toString() +
//                   //         ':' +
//                   //         DateTime.now().minute.toString() +
//                   //         ':' +
//                   //         DateTime.now().second.toString();
//                   //   });
//                   //   var data = {
//                   //     'fname': _firstName,
//                   //     'lname': _lastName,
//                   //     'onames': _otherNames,
//                   //     'terrisectownid': _territory,
//                   //     'subterrizonecomid': _subTerritory,
//                   //     'block': _block,
//                   //     'gender': _gender,
//                   //     'pritelephone': _primaryTelephone,
//                   //     'sectelephone': _secondaryTelephone,
//                   //     'referredBy': _referredBy,
//                   //     'toilettypeid': _toiletType,
//                   //     'numoftoilets': _noOfToilets,
//                   //     'numofmaleadults': _noOfMaleAdults,
//                   //     'numoffemaleadults': _noOfFemaleAdults,
//                   //     'numofmalechildren': _noOfMaleChildren,
//                   //     'numoffemalechildren': _noOfFemaleChildren,
//                   //     'lat': _latitude,
//                   //     'lng': _longitude,
//                   //     'soofinfo': _infoSourceSelected,
//                   //     'leadtype': _leadType,
//                   //     'disability': _disability,
//                   //     'resofenroll': _reasonsSelected,
//                   //     'status': _status,
//                   //     'comments': _comment,
//                   //     'teleserpro': _serviceProvider,
//                   //     'teletype': _telephoneType,
//                   //     'issalworker': _salariedWorker,
//                   //     'dateofpay': _paymentDate,
//                   //     'opaidservices': _servicesSelected,
//                   //     'toilettype': _typeSelected,
//                   //     'toiletsecu': _securitySelected,
//                   //     'toiletprivacy': _privacySelected,
//                   //     'follupdate': _fUDate,
//                   //     'installdate': _tIDate,
//                   //     'sinspecdate': _sIDate,
//                   //     'address': _address,
//                   //     'stime': _startTime,
//                   //     'ntime': _endTime,
//                   //   };
//                   //  //print(data);
//                   //   model.addLead(new Lead(
//                   //       _firstName,
//                   //       _lastName,
//                   //       _otherNames,
//                   //       _territory,
//                   //       _subTerritory,
//                   //       _block,
//                   //       _gender,
//                   //       _primaryTelephone,
//                   //       _secondaryTelephone,
//                   //       _referred,
//                   //       _toiletType,
//                   //       _noOfToilets,
//                   //       _noOfMaleAdults,
//                   //       _noOfFemaleAdults,
//                   //       _noOfMaleChildren,
//                   //       _noOfFemaleChildren,
//                   //       _latitude,
//                   //       _longitude,
//                   //       _infoSourceSelected,
//                   //       _leadType,
//                   //       _disability,
//                   //       _reasonsSelected,
//                   //       _status,
//                   //       _comment,
//                   //       _serviceProvider,
//                   //       _telephoneType,
//                   //       _salariedWorker,
//                   //       _paymentDate,
//                   //       _servicesSelected,
//                   //       _typeSelected,
//                   //       _securitySelected,
//                   //       _privacySelected,
//                   //       _fUDate,
//                   //       _tIDate,
//                   //       _sIDate,
//                   //       _address,
//                   //       _startTime,
//                   //       _endTime));
//                   //   model.fetchLeads();
//                   //   print(model.leads);
//                   //   Navigator.of(context).pop();
//                   // } catch (e) {
//                   //   currentLocation = null;
//                   // }
//                   // print(currentLocation);
//                 },
//               ),
//               FlatButton(
//                 child: Text('CANCEL'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               )
//             ],
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScopedModel<TaskModel>(
//       model: new TaskModel(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Update Lead'),
//         ),
//         // body: Center(
//         //   child: RaisedButton(
//         //     child: Text('Tap'),
//         //     onPressed: () {
//         //       _getLocation();
//         //     },
//         //   )
//         // ),
//         body: new ScopedModelDescendant<TaskModel>(
//             builder: (context, child, model) {
//           return Stepper(
//             controlsBuilder: (BuildContext context,
//                 {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
//               return Row(
//                 children: <Widget>[
//                   RaisedButton(
//                     color: Theme.of(context).primaryColor,
//                     child: Text('Continue'),
//                     onPressed: onStepContinue,
//                   ),
//                   FlatButton(
//                     child: Text('Previous'),
//                     onPressed: onStepCancel,
//                   ),
//                 ],
//               );
//             },
//             steps: _leadDetails(model),
//             currentStep: _currentStep,
//             onStepTapped: (step) {
//               if (this._currentStep >= step) {
//                 setState(() {
//                   this._currentStep = step;
//                 });
//               }
//             },
//             onStepContinue: () {
//               if (this._currentStep <= 0) {
//                 if (_personalDetailsFormKey.currentState.validate()) {
//                   _personalDetailsFormKey.currentState.save();
//                   setState(() {
//                     this._currentStep = this._currentStep + 1;
//                   });
//                 }
//               } else if (this._currentStep <= 1) {
//                 if (_toiletInformationFormKey.currentState.validate()) {
//                   _toiletInformationFormKey.currentState.save();
//                   setState(() {
//                     this._currentStep = this._currentStep + 1;
//                   });
//                 }
//               } else if (this._currentStep <= 2) {
//                 if (_contactInformationFormKey.currentState.validate()) {
//                   _contactInformationFormKey.currentState.save();
//                   setState(() {
//                     this._currentStep = this._currentStep + 1;
//                   });
//                 }
//               } else if (this._currentStep <= 3) {
//                 if (_additionalInformationFormKey.currentState.validate()) {
//                   _additionalInformationFormKey.currentState.save();
//                   setState(() {
//                     this._currentStep = this._currentStep + 1;
//                   });
//                 }
//               } else if (this._currentStep <= 4) {
//                 if (_statusFormKey.currentState.validate()) {
//                   _statusFormKey.currentState.save();
//                   leadData(model);
//                 }
//               }
//             },
//             onStepCancel: () {
//               if (this._currentStep > 0) {
//                 setState(() {
//                   this._currentStep = this._currentStep - 1;
//                 });
//               } else {
//                 this._currentStep = 0;
//               }
//             },
//           );
//         }),
//       ),
//     );
//   }
// }
