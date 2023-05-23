// To parse this JSON data, do
//
//     final field = fieldFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Field fieldFromMap(String str) => Field.fromMap(json.decode(str));

String fieldToMap(Field data) => json.encode(data.toMap());

class Field {
    final String name;
    final String city;
    final String country;
    final String street;
    final String streetv2;
    final String phone;
    final String fax;
    final String website;
    final double latitude;
    final double longitude;

    Field({
        required this.name,
        required this.city,
        required this.country,
        required this.street,
        required this.streetv2,
        required this.phone,
        required this.fax,
        required this.website,
        required this.latitude,
        required this.longitude,
    });

    factory Field.fromMap(Map<String, dynamic> json) => Field(
        name: json["name"],
        city: json["city"],
        country: json["country"],
        street: json["street"],
        streetv2: json["streetv2"],
        phone: json["phone"],
        fax: json["fax"],
        website: json["website"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "city": city,
        "country": country,
        "street": street,
        "streetv2": streetv2,
        "phone": phone,
        "fax": fax,
        "website": website,
        "latitude": latitude,
        "longitude": longitude,
    };
}
