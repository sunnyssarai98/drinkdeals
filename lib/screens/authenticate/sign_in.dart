import 'package:drink_deals/services/auth.dart';
import 'package:drink_deals/shared/constants.dart';
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
      backgroundColor: Color(0xff2c7695),
      appBar: AppBar(
          backgroundColor: Color(0xff1d3752),
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
          padding: const EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 20.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Image(
                  height: 125.0,
                  image: AssetImage('assets/logo.png'),
                ),
              ),
              Expanded(
                flex: 1,
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(children: <Widget>[
                        TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xfff3f3f3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                hintText: 'e-mail'),
                            validator: (val) =>
                                val!.isEmpty ? 'Please enter an e-mail' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            }),
                        SizedBox(height: 20),
                        TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xfff3f3f3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                hintText: 'password'),
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
                                  MaterialStateProperty.all(Color(0xfff7c232)),
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
                      ]),
                    )),
              ),
              ElevatedButton(
                  child: Text('Continue as guest'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff214d72))),
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
