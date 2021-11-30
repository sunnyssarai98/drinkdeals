import 'package:google_maps_flutter/google_maps_flutter.dart';

class Deal {
  String barName;
  String deal;
  String picURL;
  LatLng location;

  Deal({required this.barName, required this.deal, required this.picURL, required this.location});
}
