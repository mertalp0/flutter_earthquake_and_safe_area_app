import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'blocs/emergency/bloc/emergency_bloc.dart';
import 'database/database_helper.dart';
import 'database/emergency_repositroy.dart';
import 'models/directory_model.dart';
import 'models/earthquake_model.dart';
import 'models/field_model.dart';

TextStyle colorTextStyle(double mag) {
  if (mag < 3) {
    return const TextStyle(
        color: Colors.green, fontSize: 35, fontWeight: FontWeight.bold);
  } else if (mag < 6) {
    return const TextStyle(
        color: Colors.orange, fontSize: 35, fontWeight: FontWeight.bold);
  } else {
    return const TextStyle(
        color: Colors.red, fontSize: 35, fontWeight: FontWeight.bold);
  }
}

String? divideString(String str, String type) {
  String result;
  if (type == "date") {
    result = str.substring(0, str.indexOf(' '));
    return result;
  } else if (type == "hour") {
    String result = str.substring(
        str.indexOf(' ') + 1, str.indexOf(':', str.indexOf(':') + 1));
    return result;
  } else {
    return null;
  }
}

String? timeDifference(String date) {
  int year = int.parse(date.substring(0, 4));
  int month = int.parse(date.substring(5, 7));
  int day = int.parse(date.substring(8, 10));
  int hour = int.parse(date.substring(11, 13));
  int minute = int.parse(date.substring(14, 16));
  int second = int.parse(date.substring(17, 19));
  DateTime givenDate = DateTime(year, month, day, hour, minute, second);

  DateTime now = DateTime.now();

  Duration difference = now.difference(givenDate);
  if (difference.inMinutes < 60) {
    return "${difference.inMinutes} dakika önce";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} saat ${difference.inMinutes.remainder(60)} dakika önce";
  } else {
    return "${difference.inDays} gün önce";
  }
}

double distanceCalculation(
    //iki nokta araso mesafeyi hesaplayan method
    double longitude,
    double latitude,
    double longitude2,
    double latitude2) {
  double distanceInMeters =
      Geolocator.distanceBetween(latitude, longitude, latitude2, longitude2);
  double distanceInKm = distanceInMeters / 1000;
  String distanceInKmThreeChars = distanceInKm.toString().substring(0, 3);
  distanceInKm = double.parse(distanceInKmThreeChars);
  //hesaplanan uzaklık verisinin ilk 3 hanesi alınır ve daha okunaklı bir ui oluşturulur.
  //print(distanceInKmThreeChars);
  return distanceInKm;
}

Future<List<String>?> getCityAndDistrictFromLocation(
    double latitude, double longitude) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
  if (placemarks.isNotEmpty) {
    Placemark placemark = placemarks[0];
    String? city = placemark.administrativeArea;
    String? district = placemark.subAdministrativeArea;
    return [city.toString(), district.toString()];
  }
  return null;
}

Set<Marker> markersMethods(List<Field> fieldsList, LatLng latlng) {
  Set<Marker> markers = {};

  for (var i = 0; i < fieldsList.length; i++) {
    markers.add(Marker(
      markerId: MarkerId("$i"),
      position: LatLng(fieldsList[i].latitude, fieldsList[i].longitude),
      infoWindow: InfoWindow(
        title: fieldsList[i].name,
        snippet: "${fieldsList[i].street} ${fieldsList[i].streetv2}",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));
  }
  markers.add(Marker(
  
    markerId: const MarkerId("konum"),
    position: latlng,
    infoWindow: const InfoWindow(
      title: "KONUMUNUZ",
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
  ));

  return markers;
}

Set<Circle> circlesMethods(List<Earthquake> earthquakeList) {
  Set<Circle> circles = {};

  for (var i = 0; i < earthquakeList.length; i++) {
    circles.add(
      Circle(
        circleId: CircleId("$i"),
        center: LatLng(earthquakeList[i].geojson.coordinates[1],
            earthquakeList[i].geojson.coordinates[0]), // konumun koordinatları
        radius: 500, // dairenin yarıçapı metre olarak belirlenir
        fillColor: earthquakeList[i].mag > 3 ? Colors.red : Colors.orange,
        strokeColor: earthquakeList[i].mag > 3 ? Colors.red : Colors.orange,
      ),
    );

    circles.add(
      Circle(
          circleId: CircleId("${i + 110}"),
          center: LatLng(
              earthquakeList[i].geojson.coordinates[1],
              earthquakeList[i]
                  .geojson
                  .coordinates[0]), // konumun koordinatları
          radius: 13000, // dairenin yarıçapı metre olarak belirlenir
          fillColor: earthquakeList[i].mag > 3
              ? Colors.red.withOpacity(0)
              : Colors.orange.withOpacity(0),
          strokeColor: earthquakeList[i].mag > 3 ? Colors.red : Colors.orange,
          strokeWidth: 3),
    );

    circles.add(
      Circle(
          circleId: CircleId("${i + 220}"),
          center: LatLng(
              earthquakeList[i].geojson.coordinates[1],
              earthquakeList[i]
                  .geojson
                  .coordinates[0]), // konumun koordinatları
          radius: 22000, // dairenin yarıçapı metre olarak belirlenir
          fillColor: earthquakeList[i].mag > 3
              ? Colors.red.withOpacity(0)
              : Colors.orange.withOpacity(0),
          strokeColor: earthquakeList[i].mag > 3 ? Colors.red : Colors.orange,
          strokeWidth: 3),
    );
  }

  return circles;
}

Future<void> sendSMS(
    {LatLng? optionalLatLong, required BuildContext context}) async {
  String message;
  String numbers = await phoneNumbers();

  if (numbers == "") {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lütfen Önce Kişi Ekleyiniz.'),
        duration: Duration(seconds: 2),
      ),
    );
  } else {
    if (optionalLatLong != null) {
      String googleMapsUrl = Uri.encodeComponent(
          'https://www.google.com/maps/search/?api=1&query=${optionalLatLong.latitude},${optionalLatLong.longitude}');
      message = 'body=YARDIMA İHTİYAÇIM VAR!!! KONUMUM : $googleMapsUrl';
    } else {
      message = 'body=YARDIMA İHTİYAÇIM VAR!!! KONUMUM : - ';
    }
    final Uri url = Uri(scheme: 'sms', path: numbers, query: message);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'SMS ekranını açarken bir hata oluştu.';
    }
  }
}

final EmergencyRepository emergencyRepository =
    EmergencyRepository(DatabaseHelper.instance);
Future<String> phoneNumbers() async {
  final persons = await emergencyRepository.getPersons();
  String concatenteadNumbers =
      persons.map((directory) => directory.phone).join(',');
  print(concatenteadNumbers);
  return concatenteadNumbers;
}

silDialog(BuildContext context, Directory person) {
  showDialog(
    context: context,
    builder: (BuildContext context2) {
      return AlertDialog(
        title: const Text('Onay'),
        content: const Text('Silmek istediğinize emin misiniz?'),
        actions: <Widget>[
          TextButton(
            child: const Text('İptal'),
            onPressed: () {
              Navigator.of(context2).pop();
            },
          ),
          TextButton(
            child: const Text('Sil'),
            onPressed: () {
              _deletePerson(context, person.id);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _deletePerson(BuildContext context, int? personId) {
  context.read<EmergencyBloc>().add(DeletePersonEvent(personId: personId!));
}

void handleButtonPress(BuildContext context) async {
  // Rehbere erişim iznini kontrol et
  PermissionStatus status = await Permission.contacts.status;
  if (status.isGranted) {
    try {
      // Rehber erişim izni verildi
      final Contact? selectedContact =
          await ContactsService.openDeviceContactPicker();
      if (selectedContact != null) {
        context
            .read<EmergencyBloc>()
            .add(AddPersonEvent(selectedContact: selectedContact));
        print('Seçilen kişi: ${selectedContact.displayName}');
        print('Kişinin numarası: ${selectedContact.phones?.first.value}');
      } else {
        // Kişi seçilmedi
        print('Hiçbir kişi seçilmedi.');
      }
    } catch (e) {}
  } else {
    // Rehber erişim izni verilmedi, izin iste
    PermissionStatus requestStatus = await Permission.contacts.request();
    if (requestStatus.isGranted) {
      // Rehber erişim izni verildi, kişi seçimi işlemini yap
      try {
        final Contact? selectedContact =
            await ContactsService.openDeviceContactPicker();
        if (selectedContact != null) {
          // Kişi seçildi, bilgileri yazdır
          context
              .read<EmergencyBloc>()
              .add(AddPersonEvent(selectedContact: selectedContact));
          print('Seçilen kişi: ${selectedContact.displayName}');
          print('Kişinin numarası: ${selectedContact.phones?.first.value}');
        } else {
          // Kişi seçilmedi
          print('Hiçbir kişi seçilmedi.');
        }
      } catch (e) {}
    } else {
      // Rehber erişim izni reddedildi
      print('Rehbere erişim izni reddedildi.');
    }
  }
}
