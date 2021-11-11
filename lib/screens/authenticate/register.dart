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

  //text field state
  String email = '';
  String password = '';

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
                  child: Column(children: <Widget>[
                SizedBox(height: 20),
                TextFormField(onChanged: (val) {
                  setState(() => email = val);
                }),
                SizedBox(height: 20),
                TextFormField(
                    obscureText: true,
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
                  onPressed: () async {},
                )
              ])),
              ElevatedButton(
                  child: Text('Sign in anon'),
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
