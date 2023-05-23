import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../blocs/directions/bloc/directions_bloc.dart';
import '../blocs/fields/bloc/fields_bloc.dart';
import '../blocs/permission/bloc/permission_bloc.dart';
import '../methods.dart';
import 'fields_item_maps.dart';

class FieldsItem extends StatelessWidget {
  const FieldsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<FieldsBloc>(context),
      builder: (context, state) {
        return Container(
            child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.green.withOpacity(1),
              title: Text(
                "${(state as FieldLoadedState).fields[0].city} ${state.fields[0].country}",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              floating: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (state).fields[index].name.toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                            ),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                              create: (context) =>
                                                  DirectionsBloc(),
                                              child: DirectionsPage(
                                                field:   state
                                                        .fields[index]
                                              ),
                                            )),
                                  );
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: const EdgeInsets.all(5),
                                    child: const Icon(
                                      Icons.location_on,
                                      size: 32,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 75,
                                padding: const EdgeInsets.all(7),
                                child: BlocBuilder(
                                  bloc:
                                      BlocProvider.of<PermissionBloc>(context),
                                  builder: (context, state2) {
                                    if (state2 is PermissionGrantedState) {
                                      state.fields.sort((a,
                                              b) => //state ile gelen listeyi bulundugumuz konuma olan uzaklıgına gore guncelledik.
                                          distanceCalculation(
                                                  a.longitude,
                                                  a.latitude,
                                                  state2.longitude,
                                                  state2.latitude)
                                              .compareTo(distanceCalculation(
                                                  b.longitude,
                                                  b.latitude,
                                                  state2.longitude,
                                                  state2.latitude)));

                                      return Text(
                                        "Uzaklık: ${distanceCalculation(state.fields[index].longitude, state.fields[index].latitude, state2.longitude, state2.latitude).toString()} KM", //iki bloc yapısından gelen veriler noktalar arasında ki uzaklığı hesaplamak üzere methoda yollandı.
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      );
                                    } else {
                                      return const Text(
                                        "Uzaklık: - ", //konum izni verilmediyse mesafe hesaplanamadı yazacak program hata vermeyecek.
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey,
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                      )
                    ],
                  );
                },
                childCount: (state).fields.length,
              ),
            ),
          ],
        ));
      },
    );
    ;
  }
}
