import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/firestore_utils.dart';

class LocationService with ChangeNotifier {
  bool _tracking = false;
  StreamSubscription<Position>? _positionSubscription;

  String? currentOrderId;

  bool get isTracking => _tracking;

  Future<void> startTracking({required String orderId}) async {
    if (_tracking) return;
    _tracking = true;
    currentOrderId = orderId;
    notifyListeners();

    // Permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return;
      }
    }

    await _positionSubscription?.cancel();

    _positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((pos) async {
          debugPrint('${pos.latitude}, ${pos.longitude}');
          if (!_tracking || currentOrderId == null) return;

          String address = await _getAddress(pos.latitude, pos.longitude);

          final model = {
            "driverId": "driver_1",
            "orderId": currentOrderId!,
            "latitude": pos.latitude,
            "longitude": pos.longitude,
            "address": address,
            "timestamp": DateTime.now().toIso8601String(),
          };

          FirestoreUtils.createLocation(model);
          notifyListeners();
        });
  }

  void stopTracking() {
    _tracking = false;
    currentOrderId = null;
    _positionSubscription?.cancel();
    _positionSubscription = null;
    notifyListeners();
  }

  Future<String> _getAddress(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        return "${p.street}, ${p.locality}, ${p.country}";
      }
      return "Unknown Location";
    } catch (e) {
      return "Error fetching address";
    }
  }
}
