
import '../models/earthquake_model.dart';
import '../models/field_model.dart';
import 'api_client.dart';

class EarthquakeRepository {
EarthquakeApiClient earthquakeApiClient = EarthquakeApiClient();
Future<List<Earthquake>> getEarthquake() async{
 return await earthquakeApiClient.getEarthquake() ; 
}
} 




class FieldRepository {
FieldApiClient fieldApiClient = FieldApiClient();
Future<List<Field>> getField(double lat,double lon) async{
 return await fieldApiClient.getFields(lat,lon) ; 
}
} 