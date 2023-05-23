import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/earthquake/bloc/earthquake_bloc.dart';
import 'appbar_widget.dart';
import 'earthquakes_items.dart';

class EarthquakePage extends StatelessWidget {
  const EarthquakePage({super.key});

  @override
  Widget build(BuildContext context) {
    Completer<void> refreshCompleter = Completer<void>();

    BlocProvider.of<EarthquakeBloc>(context)
        .add(FetchEarthquakeEvent(filter: "latest"));
    return Scaffold(
        appBar: AppBarWidget(
          title: "KANDİLLİ RASATHANESİ",
          leadingIcon: Icons.search,
        ),
        body: Stack(
          children: [
            Container(
              // Arka plan resminin boyutlarını ve stili burada ayarlayabilirsiniz
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/a.jpg"), // Arka plan resmi burada belirtilir
                  fit: BoxFit.cover, // Resmin nasıl sığdırılacağı belirlenir
                ),
              ),
            ),
            Container(
              color: Colors.white.withOpacity(
                  0.8), // Opaklık değeri burada ayarlanır (0.5 = %50 opaklık)
            ),
            BlocBuilder<EarthquakeBloc, EarthquakeState>(
              builder: (context, state) {
                if (state is EarthquakeLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is EarthquakeLoadedState) {
                  refreshCompleter.complete();
                  refreshCompleter = Completer();
                  return RefreshIndicator(
                      onRefresh: () {
                        BlocProvider.of<EarthquakeBloc>(context)
                            .add(RefreshEarthquakeEvent(filter: "latest"));
                        return refreshCompleter.future;
                      },
                      child: EarthquakesItems());
                }

                if (state is EarthquakesErrorState) {
                  return const Center(
                    child: Text("Bir Hata Oluştu"),
                  );
                }
                return const Center(
                  child: Text("beklenmedik Bir Hata Oluştu"),
                );
              },
            )
          ],
        ));
  }
}
