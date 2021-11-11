import 'package:drink_deals/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
          title: Text('Welcome To Drink Deals'),
          actions: <Widget>[
            TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('Register'),
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
                      child: Text('sign in'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.pink[400]),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(color: Colors.white))),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() => errorMSG =
                                'Could not sign in with email/username.');
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
                      print('');
                    } else {
                      print('');
                      print(result);
                    }
                  }),
            ],
          )),
    );
  }
}
