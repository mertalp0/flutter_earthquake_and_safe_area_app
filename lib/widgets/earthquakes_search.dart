import 'package:flutter/material.dart';
import '../models/earthquake_model.dart';
import 'earthquakes_items.dart';

class SearchPage extends StatefulWidget {
  final List<Earthquake> list;

  const SearchPage({super.key, required this.list});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Earthquake> _searchResults = [];
  late List<Earthquake> earthquakeList;
  @override
  void initState() {
    earthquakeList = [for (var element in widget.list) element];
    super.initState();
  }

  void _onSearchTextChanged(String searchText) {
    setState(() {
      _searchResults = earthquakeList
          .where((result) =>
              result.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Container(
          height: 80,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(right: 19),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[200],
              prefixIcon: const Icon(Icons.search),
              prefix: const SizedBox(width: 10),
              hintText: 'Arama',
            ),
            onChanged: (value) {
              _onSearchTextChanged(value);
            },
          ),
        )),
        body: Stack(

          children: [
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


            EarthquakesItems(
          searchResults: _searchResults,
        )
          ],
        ));
  }
}
