
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/earthquake/bloc/earthquake_bloc.dart';
import '../blocs/emergency/bloc/emergency_bloc.dart';
import '../blocs/fields/bloc/fields_bloc.dart';
import '../blocs/maps/bloc/maps_bloc.dart';
import '../blocs/permission/bloc/permission_bloc.dart';
import '../database/database_helper.dart';
import '../database/emergency_repositroy.dart';
import 'earthquakes_page.dart';
import 'emergency_page.dart';
import 'fields_page.dart';
import 'maps_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    BlocProvider(
      create: (context) => EarthquakeBloc(),
      child: const EarthquakePage(),
    ),
    BlocProvider(
      create: (context) => PermissionBloc(),
      child: BlocProvider(
        create: (context) => FieldsBloc(),
        child: BlocProvider(
          create: (context) => EarthquakeBloc(),
          child: BlocProvider(
            create: (context) => MapsBloc(),
            child: const MapsPage(),
          ),
        ),
      ),
    ),
    BlocProvider(
      create: (context) => FieldsBloc(),
      child: BlocProvider(
        create: (context) => PermissionBloc(),
        child: const FieldsPage(),
      ),
    ),
    BlocProvider(
      create: (context) =>
          EmergencyBloc(EmergencyRepository(DatabaseHelper.instance)),
      child: BlocProvider(
        create: (context) => PermissionBloc(),
        child: const EmergencyPage(),
      ),
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons8-earthquake-64.png',
              width: 28, // İstediğiniz genişlik değerini buraya girin
              height: 28,
            ),
            label: 'Depremler',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons8-europe-64.png',
              width: 28, // İstediğiniz genişlik değerini buraya girin
              height: 28,
            ),
            label: 'Harita',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons8-fields-48.png',
              width: 28, // İstediğiniz genişlik değerini buraya girin
              height: 28,
            ),
            label: 'Alanlar',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons8-high-priority-50.png',
              width: 28, // İstediğiniz genişlik değerini buraya girin
              height: 28,
            ),
            label: 'Acil Durum',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
