import 'dart:convert';

import 'package:dio_base_helper/dio_base_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List dataList = [];
  Future<void> fetchListData() async {
    final dioBaseHelper = DioBaseHelper("www.api.com");
    await dioBaseHelper
        .onRequest(methode: METHODE.get,url: "/list")
        .then((value) => {
              dataList.add(json.decode(value)),
            })
        .onError((ErrorModel error, stackTrace) => {
              debugPrint("Error Status code: ${error.statusCode}"),
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           ...dataList.map((e) =>Text("$e")).toList()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>fetchListData(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
