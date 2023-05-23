import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../blocs/earthquake/bloc/earthquake_bloc.dart';
import '../blocs/fields/bloc/fields_bloc.dart';
import '../blocs/maps/bloc/maps_bloc.dart';
import '../blocs/permission/bloc/permission_bloc.dart';

class MapsPageButton extends StatelessWidget {
  const MapsPageButton({super.key});

  @override
  Widget build(BuildContext context) {

    return Positioned(
        bottom: 0,
        left: 2,
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height /7,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 5,
                ),
                BlocBuilder<EarthquakeBloc, EarthquakeState>(
                  builder: (context, state5) {
                    if (state5 is EarthquakeLoadedState) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          onPressed: () {
                           
                            BlocProvider.of<MapsBloc>(context).add(
                                GetEarthquakeMapsEvent(
                                  ));
                          },
                          child: const Text("DEPREMLER"));
                    }
                    if (state5 is EarthquakeLoadingState) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          onPressed: () {},
                          child: const Text("DEPREMLER"));
                    } else {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          onPressed: () {},
                          child: const Text("DEPREMLER"));
                    }
                  },
                ),



                const SizedBox(
                  width: 5,
                ),
                BlocBuilder<PermissionBloc, PermissionState>(
                  builder: (context, state2) {
                    if (state2 is PermissionGrantedState) {
                      return BlocBuilder<FieldsBloc, FieldsState>(
                        builder: (context, state) {
                          if (state is FieldLoadedState) {
                    
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                onPressed: () {
                               
                                  BlocProvider.of<MapsBloc>(context).add(
                                      GetFieldsMapsEvent(
                                          fieldList: (state)
                                              .fields,
                                          location: LatLng(state2.latitude,
                                              state2.longitude)));
                                },
                                child: const Text("TOPLANMA ALANLARI"));
                          } else if (state is FieldsLoadingState) {
                          
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                onPressed: () {},
                                child: const Text("TOPLANMA ALANLARI"));
                          } else {
                       
                            final lat = state2.latitude;
                            final lon = state2.longitude;
                            BlocProvider.of<FieldsBloc>(context)
                                .add(FetchFieldsEvent(lat: lat, lon: lon));

                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                onPressed: () {
                           
                                  BlocProvider.of<MapsBloc>(context).add(
                                      GetFieldsMapsEvent(
                                          fieldList: (state as FieldLoadedState)
                                              .fields,
                                          location: LatLng(state2.latitude,
                                              state2.longitude)));
                                },
                                child: const Text("TOPLANMA ALANLARI"));
                          }
                        },
                      );
                    } else {
                   
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          onPressed: () {
                            BlocProvider.of<PermissionBloc>(context)
                                .add(PermissionCheckEvent());
                           
                          },
                          child: const Text("TOPLANMA ALANLARI"));
                    }
                  },
                )
              ],
            )));
  }
}
