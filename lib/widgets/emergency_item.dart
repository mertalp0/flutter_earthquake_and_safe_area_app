import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../blocs/emergency/bloc/emergency_bloc.dart';
import '../blocs/permission/bloc/permission_bloc.dart';
import '../methods.dart';

class EmergencyItem extends StatelessWidget {
  const EmergencyItem({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PermissionBloc>().add(PermissionCheckEvent());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 5, left: 8),
          child: const Text(
            "Acil Durum Kişileri",
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
        BlocBuilder<EmergencyBloc, EmergencyState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const Expanded(
                  child: Center(child: CircularProgressIndicator()));
            }
            if (state is EmptyState) {
              return  Expanded(
                  child: Center(child: Container( color : Colors.white,padding: EdgeInsets.all(5),
                  child:const  Text("Henüz Kimseyi Eklemediniz.",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),))));
            }
            if (state is LoadedState) {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.persons.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 6,
                        child: Center(
                          child: ListTile(
                            leading: const Icon(
                              Icons.person,
                              size: 55,
                              color: Colors.blue,
                            ),
                            trailing: InkWell(
                              onTap: () {
                                silDialog(context, state.persons[index]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                child: const Text(
                                  "Sil",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              state.persons[index].name.toString(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              state.persons[index].phone.toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(child: Text("Beklenmedik Bir Hata Oluştu."));
            }
          },
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
            height: MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width,
            child: BlocBuilder<PermissionBloc, PermissionState>(
              builder: (context, state) {
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 207, 15, 1),
                    ),
                    onPressed: () async {
                      if (state is PermissionGrantedState) {
                        sendSMS(
                            optionalLatLong:
                                LatLng(state.latitude, state.longitude),
                            context: context);
                      } else {
                        sendSMS(context: context);
                      }
                    },
                    child: const Text(
                      "YARDIM MESAJI AT",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ));
              },
            ))
      ],
    );
  }
}
