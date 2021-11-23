// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'dart:html';

import 'package:drink_deals/screens/home/deal.dart';
import 'package:drink_deals/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:dio/dio.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int _currentIndex = 0;

  // Deal d1 = deals[1];
  var tabs = [
    DealsScreen(),
    MapScreen(),
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
      body: SingleChildScrollView(
        child: Padding(
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
                  backgroundImage: AssetImage('assets/freds.png'),
                )),
              )),
              Card(
                  child: ListTile(
                onTap: () {},
                title: Text(deals[1].barName + '\t - \t' + deals[1].deal),
                trailing: InkWell(
                    child: CircleAvatar(
                  backgroundImage: AssetImage('assets/mikes.png'),
                )),
              )),
              Card(
                child: ListTile(
                  onTap: () {},
                  title: Text(deals[2].barName + '\t - \t' + deals[2].deal),
                  trailing: InkWell(
                      child: CircleAvatar(
                    backgroundImage: AssetImage('assets/reggies.png'),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(30.41203960806777, -91.18379484423802),
    zoom: 16,
  );

  late GoogleMapController _googleMapController;
  Set<Marker> _markers = {};

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  void _setOrigin(LatLng pos) {
    print('test');
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('origin'),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) {
          _googleMapController = controller;
          _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
        markers: _markers,
        onLongPress: _setOrigin,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(_initialCameraPosition)),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}

class DealsScreen extends StatefulWidget {
  const DealsScreen({Key? key}) : super(key: key);

  @override
  _DealsScreenState createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                  child: ListTile(
                onTap: () {},
                title: Text('Freds'),
                trailing: InkWell(
                    child: CircleAvatar(
                  backgroundImage: AssetImage('assets/freds.png'),
                )),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
