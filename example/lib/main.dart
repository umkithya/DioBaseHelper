import 'dart:convert';
import 'dart:io';

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

  Future<void> uploadImageWithBytes() async {
    final dioBaseHelper = DioBaseHelper("www.api.com",
        token:
            "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiN2JkMmVhNjkxN2M4YTMwYjkxYTcxMzY5MmE5ZmY2ODAwMmJjZGE5NmU5MzIzNGRiNzI3NTFjYmJjNjU4MDY4YzA3OGE1Nzg3Y2ViMjYxYjgiLCJpYXQiOjE2Nzg4NDc3ODYuMDQ4ODY2LCJuYmYiOjE2Nzg4NDc3ODYuMDQ4ODcsImV4cCI6MTcxMDQ3MDE4Ni4wMzczMDEsInN1YiI6Ijg1MSIsInNjb3BlcyI6WyIqIl19.uOQGVd8MT1EelrToeiK7yuE-y4ey2nNmXZ-If4STcuelfe9LryU99Co0sMLbmZoKimp3I3Z2XVCWNe2IanUtYxfNlaI7yULrhjiltko5Rrv7App-iQbBnuA2b5eKqI6wLppz5bmStc9oHrhdWAgk6qpKNbz5yndwvQ5t0ayjqzFdbqtsunWtTdnYpdXeYnJ1IeckcBU8yrGqeAC_QZ3VpyqkqZv-7NLLs-amK8LCIbO88xoUvsIDMOjZRJIdRh7pe7J--iGbSjjMyesFuyyYcEOUJPg37Qu9ugVmjWO6kgqf0NhP_qZikJqf1phUJsxqwmOGSXHS5Yp7gHr8NGJpQpBmSh0fFncnyisuek4UgUevtAS5h32fJC8tVwdvBOxfzhKxIVxqYjDyUC86w22rETRYv4yVSK0DiREc61uP_BX7XkupkChR-_hieE_tFt1Htzg0qW49EkG0Gag954ToCUOMXaatCaBcAWm0KO35ry95_GVm2sak-4SHZQPqFFeC50PsXgFWnxNdEEEa2OeAngj_5vJQPvxxrSeVFwIchcIXMSErtC4bH5xe9KdGFjEHBee4u-JeHuIKRhXbGkcqUrN4B8n2ipqsHePN43z4aJMMKQC7PXAQGgAk7_V7Gszmsu_EkVJ-15JR3pHzUafq0xURGw-rC47_0qqozU2UKRw");
    XFile? xfile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (xfile != null) {
      final file = File(xfile.path).readAsBytesSync();
      String base64String = "data:image/png;base64,${base64Encode(file)}";
      // debugPrint("file: ${xfile.path}");
      await dioBaseHelper
          .onRequestFormData(
            showBodyInput: true,
            isDebugOn: true,
            formData: {
              "image": base64String,
              "receiver": 946674133,
              "template_name": "abc",
            },
            endPoint: "/create-template",
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
            await uploadImageWithBytes();
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
