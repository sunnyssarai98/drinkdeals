import 'package:google_maps_flutter/google_maps_flutter.dart';

class Bar {
  String barName;
  String picURL;
  LatLng location;

  Bar({required this.barName, required this.picURL, required this.location});
}

List<Bar> bars = [
  Bar(
      barName: "Freds",
      picURL: 'assets/freds.png',
      location: LatLng(30.373199749985734, -91.17156490476393)),
  Bar(
      barName: "Mikes",
      picURL: 'assets/mikes.png',
      location: LatLng(30.39585597757133, -91.17943170225242)),
  Bar(
      barName: "Reggies",
      picURL: 'assets/reggies.png',
      location: LatLng(30.39649169335429, -91.18000358876223))
];
