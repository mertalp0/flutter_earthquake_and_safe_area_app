
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../blocs/earthquake/bloc/earthquake_bloc.dart';
import '../blocs/maps/bloc/maps_bloc.dart';
import '../blocs/permission/bloc/permission_bloc.dart';
import '../methods.dart';
import '../models/earthquake_model.dart';
import '../models/field_model.dart';
import 'appbar_widget.dart';
import 'maps_page_button.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MapsBloc>(context).add(GetEarthquakeMapsEvent());
    BlocProvider.of<PermissionBloc>(context).add(PermissionCheckEvent());
    BlocProvider.of<EarthquakeBloc>(context)
        .add(FetchEarthquakeEvent(filter: "latest"));
    GoogleMapController? mapController;

    return Scaffold(
        appBar: AppBarWidget(title: "HARİTA"),
        body: Stack(
          children: [
            BlocBuilder<MapsBloc, MapsState>(
              builder: (context, state) {
                String type = "";
                List list = [];
                LatLng latlng = const LatLng(39.925533, 32.866287);
                if (state is MapsLoadedState) {
                  if (state.type == "GetEarthquakeMapsEvent") {
                    list = (state.list as List<Earthquake>);
                    type = "GetEarthquakeMapsEvent";
                    latlng = state.location;
                    mapController?.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: latlng, zoom: 6.0),
                    ));
                  } else {
                    list = (state.list as List<Field>);
                    latlng = state.location;
                    type = "GetFieldsMapsEvent";
                    mapController!.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: latlng, zoom: 14.0),
                    ));
                  }
                } else if (state is MapsErrorState) {
                  return const Center(
                    child: Text("BİR HATA OLUŞTU"),
                  );
                }
                return GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  markers: type == "GetFieldsMapsEvent"
                      ? markersMethods(list as List<Field>, latlng)
                      : const <Marker>{},
                  circles: type == "GetEarthquakeMapsEvent"
                      ? circlesMethods(list as List<Earthquake>)
                      : {
                          Circle( 
                              circleId: const CircleId("1"),
                              center: LatLng(latlng.latitude,
                                  latlng.longitude), // konumun koordinatları
                              radius:
                                  20, // dairenin yarıçapı metre olarak belirlenir
                              fillColor: Colors.blue,
                              strokeColor: Colors.blue,
                              strokeWidth: 3),
                        },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latlng.latitude, latlng.longitude),
                    zoom: 6.0,
                  ),
                );
              },
            ),
            const MapsPageButton()
          ],
        ));
  }
}
