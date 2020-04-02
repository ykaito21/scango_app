import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();
  static final instance = LocationService._();
  // factory LocationService() => instance;
  final _geolocator = Geolocator();
  final _geoFire = Geoflutterfire();
  Geoflutterfire get geoFire => _geoFire;

  Future<Position> getCurrentLocation() async {
    try {
      return await _geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
