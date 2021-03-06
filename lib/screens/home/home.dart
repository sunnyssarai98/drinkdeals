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
import 'package:geolocator/geolocator.dart';
import 'package:drink_deals/.env.dart';

// Set<Marker> markers = {};
Marker origin = Marker(markerId: MarkerId('origin'));
Marker destination = Marker(markerId: MarkerId('destination'));
Map<PolylineId, Polyline> polylines = {};
List<LatLng> polylineCoordinates = [];
PolylinePoints polylinePoints = PolylinePoints();
String apiKEY = googleAPIKey;

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
      backgroundColor: Color(0xff1d3752),
      appBar: AppBar(
        title: Text('Drink Deals'),
        backgroundColor: Color(0xff1d3752),
        foregroundColor: Colors.white,
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
              backgroundColor: Color(0xff214d72),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Map",
              backgroundColor: Color(0xff2c7695),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Account",
              backgroundColor: Color(0xff50bfc3),
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
                'User:',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'sunnyssarai98@gmail.com',
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
  late Position currentPosition;
  var geoLocator = Geolocator();
  late GoogleMapController _googleMapController;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    currentPosition = position;

    LatLng latlngCurrentPosition =
        LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latlngCurrentPosition, zoom: 18);
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    setState(() {
      origin = Marker(
          markerId: MarkerId('origin'),
          infoWindow: InfoWindow(
              title: 'Origin', snippet: 'Where your journey begins!'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          position: LatLng(30.4072, -91.1798));
    });
    _getPolyline();
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(30.41203960806777, -91.18379484423802),
    zoom: 16,
  );

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  void _setOrigin(LatLng pos) async {
    setState(() {
      origin = Marker(
          markerId: MarkerId('origin'),
          infoWindow: InfoWindow(
              title: 'Origin', snippet: 'Where your journey begins!'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          position: pos);
    });
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(30.41203960806777, -91.18379484423802),
        PointLatLng(30.41203960806777, -91.18479484423802),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Tiger Stadium")]);
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) {
          _googleMapController = controller;
          _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
        markers: {
          if (origin != null) origin,
          if (destination != null) destination,
        },
        polylines: Set<Polyline>.of(polylines.values),
        onLongPress: _setOrigin,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => locatePosition(),
        child: const Icon(Icons.center_focus_strong),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }
}

class DealsScreen extends StatefulWidget {
  const DealsScreen({Key? key}) : super(key: key);

  @override
  _DealsScreenState createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  void setDestination() async {
    setState(() {
      destination = Marker(
          markerId: MarkerId('destination'),
          infoWindow: InfoWindow(
              title: 'Destination', snippet: 'Your beaverage awaits!'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          position: LatLng(30.39613, -91.17951));
    });
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
              for (int i = 0; i < deals.length; i++)
                Card(
                    child: ListTile(
                  onTap: () => setDestination(),
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
        child: Text(
          "+",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Color(0xfff7c232),
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
        backgroundColor: Color(0xfff7c232),
      ),
    );
  }
}
