import 'package:drink_deals/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[50],
        appBar: AppBar(
          title: Text('Drink Deals'),
          backgroundColor: Colors.yellow[500],
          foregroundColor: Colors.black87,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
                icon: Icon(Icons.local_drink),
                label: Text('logout'),
                onPressed: () async {
                  await _auth.signOut();
                })
          ],
        ));
  }
}
