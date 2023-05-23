
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../methods.dart';
import '../models/earthquake_model.dart';
import '../models/field_model.dart';

class EarthquakeApiClient {
  static const String baseUrl = 'https://api.orhanaydogdu.com.tr';
  final http.Client httpClient = http.Client();

  Future<List<Earthquake>> getEarthquake() async {
    const String eqarthquakeUrl = '$baseUrl/deprem/kandilli/live';
    final response = await http.get(Uri.parse(eqarthquakeUrl));
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception(
          "Veri Getirilemedi"); // istek yapıldı ama veri getirilemez ise hata fırlattık.
    }
    final Map<String, dynamic> responseJson = jsonDecode(response.body);
    List<Map<String, dynamic>> mapData = List.from(responseJson['result']);
    //  print(mapData);
    List<Earthquake> list = mapData.map((e) => Earthquake.fromMap(e)).toList();
    //  print(list[45].geojson.coordinates[0]);
    print(list.length);
    return list;
  }
}

class FieldApiClient {
  static const String baseUrl = 'https://www.nosyapi.com'; 
  final http.Client httpClient = http.Client();

  Future<List<Field>> getFields(double lat,double lon) async {
     List<String>? cityAndDistrict = await getCityAndDistrictFromLocation(lat,lon) ;
     String fieldUrl = '$baseUrl/apiv2/getTurkey?id=43387&city=${cityAndDistrict![0]}&country=${cityAndDistrict[1]}';

    final response = await http.get(Uri.parse(fieldUrl), headers: {
      'Content-Type': 'application/json',
      'authorization':
          "Bearer YOUR_API_KEY"
    
    });
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception(
          "Veri Getirilemedi"); // istek yapıldı ama veri getirilemez ise hata fırlattık.
    }
    print("object");
    final Map<String, dynamic> responseJson = jsonDecode(response.body);
    print("c1");
    List<Map<String, dynamic>> mapData = List.from(responseJson['data']);
    print("c1");
    //  print(mapData);
    List<Field> list = mapData.map((e) => Field.fromMap(e)).toList();
    print("cson");
    print(list.length);
    //  print(list[45].geojson.coordinates[0]);

    return list;
  }
}
