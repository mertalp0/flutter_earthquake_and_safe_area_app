// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/earthquake/bloc/earthquake_bloc.dart';
import '../methods.dart';
import '../models/earthquake_model.dart';

class EarthquakesItems extends StatelessWidget {
  List<Earthquake>? searchResults;
  EarthquakesItems({
    Key? key,
     this.searchResults,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return BlocBuilder(
      bloc: BlocProvider.of<EarthquakeBloc>(context),
      builder: (context, state) {
           List<Earthquake>?   stateList ; 

        if(state is EarthquakeLoadedState){
        stateList =  (state).earthquakes;
        if(state.filter=="latest")
        {
          //state list tarihe gore ayarlanacak  en yeni 
          stateList.sort((a, b) => b.date.compareTo(a.date));
          
        }
        else if(state.filter =="oldest"){
            //state list tarihe gore ayarlanacak  en eski 
            stateList.sort((a, b) => a.date.compareTo(b.date));
            


        }
        else if (state.filter =="biggest"){
          stateList.sort((a, b) => b.mag.compareTo(a.mag)); // en büyük 


        }

        



        }

        
        List<Earthquake> earthquakeList ;
        if (searchResults==null) {
          earthquakeList = stateList!;  
        }
        else{
          earthquakeList = searchResults!;
        }



        return Container(
          padding: const EdgeInsets.all(2),
          child: ListView.builder(
            itemCount:earthquakeList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 75,
                            padding: const EdgeInsets.all(7),
                            child: Text(
                              earthquakeList[index].mag.toString(),
                                style: colorTextStyle(
                                   earthquakeList[index].mag)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                               earthquakeList[index].title.toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                  child: Text(
                                divideString(
                                        earthquakeList[index].date, "date")
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w400),
                              ))
                            ],
                          )),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                divideString(
                                      earthquakeList[index].date, "hour")
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                  child: Text(
                                timeDifference(earthquakeList[index].date)
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w400),
                              ))
                            ],
                          ),
                        )
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
          ),
        );
      },
    );
  }
}
