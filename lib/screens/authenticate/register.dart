import 'package:flutter/material.dart';
import 'package:drink_deals/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //text field state
  String email = '';
  String password = '';
  String errorMSG = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
          backgroundColor: Colors.purple[500],
          elevation: 0.0,
          title: Text('Sign Up To Drink Deals'),
          actions: <Widget>[
            TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('Sign In'),
                onPressed: () {
                  widget.toggleView();
                })
          ]),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Please enter an e-mail' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        }),
                    SizedBox(height: 20),
                    TextFormField(
                        obscureText: true,
                        validator: (val) => val!.length < 7
                            ? 'Please enter a password with 7+ characters'
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        }),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text('register'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.pink[400]),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white))),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(
                                () => errorMSG = 'please use a valid email.');
                          }
                        }
                      },
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      errorMSG,
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    )
                  ])),
              ElevatedButton(
                  child: Text('Continue as guest'),
                  onPressed: () async {
                    dynamic result = await _auth.signInAnon();
                    if (result == null) {
                      print('error signing in');
                    } else {
                      print('signed in');
                      print(result);
                    }
                  }),
            ],
          )),
    );
  }
}
