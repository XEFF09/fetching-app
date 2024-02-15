import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Geo.dart';

Future<Geo> fetchGeo(String loc) async {
  String uri = 'https://api.openweathermap.org/data/2.5/weather?q=${loc}&units=metric&appid=d410a6e47463183767fdb8deecb29f48';
  final res = await http.get(Uri.parse(uri));

  if (res.statusCode == 200) return Geo.fromJson(jsonDecode(res.body) as Map<String, dynamic>);

  throw Exception('Failed to fetch');
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late Future<Geo> futureGeo;
  final TextEditingController userInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureGeo = fetchGeo('Bangkok');
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('fetching'),
        ),
        body: Center(
          child: FutureBuilder<Geo>(
            future: futureGeo,
            builder: (context, x) {
              if (x.hasData) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                      child: TextField(
                        controller: userInput,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          futureGeo = fetchGeo(userInput.text);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        color: Colors.green,
                        height: 40,
                        width: 100,
                        child: Center(child: Text('click here')),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      color: Colors.amber,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(child: Text('desc: ${x.data!.description}\ntemp: ${x.data!.temp}')),
                      )),
                  ],
                );
              }
              else if (x.hasError) {
                return Text('${x.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}