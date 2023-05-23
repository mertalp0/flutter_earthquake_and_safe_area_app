import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'directions_event.dart';
import 'directions_state.dart';

class DirectionsBloc extends Bloc<DirectionsEvent, DirectionsState> {
  DirectionsBloc() : super(DirectionsInitial()) {
    on<DirectionsEvent>((event, emit) async {
      if (event is GetDirections) {
        emit(DirectionsLoading());

        try {
          final currentPosition = await _getCurrentPosition();
          final markers = _createMarkers(currentPosition);
          final circles = _createCircles(currentPosition);
          final polylines = await _getPolylines(currentPosition,
              LatLng(event.field.latitude, event.field.longitude));

          emit(DirectionsLoaded(
              currentPosition: currentPosition,
              markers: markers,
              circles: circles,
              polylines: polylines,
              destination:
                  LatLng(event.field.latitude, event.field.longitude)));
        } catch (error) {
          emit(DirectionsError(error: error.toString()));
        }
      }
    });
  }

  Future<Position> _getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  List<Circle> _createCircles(Position currentPosition) {
    return [
      Circle(
        circleId: const CircleId('currentLocation'),
        center: LatLng(currentPosition.latitude, currentPosition.longitude),
        radius: 20,
        fillColor: Colors.blue.withOpacity(0.8),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    ];
  }

  List<Marker> _createMarkers(Position currentPosition) {
    return [
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        markerId: const MarkerId('currentLocation'),
        position: LatLng(currentPosition.latitude, currentPosition.longitude),
        infoWindow: const InfoWindow(
          title: 'Konumunuz',
        ),
      ),
    ];
  }

  Future<List<Polyline>> _getPolylines(
      Position origin, LatLng destination) async {
    String apiKey = 'YOUR_API_KEY';
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final jsonData = json.decode(response.body);

    List<dynamic> routes = jsonData['routes'];
    if (routes.isEmpty) {
      return [];
    }

    Map<String, dynamic> route = routes[0];
    Map<String, dynamic> poly = route['overview_polyline'];
    String encodedPolyline = poly['points'];

    List<LatLng> polylineCoordinates = decodePolyline(encodedPolyline);

    return [
      Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        points: polylineCoordinates,
        width: 7,
      ),
    ];
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polylinePoints = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1e5;
      double longitude = lng / 1e5;
      LatLng point = LatLng(latitude, longitude);
      polylinePoints.add(point);
    }
    return polylinePoints;
  }
}
