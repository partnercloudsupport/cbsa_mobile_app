import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  var _recoveryEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Recovery'),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Please Enter Your Recovery Email In The Field Below:'),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                  onSaved: (value) {
                    _recoveryEmail = value;
                  },
                ),
              ),
              MaterialButton(
                child: Text('Submit'),
                onPressed: () {
                  if(_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    print('$_recoveryEmail');
                  }
                },
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
