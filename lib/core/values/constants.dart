class AppConstants {
  // API
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = 'v1';

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String keyToken = 'token';
  static const String keyUserId = 'user_id';
  static const String keyUserData = 'user_data';

  // Ride Types
  static const String rideTypeEconomy = 'economy';
  static const String rideTypeComfort = 'comfort';
  static const String rideTypePremium = 'premium';

  // Map
  static const double defaultZoom = 15.0;
  static const double defaultLatitude = 23.8103;
  static const double defaultLongitude = 90.4125;
}
