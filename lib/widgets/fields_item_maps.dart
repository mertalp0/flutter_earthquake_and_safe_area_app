
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../blocs/directions/bloc/directions_bloc.dart';
import '../blocs/directions/bloc/directions_event.dart';
import '../blocs/directions/bloc/directions_state.dart';
import '../models/field_model.dart';

class DirectionsPage extends StatelessWidget {
  final Field field;

  const DirectionsPage({Key? key, required this.field}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DirectionsBloc>(context).add(GetDirections(field));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yol Tarifi'),
      ),
      body: BlocBuilder<DirectionsBloc, DirectionsState>(
        builder: (context, state) {
          if (state is DirectionsInitial) {
            // Başlangıç durumu
            return const Center(child: Text('Yol tarifi bekleniyor...'));
          } else if (state is DirectionsLoading) {
            // Yol tarifi yükleniyor durumu
            return const Center(child: CircularProgressIndicator());
          } else if (state is DirectionsLoaded) {
            return Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {},
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      state.currentPosition.latitude,
                      state.currentPosition.longitude,
                    ),
                    zoom: 17.0,
                  ),
                  circles: <Circle>{
                    ...state.circles
                  },
                  markers: <Marker>{
                    ...state.markers,
                    _createDestinationMarker(field)
                  },
                  polylines: Set<Polyline>.from(state.polylines),
                ),
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      BlocProvider.of<DirectionsBloc>(context)
                          .add(GetDirections(field));
                    },
                    child: const Icon(Icons.my_location),
                  ),
                ),
              ],
            );
          } else if (state is DirectionsError) {
            // Hata durumu
            return Center(child: Text('Yol tarifi alınamadı: ${state.error}'));
          }

          return Container();
        },
      ),
    );
  }

  Marker _createDestinationMarker(Field field) {
    return Marker(
      markerId: const MarkerId('destination'),
      position: LatLng(field.latitude, field.longitude),
      infoWindow: InfoWindow(
        title: field.name,
      ),
    );
  }
}
