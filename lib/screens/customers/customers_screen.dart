import 'package:cbsa_mobile_app/Utils/database_helper.dart';
import 'package:cbsa_mobile_app/models/customer.dart';
import 'package:cbsa_mobile_app/models/lead.dart';
import 'package:cbsa_mobile_app/screens/complaint_management/new_complaint_screen.dart';
import 'package:cbsa_mobile_app/screens/customers/customer_profile_screen.dart';
import 'package:cbsa_mobile_app/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Customers extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  List<Lead> _activeCustomerList = new List();
  List<Lead> _activeFilteredList = new List();
  List<Lead> _suspendedCustomerList = new List();
  List<Lead> _suspendedFilteredList = new List();
  List<Lead> _inactiveCustomerList = new List();
  List<Lead> _inactiveFilteredList = new List();
  Widget _appTitle = new Text('Customers');
  Icon _searchIcon = new Icon(Icons.search);
  String _searchText = '';
  TextEditingController _filter = new TextEditingController();

  bool _loading = false;

  void initState() {
    super.initState();

    _updateCustomers();

    _getAllActiveCustomers();
    _getAllSuspendedCustomers();
    _getAllInactiveCustomers();

    _filter.addListener(_getSearchText);
  }

  void _updateCustomers() async {
    setState(() {
      _loading = true;
    });
    Fluttertoast.showToast(
      msg: 'Updating Customers...',
      toastLength: Toast.LENGTH_SHORT
    );

    var db = new DatabaseHelper();
    var allCustomers = await db.getAllCustomers();
    List<int> customersIds = new List();

    for(var x in allCustomers) {
      customersIds.add(x['id']);
    }

    var response = await CustomerService.updateCustomers();
    List<Customer> customers = new List();
    
    if(response.statusCode == 200) {
      for(var i in response.data) {
        customers.add(Customer.map(i));
      }

      for(var customer in customers) {
        if(customersIds.contains(customer.id)) {
          await db.updateCustomer(customer);
        }
      }

      Fluttertoast.showToast(
        msg: 'Customers Updated',
        toastLength: Toast.LENGTH_SHORT
      );

      setState(() {
        _loading = false;
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Could Not Update',
        toastLength: Toast.LENGTH_SHORT
      );

      setState(() {
        _loading = false;
      });
    }
  }

  void _getAllActiveCustomers() async {
    var db = DatabaseHelper();
    var activeCustomers = await db.getCustomerType(1);

    List<Lead> tempList = new List();

    if(activeCustomers != null) {
      for(var i in activeCustomers) {
        var res = await db.getLead(i['leadid']);
        if(res != null) {
          tempList.add(res);
        }
      }
    }

    setState(() {
      _activeCustomerList = tempList;
      _activeFilteredList = tempList;
    });
  }

  void _getAllSuspendedCustomers() async {
    var db = DatabaseHelper();
    var suspendedCustomers = await db.getCustomerType(26);

    List<Lead> tempList = new List();

    if(suspendedCustomers != null) {
      for(var i in suspendedCustomers) {
        var res = await db.getLead(i['leadid']);
        if(res != null) {
          tempList.add(res);
        }
      }
    }

    setState(() {
      _suspendedCustomerList = tempList;
      _suspendedFilteredList = tempList;
    });
  }

  void _getAllInactiveCustomers() async {
    var db = DatabaseHelper();
    var inactiveCustomers = await db.getCustomerType(27);

    List<Lead> tempList = new List();

    if(inactiveCustomers != null) {
      for(var i in inactiveCustomers) {
        var res = await db.getLead(i['leadid']);
        if(res != null) {
          tempList.add(res);
        }
      }
    }

    setState(() {
      _inactiveCustomerList = tempList;
      _inactiveFilteredList = tempList;
    });
  }

  void _getSearchText() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = '';
          _activeFilteredList = _activeCustomerList;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          List<Lead> tempList = new List();
          for (var i in _activeCustomerList) {
            if (i.firstName.toLowerCase().contains(_searchText.toLowerCase()) ||
                i.lastName.toLowerCase().contains(_searchText.toLowerCase())) {
              tempList.add(i);
            }
          }
          _activeFilteredList = tempList;
        });
      }
    });
  }

  void _onSearchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appTitle = new TextField(
          controller: _filter,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Search Customer...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appTitle = new Text('Customers');
        _activeFilteredList = _activeCustomerList;
        _suspendedFilteredList = _suspendedCustomerList;
        _inactiveFilteredList = _inactiveCustomerList;
        _filter.clear();
      }
    });
  }

  Widget _activeCustomersView() {
    if (_searchText.isNotEmpty) {
      List<Lead> tempList = new List();
      for (var i in _activeFilteredList) {
        if (i.firstName.toLowerCase().contains(_searchText.toLowerCase()) ||
            i.lastName.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(i);
        }
      }
      _activeFilteredList = tempList;
    }

    return ListView.builder(
      itemCount: _activeFilteredList.length,
      itemBuilder: (BuildContext context, int index) {
        String firstName = _activeFilteredList[index].firstName;
        String lastName = _activeFilteredList[index].lastName;
        String initials = firstName.substring(0, 1).toUpperCase() +
            lastName.substring(0, 1).toUpperCase();
        String primaryPhoneNumber = _activeFilteredList[index].primaryTelephone;
        String address = _activeFilteredList[index].address;

        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CustomerProfile(lead: _activeFilteredList[index])));
          },
          child: Card(
            elevation: 5.0,
            margin: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 5.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Hero(
                              tag: _activeFilteredList[index].id,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  initials,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25.0),
                                ),
                                radius: 40.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 3.0),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(firstName + ' ' + lastName),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(primaryPhoneNumber),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(address),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewComplaint(id: _activeFilteredList[index].id,)),
                          );
                        },
                        child: Text('Complaints'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _suspendedCustomersView() {
    return ListView.builder(
      itemCount: _suspendedFilteredList.length,
      itemBuilder: (BuildContext context, int index) {
        String firstName = _suspendedFilteredList[index].firstName;
        String lastName = _suspendedFilteredList[index].lastName;
        String initials = firstName.substring(0, 1).toUpperCase() +
            lastName.substring(0, 1).toUpperCase();
        String primaryPhoneNumber = _suspendedFilteredList[index].primaryTelephone;
        String address = _suspendedFilteredList[index].address;

        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CustomerProfile(lead: _suspendedFilteredList[index])));
          },
          child: Card(
            elevation: 5.0,
            margin: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 5.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Hero(
                              tag: _suspendedFilteredList[index].id,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  initials,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25.0),
                                ),
                                radius: 40.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 3.0),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(firstName + ' ' + lastName),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(primaryPhoneNumber),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(address),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _inactiveCustomersView() {
    return ListView.builder(
      itemCount: _inactiveFilteredList.length,
      itemBuilder: (BuildContext context, int index) {
        String firstName = _inactiveFilteredList[index].firstName;
        String lastName = _inactiveFilteredList[index].lastName;
        String initials = firstName.substring(0, 1).toUpperCase() +
            lastName.substring(0, 1).toUpperCase();
        String primaryPhoneNumber = _inactiveFilteredList[index].primaryTelephone;
        String address = _inactiveFilteredList[index].address;

        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CustomerProfile(lead: _inactiveFilteredList[index])));
          },
          child: Card(
            elevation: 5.0,
            margin: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 5.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Hero(
                              tag: _inactiveFilteredList[index].id,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  initials,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25.0),
                                ),
                                radius: 40.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 3.0),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(firstName + ' ' + lastName),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(primaryPhoneNumber),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(address),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: _appTitle,
          actions: <Widget>[
            new IconButton(
              icon: _searchIcon,
              onPressed: () => _onSearchPressed(),
            )
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Active',
              ),
              Tab(
                text: 'Suspended',
              ),
              Tab(
                text: 'Inactive',
              )
            ],
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          child: TabBarView(
            children: <Widget>[
              _activeCustomerList.length > 0
              ? _activeCustomersView()
              : Container(
                child: Center(
                  child: Text('No Active Customers'),
                ),
              ),
              _suspendedCustomerList.length > 0
              ? _suspendedCustomersView()
              : Container(
                child: Center(
                  child: Text('No Suspended Customers'),
                ),
              ),
              _inactiveCustomerList.length > 0
              ? _inactiveCustomersView()
              : Container(
                child: Center(
                  child: Text('No Inactive Customers'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
