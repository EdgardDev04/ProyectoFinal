import 'package:latlong2/latlong.dart';

class Store {
  final String name;
  final String street;
  final String sector;
  final String number;
  final LatLng location;

  Store({
    required this.name,
    required this.street,
    required this.sector,
    required this.number,
    required this.location,
  });
}
