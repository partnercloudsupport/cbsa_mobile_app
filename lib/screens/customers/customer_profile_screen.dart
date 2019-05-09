import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/models/lead_conversion.dart';
import 'package:cbsa_mobile_app/screens/customers/additional_info_screen.dart';
import 'package:cbsa_mobile_app/screens/customers/personal_info_screen.dart';
import 'package:cbsa_mobile_app/screens/customers/summary_info_screen.dart';
import 'package:cbsa_mobile_app/screens/customers/toilet_info_screen.dart';
import 'package:cbsa_mobile_app/setup_models.dart/service_provider.dart';
import 'package:flutter/material.dart';

class CustomerProfile extends StatefulWidget {
  final Lead lead;
  const CustomerProfile({Key key, this.lead}) : super(key: key);

  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class GridItem {
  String title;
  Icon icon;
  GridItem({this.title, this.icon});
}

class _CustomerProfileState extends State<CustomerProfile> {
  int selectedItem;
  List<GridItem> operations = <GridItem>[
    new GridItem(
      title: 'Summary Information',
      icon: Icon(
        Icons.all_inclusive,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Personal Information',
      icon: Icon(
        Icons.person,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Additional Information',
      icon: Icon(
        Icons.playlist_add_check,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Toilet Information',
      icon: Icon(
        Icons.list,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Toilet Servicing',
      icon: Icon(
        Icons.play_for_work,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Invoices and Payment',
      icon: Icon(
        Icons.library_books,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Complaints',
      icon: Icon(
        Icons.record_voice_over,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
    new GridItem(
      title: 'Referrals',
      icon: Icon(
        Icons.description,
        size: 60.0,
        color: Colors.blueGrey,
      ),
    ),
  ];

  @override
  initState() {
    super.initState();
    setState(() {
      selectedItem = 1;
    });
  }

  Widget items(String title, Icon icon) {
    return InkWell(
      child: Card(
        elevation: 15.0,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              Text('$title'),
            ],
          ),
        ),
      ),
      onTap: () {
        switch (title) {
          case 'Summary Information':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SummaryInfo(
                      lead: widget.lead,
                    ),
              ),
            );
            break;
          case 'Personal Information':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalInfo(
                      lead: widget.lead,
                    ),
              ),
            );
            break;
          case 'Additional Information':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdditionalInfo(lead: widget.lead),
              ),
            );
            break;
          case 'Toilet Information':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ToiletInfo(lead: widget.lead),
              ),
            );
            break;
          case 'Toilet Servicing':
            break;
          case 'Invoices and Payment':
            break;
          case 'Complaints':
            break;
          case 'Referrals':
            break;
        }
      },
    );
  }

  _getGridViewItems(BuildContext context) {
    List<Widget> allWidgets = new List<Widget>();
    for (int i = 0; i < operations.length; i++) {
      var widget = items(operations[i].title, operations[i].icon);
      allWidgets.add(widget);
    }
    return allWidgets;
  }

  Widget _customerImage(double size) {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.all(10),
          child: snapshot.hasData
              ? CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data.customerImageUrl),
                  radius: size,
                )
              : CircleAvatar(
                  backgroundImage: AssetImage('assets/profile-placeholder.png'),
                ),
        );
      },
    );
  }

  Future<LeadConversion> _getLeadConversionObject() async {
    var db = DatabaseHelper();
    var result = await db.getLeadConversion(widget.lead.id);
    return result;
  }

  Future<ServiceProvider> _getTelephoneServiceProvider() async {
    var db = DatabaseHelper();
    var result = db.getServiceProvider(widget.lead.serviceProvider);

    return result;
  }

  Future _getTelephoneType() async {
    var db = DatabaseHelper();
    var result = db.getTelephoneType(widget.lead.telephoneType);
    return result;
  }

  Widget _telephoneServiceProvider() {
    return FutureBuilder(
      future: _getTelephoneServiceProvider(),
      builder: (context, AsyncSnapshot<ServiceProvider> snapshot) {
        return _displayText('Telephone Service Provider', snapshot.data.name);
      },
    );
  }

  Widget _telephoneType() {
    return FutureBuilder(
      future: _getTelephoneType(),
      builder: (context, snapshot) {
        return _displayText('Telephone Type', snapshot.data.name);
      },
    );
  }

  Widget _homeOwnership() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return _displayText('Telephone Type', snapshot.data.homeOwnership);
      },
    );
  }

  Widget _secondaryOccupation() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return _displayText(
            'Secondary Occupation', snapshot.data.secondaryOccupation);
      },
    );
  }

  Widget _primaryOccupation() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return _displayText(
            'Primary Occupation', snapshot.data.primaryOccupation);
      },
    );
  }

  Widget _householdSavings() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return _displayText(
            'Household Savings', snapshot.data.householdSavings);
      },
    );
  }

  Widget additionalInfoView() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(seconds: 1),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              // _telephoneServiceProvider(),
              // _telephoneType(),
              _displayText('Salaried Worker', widget.lead.salariedWorker),
              // _displayText('House Savings', snapshot.data.householdSavings),
              _displayText(
                  'Primary Occupation', snapshot.data.primaryOccupation),
              _displayText(
                  'Secondary Occupation', snapshot.data.secondaryOccupation),
              _displayText('Home Ownership', snapshot.data.homeOwnership),
            ],
          ),
        );
      },
    );
  }

  Widget personalInfoView() {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(seconds: 1),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Number Of Adults',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child:
                    _displayText('Male', widget.lead.noOfMaleAdults.toString()),
              ),
              Expanded(
                child: _displayText(
                    'Female', widget.lead.noOfFemaleAdults.toString()),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Number Of Children',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _displayText(
                    'Male', widget.lead.noOfMaleChildren.toString()),
              ),
              Expanded(
                child: _displayText(
                    'Female', widget.lead.noOfFemaleChildren.toString()),
              ),
            ],
          ),
          // _sourceOfInformation(),
          // _leadType(),
          // _disability(),
          // _reasonsOfEnrollment(),
          _householdImage(),
          _landmarkImage(),
          // _payerFirstName(),
          // _payerLastName(),
          // _relationship(),
          // _payerPrimaryPhoneNumber(),
          // _payerSecondaryPhoneNumber(),
          // _payerOccupation(),
        ],
      ),
    );
  }

  Widget summaryView() {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(seconds: 1),
      child: ListView(
        children: <Widget>[
          _customerImage(100.0),
          _displayText('First Name', widget.lead.firstName),
          _displayText('Last Name', widget.lead.lastName),
          _displayText('Other Names', widget.lead.otherNames),
          // _displayText('Territory', widget.lead.territory),
          // _displayText('Subterritory', widget.lead.subTerritory),
          // _displayText('Block', widget.lead.block),
          _displayText('Address', widget.lead.address),
          _displayText('Gender', widget.lead.gender),
          _displayText('Primary Telephone No', widget.lead.primaryTelephone),
          _displayText(
              'Secondary Telephone No', widget.lead.secondaryTelephone),
          // _displayText('Toilet Type', widget.lead.toiletType),
          _displayText('Number Of Toilets', widget.lead.noOfToilets.toString()),
        ],
      ),
    );
  }

  Widget _displayText(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 10.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Text(
            value,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _householdImage() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return ListTile(
          title: Text('Household Image'),
          subtitle: Container(
            padding: EdgeInsets.all(20),
            child: snapshot.hasData
                ? Image.network(
                    snapshot.data.householdImageUrl,
                    scale: 1.5,
                  )
                : Image.asset('assets/house-placeholder.jpg'),
          ),
        );
      },
    );
  }

  Widget _landmarkImage() {
    return FutureBuilder(
      future: _getLeadConversionObject(),
      builder: (context, AsyncSnapshot<LeadConversion> snapshot) {
        return ListTile(
          title: Text('Landmark Image'),
          subtitle: Container(
            padding: EdgeInsets.all(20),
            child: snapshot.hasData
                ? Image.network(
                    snapshot.data.landmarkImageUrl,
                    scale: 1.5,
                  )
                : Image.asset('assets/landmark-placeholder.png'),
          ),
        );
      },
    );
  }

  getProfileView() {
    switch (selectedItem) {
      case 1:
        return summaryView();
        break;
      case 2:
        return personalInfoView();
        break;
      case 3:
        return additionalInfoView();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Card(
                elevation: 30.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: Container(
                    color: Colors.cyan.shade300,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          _customerImage(40.0),
                          SizedBox(
                            height: 10.0,
                          ),
                          InkWell(
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.all_inclusive,
                                  size: 50.0,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Summary',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                selectedItem = 1;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          InkWell(
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.person_pin,
                                  size: 50.0,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Personal Information',
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                selectedItem = 2;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          InkWell(
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.info,
                                  size: 50.0,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Additional Information',
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                selectedItem = 3;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Column(
                            children: <Widget>[
                              Icon(
                                Icons.info,
                                size: 50.0,
                                color: Colors.black,
                              ),
                              Text(
                                'Toilet Information',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Column(
                            children: <Widget>[
                              Icon(
                                Icons.settings,
                                size: 50.0,
                                color: Colors.black,
                              ),
                              Text(
                                'Toilet Servicing',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Column(
                            children: <Widget>[
                              Icon(
                                Icons.receipt,
                                size: 50.0,
                                color: Colors.black,
                              ),
                              Text(
                                'Invoices and Payment',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Column(
                            children: <Widget>[
                              Icon(
                                Icons.sim_card_alert,
                                size: 50.0,
                                color: Colors.black,
                              ),
                              Text(
                                'Complaints',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Column(
                            children: <Widget>[
                              Icon(
                                Icons.next_week,
                                size: 50.0,
                                color: Colors.black,
                              ),
                              Text(
                                'Referrals',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: getProfileView(),
            ),
          ],
        ),
      ),
    );
  }
}
