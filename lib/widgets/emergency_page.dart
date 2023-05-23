import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/emergency/bloc/emergency_bloc.dart';
import '../methods.dart';
import 'emergency_item.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
       BlocProvider.of<EmergencyBloc>(context).add(LoadPersonsEvent());
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              handleButtonPress(context);
            },
            child: const Icon(
              Icons.person_add,
              size: 35,
            ),
          )
        ],
        centerTitle: true,
        title: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey, width: 2)),
            child: const Text("ACİL DURUM")),
      ),
      body:
      Stack(children: [
            Center(
              child: Container(height: MediaQuery.of(context).size.height/3,
                          // Arka plan resminin boyutlarını ve stili burada ayarlayabilirsiniz
                          decoration: const BoxDecoration(
                            image:  DecorationImage(
                              image: AssetImage(
                                  "assets/d.jpg"),fit: BoxFit.contain 
                                  // Arka plan resmi burada belirtilir
                             
                                   // Resmin nasıl sığdırılacağı belirlenir
                            ),
                          ),
                        ),
            ),
                       Container(
                        color: Colors.white.withOpacity(
                            0.8), // Opaklık değeri burada ayarlanır (0.5 = %50 opaklık)
                      ),



        
        
        const EmergencyItem()

      ],) 
    );
  }

 


}
