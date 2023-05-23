
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/earthquake/bloc/earthquake_bloc.dart';
import 'earthquakes_search.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  String title;
  IconData? actionsIcon;
  IconData? leadingIcon;
  AppBarWidget(
      {super.key, required this.title, this.actionsIcon, this.leadingIcon});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        if (title == "ACİL DURUM")
          InkWell(
            onTap: () {},
            child: const Icon(
              Icons.person_add,
              size: 35,
            ),
          ),
        actionsIcon != null
            ? Icon(
                actionsIcon,
                size: 35,
              )
            : const SizedBox.shrink(),
        if (title == "KANDİLLİ RASATHANESİ")
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return [
                'En Yeni (Son 24Saat)',
                'En Eski (Son 24Saat)',
                'En Büyük (Son 24Saat)'
              ].map((String option) {
                return PopupMenuItem(
                  onTap: () {
                    if (option == "En Yeni (Son 24Saat)") {
                      BlocProvider.of<EarthquakeBloc>(context)
                          .add(FetchEarthquakeEvent(filter: "latest"));
                    } else if (option == "En Büyük (Son 24Saat)") {
                      BlocProvider.of<EarthquakeBloc>(context)
                          .add(FetchEarthquakeEvent(filter: "biggest"));
                    } else if (option == "En Eski (Son 24Saat)") {
                      BlocProvider.of<EarthquakeBloc>(context)
                          .add(FetchEarthquakeEvent(filter: "oldest"));
                    }
                  },
                  value: option,
                  child: Text(option),
                );
              }).toList();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.filter_list,
                    size: 35,
                  ),
                ],
              ),
            ),
          ),
      ],
      leading: leadingIcon != null
          ? BlocBuilder<EarthquakeBloc, EarthquakeState>(
              builder: (context, state) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => EarthquakeBloc(),
                          child: SearchPage(
                              list:
                                  (state as EarthquakeLoadedState).earthquakes),
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    leadingIcon,
                    size: 35,
                  ),
                );
              },
            )
          : const SizedBox.shrink(),
      centerTitle: true,
      title: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 2)),
          child: Text(title)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
