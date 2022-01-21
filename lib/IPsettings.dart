import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/csvjson.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["Hostels"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Kindacode.com',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Load Data'),
              onPressed: readJson,
            ),

            // Display the data loaded from sample.json
            _items.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Text(_items[index]["Hostel"]),
                      title: Text(_items[index]["IP Adress Range"]),
                      subtitle: Text(_items[index]["Subnet mask"]),
                    ),
                  );
                },
              ),
            )
                : Container()
          ],
        ),
      ),
    );
  }
}
