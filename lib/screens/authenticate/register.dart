import 'package:drink_deals/shared/constants.dart';
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

  //Register Card Text
  String mainText_1 = "TO CREATE AN ACCOUNT:";
  String bulletPoints_1 =
      "\t- Valid e-mail \n\t- Password (7 characters minimum)";

  Widget registerCardTemplate(mainText, bulletPoints) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 120),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: Column(children: <Widget>[
          Text(mainText,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              )),
          SizedBox(
            height: 6.0,
          ),
          Text(
            bulletPoints,
            style: TextStyle(fontSize: 12.0, color: Colors.grey[800]),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff2c7695),
      appBar: AppBar(
          backgroundColor: Color(0xff1d3752),
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
          padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 20.0),
          child: Column(
            children: [
              // Expanded(
              //   child: Image(
              //     height: 125.0,
              //     image: AssetImage('assets/logo.png'),
              //   ),
              // ),
              Expanded(
                  flex: 1,
                  child: registerCardTemplate(mainText_1, bulletPoints_1)),
              //const SizedBox(height: 25.0),
              Expanded(
                flex: 1,
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      TextFormField(
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xfff3f3f3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              hintText: 'username'),
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
                        child: Text('register'),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xfff7c232)),
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
              ),
              ElevatedButton(
                  child: Text('Continue as guest'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff214d72))),
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
