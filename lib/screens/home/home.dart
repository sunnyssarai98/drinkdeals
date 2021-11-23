// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:drink_deals/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int _currentIndex = 0;

  var tabs = [
    Center(child: Text('Home')),
    Center(child: Text('Map')),
    Center(child: Text('Account')),
  ];

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
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.shifting,
          iconSize: 27,
          selectedFontSize: 18,
          unselectedFontSize: 10,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "List",
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Map",
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Account",
              backgroundColor: Colors.blue,
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }
}
