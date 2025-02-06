import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _lastKnownPosition;
  String? _lastKnownAddress;
  bool _isAtHome = false;
  final double _homeRadius = 100.0; // metre cinsinden ev çevresi yarıçapı

  Future<void> initialize() async {
    // Konum izinlerini kontrol et ve iste
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Konum servisleri devre dışı.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Konum izinleri reddedildi.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Konum izinleri kalıcı olarak reddedildi.');
    }

    // Kayıtlı ev konumunu al
    await _loadHomeLocation();

    // Konum değişikliklerini dinlemeye başla
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 10 metrede bir güncelle
      ),
    ).listen(_handleLocationUpdate);
  }

  Future<void> setHomeLocation() async {
    _lastKnownPosition = await Geolocator.getCurrentPosition();
    if (_lastKnownPosition != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('home_lat', _lastKnownPosition!.latitude);
      await prefs.setDouble('home_lng', _lastKnownPosition!.longitude);

      // Adres bilgisini al ve kaydet
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _lastKnownPosition!.latitude,
        _lastKnownPosition!.longitude,
      );
      if (placemarks.isNotEmpty) {
        _lastKnownAddress = '${placemarks.first.street}, ${placemarks.first.locality}';
        await prefs.setString('home_address', _lastKnownAddress!);
      }
    }
  }

  Future<void> _loadHomeLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final homeLat = prefs.getDouble('home_lat');
    final homeLng = prefs.getDouble('home_lng');
    _lastKnownAddress = prefs.getString('home_address');

    if (homeLat != null && homeLng != null) {
      _lastKnownPosition = Position(
        latitude: homeLat,
        longitude: homeLng,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }
  }

  void _handleLocationUpdate(Position position) async {
    if (_lastKnownPosition != null) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _lastKnownPosition!.latitude,
        _lastKnownPosition!.longitude,
      );

      bool wasAtHome = _isAtHome;
      _isAtHome = distance <= _homeRadius;

      // Ev durumu değiştiğinde bildirimleri tetikle
      if (wasAtHome != _isAtHome) {
        NotificationCallback? callback = onLocationStatusChanged;
        if (callback != null) {
          callback(_isAtHome);
        }
      }
    }
  }

  // Konum durumu değiştiğinde çağrılacak callback
  NotificationCallback? onLocationStatusChanged;

  bool get isAtHome => _isAtHome;
  String? get homeAddress => _lastKnownAddress;
}

typedef NotificationCallback = void Function(bool isAtHome); 