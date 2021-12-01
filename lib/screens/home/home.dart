// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

// import 'dart:html';

import 'package:drink_deals/screens/home/bar.dart';
import 'package:drink_deals/screens/home/deal.dart';
import 'package:drink_deals/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:dio/dio.dart';
import 'package:drink_deals/shared/constants.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

List<Deal> deals = [
  Deal(bar: bars[0], deal: '\$5 Drinks'),
  Deal(bar: bars[1], deal: 'Free Drinks'),
  Deal(bar: bars[2], deal: '\$1 Shots')
];

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
        backgroundColor: Color(0xffd4af37),
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
          iconSize: 20,
          selectedFontSize: 14,
          unselectedFontSize: 8,
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
              backgroundColor: Color(0xff355c7d),
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
  // late List<Deal> deals = [
  //   Deal(bar: bars[0], deal: '\$5 Drinks'),
  //   Deal(bar: bars[1], deal: 'Free Drinks'),
  //   Deal(bar: bars[2], deal: '\$1 Shots')
  // ];

  // void setupDeals() async {
  //   deals = [
  //     Deal(bar: bars[0], deal: '\$5 Drinks'),
  //     Deal(bar: bars[1], deal: 'Free Drinks'),
  //     Deal(bar: bars[2], deal: '\$1 Shots')
  //   ];
  // }

  @override
  void initState() {
    super.initState();
    //setupDeals();
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
              for (int i = 0; i < deals.length; i++)
                Card(
                    child: ListTile(
                  onTap: () {},

                  // () => Navigator.push(
                  // context,
                  // MaterialPageRoute(builder: (context) => const MapScreen())
                  // ),
                  title: Text(
                    deals[i].bar.barName + '\t - \t' + deals[i].deal,
                  ),
                  trailing: InkWell(
                      child: CircleAvatar(
                    backgroundImage: AssetImage(deals[i].bar.picURL),
                  )),
                )),
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
              for (int i = 0; i < deals.length; i++)
                Card(
                    child: ListTile(
                  onTap: () {},

                  // () => Navigator.push(
                  // context,
                  // MaterialPageRoute(builder: (context) => const MapScreen())
                  // ),
                  title: Text(
                    deals[i].bar.barName + '\t - \t' + deals[i].deal,
                  ),
                  trailing: InkWell(
                      child: CircleAvatar(
                    backgroundImage: AssetImage(deals[i].bar.picURL),
                  )),
                )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddScreen())),
        child: Text("+"),
        backgroundColor: Colors.purple,
      ),
    );
  }
}

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    for (int i = 0; i < bars.length; i++)
      DropdownMenuItem(child: Text(bars[i].barName), value: bars[i].barName),
  ];
  return menuItems;
}

class _AddScreenState extends State<AddScreen> {
  String? value;

  late String newdeal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 0.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Form(
                    child: Column(children: <Widget>[
                  TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Deal description'),
                      validator: (val) =>
                          val!.isEmpty ? 'Field cannot be null' : null,
                      onChanged: (val) {
                        setState(() => newdeal = val);
                      }),
                  SizedBox(height: 20),
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.all(16),
                    child: DropdownButton<String>(
                      value: value,
                      items: dropdownItems,
                      onChanged: (value) => this.value = value,
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.black,
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      child: Text("Add"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  )
                ]))
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: Text("Return"),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
