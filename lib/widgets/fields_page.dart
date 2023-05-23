import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/fields/bloc/fields_bloc.dart';
import '../blocs/permission/bloc/permission_bloc.dart';
import 'appbar_widget.dart';
import 'fields_item.dart';

class FieldsPage extends StatelessWidget {
  const FieldsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Completer<void> refreshCompleter = Completer<void>();
        BlocProvider.of<PermissionBloc>(context).add(PermissionCheckEvent());
    return BlocListener<PermissionBloc, PermissionState>(
        listener: (context, state) {
          if (state is PermissionGrantedState) {
            final lat = state.latitude;
            final lon = state.longitude;
            BlocProvider.of<FieldsBloc>(context)
                .add(FetchFieldsEvent(lat: lat, lon: lon));
          }
        },
        child: Scaffold(
            appBar: AppBarWidget(
                title: "TOPLANMA ALANLARI",),
            body: Stack(children: [
                 Container(
                        // Arka plan resminin boyutlarını ve stili burada ayarlayabilirsiniz
                        decoration: const BoxDecoration(
                          image:  DecorationImage(
                            image: AssetImage(
                                "assets/a.jpg"), // Arka plan resmi burada belirtilir
                            fit: BoxFit
                                .cover, // Resmin nasıl sığdırılacağı belirlenir
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white.withOpacity(
                            0.8), // Opaklık değeri burada ayarlanır (0.5 = %50 opaklık)
                      ),



              BlocBuilder<PermissionBloc, PermissionState>(
              builder: (context, state) {
                if (state is PermissionLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is PermissionGrantedState) {
                  return BlocBuilder<FieldsBloc, FieldsState>(
                    builder: (context, state) {
                      if (state is FieldsLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is FieldLoadedState) {
                        refreshCompleter.complete();
                        refreshCompleter = Completer();
                        return RefreshIndicator(
                            child: const FieldsItem(),
                            onRefresh: () {
                              BlocProvider.of<FieldsBloc>(context).add(
                                  RefreshFieldsEvent(
                                      lat: 37.82829402, lon: 27.82834488));
                              return refreshCompleter.future;
                            });
                      }
                      if (state is FieldErrorState) {
                        return const Center(
                          child: Text("Bir Hata Oluştu"),
                        );
                      }
                      return const Center(
                        child: Text("Beklenmedik Bir Hata Oluştu"),
                      );
                    },
                  );
                }
                if (state is PermissionNotGrantedState) {
                  return const Center(
                    child: Text(
                        "SAYFANIN YÜKLENMESİ İÇİN İZİNLER VERMENİZ GEREKMEKTEDİR.."),
                  );
                } else {
                  return const Center(
                    child: Text("Bir Hata Oluştu"),
                  );
                }
              },
            )
            ],)));
  }
}
