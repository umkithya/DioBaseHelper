# DioBaseHelper Plugin


Make implementation with dio more easier and short.

### Examples
Here are small examples that show you how to use dio base helper.

#### Request Network
```dart
// Obtain shared preferences.
final dioBaseHelper = await DioBaseHelper("www.api.com");

// for get method request.
    dio.onRequest(methode: METHODE.get, endPoint: "/list").then((response) {
      //here for status code 200
      debugPrint("response$response");
    }).onError((ErrorModel error, stackTrace) {
      //here for error status code
      debugPrint('Status code: ${error.statusCode}');
    });
// for post method request.
    dio.onRequest(methode: METHODE.post, endPoint: "/product",body: {
      "id": 1
    }).then((response) {
      //here for status code 200
      debugPrint("response$response");
    }).onError((ErrorModel error, stackTrace) {
      //here for error status code
      debugPrint('Status code: ${error.statusCode}');
    });

```
#### All Method Request
```dart
//for get request
Method.get
//for post request
Method.post
//for put request
Method.put
//for delete request
Method.delete
 
```

## Copyright & License

This open source project authorized by https://flutterchina.club , and the license is MIT.
