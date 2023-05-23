import 'package:meta/meta.dart';
import 'dart:convert';


Earthquake earthquakeFromMap(String str) => Earthquake.fromMap(json.decode(str));

String earthquakeToMap(Earthquake data) => json.encode(data.toMap());

class Earthquake {
    final String id;
    final String earthquakeId;
    final String provider;
    final String title;
    final String date;
    final double mag;
    final double depth;
    final Geojson geojson;



    final int createdAt;
    final String locationTz;

    Earthquake({
        required this.id,
        required this.earthquakeId,
        required this.provider,
        required this.title,
        required this.date,
        required this.mag,
        required this.depth,
        required this.geojson,
  
        required this.createdAt,
        required this.locationTz,
    });

    factory Earthquake.fromMap(Map<String, dynamic> json) => Earthquake(
        id: json["_id"],
        earthquakeId: json["earthquake_id"],
        provider: json["provider"],
        title: json["title"],
        date: json["date"],
        mag: json["mag"]?.toDouble(),
        depth: json["depth"]?.toDouble(),
        geojson: Geojson.fromMap(json["geojson"]),
       
        createdAt: json["created_at"],
        locationTz: json["location_tz"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "earthquake_id": earthquakeId,
        "provider": provider,
        "title": title,
        "date": date,
        "mag": mag,
        "depth": depth,
        "geojson": geojson.toMap(),
        
        "created_at": createdAt,
        "location_tz": locationTz,
    };
}

class Geojson {
    final String type;
    final List<double> coordinates;

    Geojson({
        required this.type,
        required this.coordinates,
    });

    factory Geojson.fromMap(Map<String, dynamic> json) => Geojson(
        type: json["type"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toMap() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    };
}

class LocationProperties {
    final ClosestCity closestCity;
    final ClosestCity epiCenter;
    final List<ClosestCity> closestCities;
    final List<Airport> airports;

    LocationProperties({
        required this.closestCity,
        required this.epiCenter,
        required this.closestCities,
        required this.airports,
    });

    factory LocationProperties.fromMap(Map<String, dynamic> json) => LocationProperties(
        closestCity: ClosestCity.fromMap(json["closestCity"]),
        epiCenter: ClosestCity.fromMap(json["epiCenter"]),
        closestCities: List<ClosestCity>.from(json["closestCities"].map((x) => ClosestCity.fromMap(x))),
        airports: List<Airport>.from(json["airports"].map((x) => Airport.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "closestCity": closestCity.toMap(),
        "epiCenter": epiCenter.toMap(),
        "closestCities": List<dynamic>.from(closestCities.map((x) => x.toMap())),
        "airports": List<dynamic>.from(airports.map((x) => x.toMap())),
    };
}

class Airport {
    final double distance;
    final String name;
    final String code;
    final Geojson coordinates;

    Airport({
        required this.distance,
        required this.name,
        required this.code,
        required this.coordinates,
    });

    factory Airport.fromMap(Map<String, dynamic> json) => Airport(
        distance: json["distance"]?.toDouble(),
        name: json["name"],
        code: json["code"],
        coordinates: Geojson.fromMap(json["coordinates"]),
    );

    Map<String, dynamic> toMap() => {
        "distance": distance,
        "name": name,
        "code": code,
        "coordinates": coordinates.toMap(),
    };
}

class ClosestCity {
    final String name;
    final int cityCode;
    final double distance;
    final int population;

    ClosestCity({
        required this.name,
        required this.cityCode,
        required this.distance,
        required this.population,
    });

    factory ClosestCity.fromMap(Map<String, dynamic> json) => ClosestCity(
        name: json["name"],
        cityCode: json["cityCode"],
        distance: json["distance"]?.toDouble(),
        population: json["population"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "cityCode": cityCode,
        "distance": distance,
        "population": population,
    };
}