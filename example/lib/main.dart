import 'dart:convert';

import 'package:dio_base_helper/dio_base_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
        .onRequest(methode: METHODE.get, endPoint: "/list")
        .then((value) => {
              dataList.add(json.decode(value)),
            })
        .onError((ErrorModel error, stackTrace) => {
              debugPrint("Error Status code: ${error.statusCode}"),
            });
  }

  Future<void> uploadImage() async {
    final dioBaseHelper = DioBaseHelper("www.api.com",
        token:
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiI4NTU4NTc0ODAwNSIsImlhdCI6MTY3OTEwOTQ2MiwiZXhwIjo0Njc5MTA5NDYyfQ.cisPc85Tdw6FvRVhg8Uyj4Pmt6_-Kz9XkR7c8Xm9J44");
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      debugPrint("file: ${file.path}");
      await dioBaseHelper
          .onRequestFormData(
            showBodyInput: true,
            isDebugOn: true,
            formData: {
              "image": await MultipartFile.fromFile(file.path),
              "tag": "profile",
            },
            endPoint: "/upload-image",
            isAuthorize: true,
          )
          .then((value) => {
                debugPrint("value$value"),
              })
          .onError((ErrorModel error, stackTrace) => {
                debugPrint("Error Status code: ${error.statusCode}"),
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          onPressed: () async {
            await uploadImage();
          },
          icon: const Icon(Icons.upload),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[...dataList.map((e) => Text("$e")).toList()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => fetchListData(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
