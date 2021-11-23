// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'dart:html';

import 'package:drink_deals/screens/home/deal.dart';
import 'package:drink_deals/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int _currentIndex = 0;

  // Deal d1 = deals[1];
  var tabs = [
    Center(child: Text('Home')),
    Center(child: Text('Map')),
    AccountScreen(),
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

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late List<Deal> deals = [
    Deal(barName: 'Freds', deal: '\$5 Drinks', picURL: 'freds.png'),
    Deal(barName: 'Mikes', deal: 'Free Drinks', picURL: 'mikes.png'),
    Deal(barName: 'Reggies', deal: '\$1 Shots', picURL: 'Reggies')
  ];

  void setupDeals() async {
    deals = [
      Deal(barName: 'Freds', deal: '\$5 Drinks', picURL: 'freds.png'),
      Deal(barName: 'Mikes', deal: 'Free Drinks', picURL: 'mikes.png'),
      Deal(barName: 'Reggies', deal: '\$1 Shots', picURL: 'Reggies')
    ];
  }

  @override
  void initState() {
    super.initState();
    setupDeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/user.png'),
                radius: 40.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(
                'LOUISIANA STATE UNIVERSITY',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            Divider(
              height: 50.0,
              color: Colors.grey[700],
            ),

            Text(
              'USERNAME',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'drinkdeals_user1',
              style: TextStyle(
                  color: Colors.amber[200],
                  letterSpacing: 2.0,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30.0,
            ),
            // ignore: prefer_const_constructors
            Text(
              'FAVORITE DEALS',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Card(
                child: ListTile(
              onTap: () {},
              title: Text(
                deals[0].barName + '\t - \t' + deals[0].deal,
              ),
              trailing: InkWell(
                  child: CircleAvatar(
                backgroundImage: AssetImage('assets/freds.PNG'),
              )),
            )),
            Card(
                child: ListTile(
              onTap: () {},
              title: Text(deals[1].barName + '\t - \t' + deals[1].deal),
              trailing: InkWell(
                  child: CircleAvatar(
                backgroundImage: AssetImage('assets/mikes.PNG'),
              )),
            )),
            Card(
              child: ListTile(
                onTap: () {},
                title: Text(deals[2].barName + '\t - \t' + deals[2].deal),
                trailing: InkWell(
                    child: CircleAvatar(
                  backgroundImage: AssetImage('assets/reggies.PNG'),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
